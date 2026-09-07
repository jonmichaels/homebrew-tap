#!/usr/bin/env bash
# Finalize Formula/sr.rb for a tagged sr release: download the GitHub
# release tarball, compute its sha256, and substitute the url/sha256 lines
# (replacing the "TBD" placeholder and its "# FINALIZE" marker comment).
#
# Portable: works under both GNU/Linux and macOS's older bash 3.2 / BSD
# userland (no `declare -A`, no `${var,,}`, no GNU-only sed/date flags).
#
# Usage:
#   tools/finalize-sr-formula.sh v4.0.3
#
# Prints the resulting `git diff` for Formula/sr.rb. Does not commit.

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <tag>  (e.g. v4.0.3)" >&2
  exit 1
fi

TAG="$1"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORMULA="$REPO_ROOT/Formula/sr.rb"
TARBALL_URL="https://github.com/jonmichaels/soft-return/archive/refs/tags/${TAG}.tar.gz"

if [ ! -f "$FORMULA" ]; then
  echo "error: $FORMULA not found" >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
cleanup() { rm -rf "$WORKDIR"; }
trap cleanup EXIT

TARBALL="$WORKDIR/sr-${TAG}.tar.gz"

echo "Downloading $TARBALL_URL ..." >&2
curl -fsSL -o "$TARBALL" "$TARBALL_URL"

# sha256sum is GNU/Linux; shasum -a 256 is what macOS ships instead.
# Prefer sha256sum where present, else shasum.
if command -v sha256sum >/dev/null 2>&1; then
  SHA256="$(sha256sum "$TARBALL" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  SHA256="$(shasum -a 256 "$TARBALL" | awk '{print $1}')"
else
  echo "error: neither sha256sum nor shasum found" >&2
  exit 1
fi

if [ -z "$SHA256" ]; then
  echo "error: failed to compute sha256" >&2
  exit 1
fi

VERSION="${TAG#v}"
NEW_URL="https://github.com/jonmichaels/soft-return/archive/refs/tags/${TAG}.tar.gz"

# sed -i differs between GNU and BSD (BSD requires an explicit, even if
# empty, backup suffix argument). The `-i.bak` + rm form works on both.
sed -i.bak \
  -e "s#^  url \".*\"#  url \"${NEW_URL}\"#" \
  -e "s#^  sha256 \"TBD\".*#  sha256 \"${SHA256}\"#" \
  "$FORMULA"
rm -f "${FORMULA}.bak"

echo "Set url to ${NEW_URL}" >&2
echo "Set sha256 to ${SHA256}" >&2
echo "" >&2
echo "sr version: ${VERSION}" >&2
echo "" >&2

if command -v git >/dev/null 2>&1 && git -C "$REPO_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$REPO_ROOT" diff -- Formula/sr.rb
else
  echo "(not a git checkout -- printing finalized formula instead)" >&2
  cat "$FORMULA"
fi
