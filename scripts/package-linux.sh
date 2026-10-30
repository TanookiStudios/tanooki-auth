#!/usr/bin/env bash
# Packages the Linux release build (app/build/linux/x64/release/bundle) as a .deb and an AppImage in dist/.
# Run after: cd app && flutter build linux --release. Needs dpkg-deb; the AppImage step downloads appimagetool.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
bundle="$root/app/build/linux/x64/release/bundle"
version="$(sed -n 's/^version: \([0-9.]*\).*/\1/p' "$root/app/pubspec.yaml")"
id=com.tanookistudios.auth
out="$root/dist"
work="$(mktemp -d)"
[ -x "$bundle/tanooki-auth" ] || { echo "No Linux build at $bundle. Run flutter build linux --release first." >&2; exit 1; }
mkdir -p "$out"

desktop() { # $1 = Exec line
  cat <<DESK
[Desktop Entry]
Type=Application
Name=Tanooki Auth
Comment=Two-factor codes for your accounts
Exec=$1
Icon=$id
Categories=Utility;Security;
StartupWMClass=$id
DESK
}

# ---- .deb: app in /opt/tanooki-auth, launcher in /usr/bin ----
deb="$work/deb"
mkdir -p "$deb/DEBIAN" "$deb/opt" "$deb/usr/bin" "$deb/usr/share/applications" "$deb/usr/share/pixmaps"
cp -a "$bundle" "$deb/opt/tanooki-auth"
ln -s /opt/tanooki-auth/tanooki-auth "$deb/usr/bin/tanooki-auth"
desktop "tanooki-auth" > "$deb/usr/share/applications/$id.desktop"
cp "$bundle/data/tanooki-auth.png" "$deb/usr/share/pixmaps/$id.png"
cat > "$deb/DEBIAN/control" <<CTRL
Package: tanooki-auth
Version: $version
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Tanooki Studios <auth@tanookistudios.com>
Depends: libgtk-3-0, libsecret-1-0, libayatana-appindicator3-1
Description: Tanooki Auth
 Two-factor (TOTP) codes, kept encrypted on your computer.
CTRL
dpkg-deb --build --root-owner-group "$deb" "$out/tanooki-auth_${version}_amd64.deb"

# ---- AppImage: same bundle; GTK, libsecret and AppIndicator come from the system ----
app="$work/TanookiAuth.AppDir"
mkdir -p "$app"
cp -a "$bundle" "$app/usr"
desktop "tanooki-auth" > "$app/$id.desktop"
cp "$bundle/data/tanooki-auth.png" "$app/$id.png"
printf '#!/bin/sh\nexec "$(dirname "$(readlink -f "$0")")/usr/tanooki-auth" "$@"\n' > "$app/AppRun"
chmod +x "$app/AppRun"
tool="$work/appimagetool"
curl -fsSL -o "$tool" https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x "$tool"
ARCH=x86_64 APPIMAGE_EXTRACT_AND_RUN=1 "$tool" --no-appstream "$app" "$out/TanookiAuth-${version}-x86_64.AppImage"
ls -l "$out"
