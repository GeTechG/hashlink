#!/usr/bin/env bash
# Build SDL3 without sudo into a per-user prefix shared by every worktree, and print the
# environment `make` needs to find it. Usage: eval "$(bash .github/scripts/setup-sdl3.sh)"
# The version is the one the Build workflow installs; a second run with the prefix in place builds nothing.
set -euo pipefail
# sha256 of the SDL3-<version>.tar.gz release asset; update together with the version in build.yml
sha256=12b34280415ec8418c864408b93d008a20a6530687ee613d60bfbd20411f2785

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
version=$(grep -o 'SDL/releases/download/release-[0-9.]*' "$root/.github/workflows/build.yml" | sort -u | sed 's/.*release-//')
[[ $version =~ ^[0-9]+(\.[0-9]+)+$ ]] || { echo "setup-sdl3: no single SDL3 version in build.yml: '$version'" >&2; exit 1; }

cache=${XDG_CACHE_HOME:-$HOME/.cache}/hashlink
prefix=$cache/sdl3-$version
mkdir -p "$cache"

# the stamp is written last, so an interrupted install is rebuilt; the lock serialises parallel worktrees
exec 9>"$cache/sdl3.lock"
flock 9
if [[ ! -e $prefix/.installed ]]; then
  {
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    curl -fsSL --retry 3 --retry-delay 5 -o "$tmp/sdl.tar.gz" \
      "https://github.com/libsdl-org/SDL/releases/download/release-$version/SDL3-$version.tar.gz"
    echo "$sha256  $tmp/sdl.tar.gz" | sha256sum -c - \
      || { echo "setup-sdl3: checksum mismatch for SDL3 $version (version bumped in build.yml? update sha256 here)"; exit 1; }
    tar -xzf "$tmp/sdl.tar.gz" -C "$tmp"
    rm -rf "$prefix"
    cmake -S "$tmp/SDL3-$version" -B "$tmp/build" -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_INSTALL_LIBDIR=lib
    cmake --build "$tmp/build" --parallel "$(nproc)"
    cmake --install "$tmp/build"
    touch "$prefix/.installed"
  } >&2
fi

printf 'export PKG_CONFIG_PATH=%q${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}\n' "$prefix/lib/pkgconfig"
printf 'export LD_LIBRARY_PATH=%q${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}\n' "$prefix/lib"
