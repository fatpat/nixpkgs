{ stdenv, lib, makeWrapper, fetchurl,
dpkg, wrapGAppsHook, autoPatchelfHook,
gtk2-x11, gdk_pixbuf, glib, libusb, libxml2, curl }:
stdenv.mkDerivation rec {
  name = "sys_pc_tool-${version}";
  version = "6.17-1";

  src = fetchurl {
    url = "https://www.syride.com/downloads/sys-pc-tool-${version}_amd64.deb";
    sha256 = "12834706b534d9980d0b31b827aaf5227f8a8cd131a0ef3056eac7ade46f265a";
  };

  buildInputs = [
    glib
    gdk_pixbuf
    gtk2-x11
    libusb
    libxml2
    (curl.override { gnutlsSupport = true; sslSupport = false; })
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  runtimeLibs = lib.makeLibraryPath [ curl gtk2-x11 gdk_pixbuf libusb glib libxml2 ];

  unpackPhase = "dpkg-deb -x $src .";

  installTargets = [ "install" "udev-install" ];

  installPhase = ''
    mkdir -p $out
    mv usr/local/* $out/
    mkdir -p $out/lib/udev/rules.d
    mv lib/udev/rules.d/96-syride.rules $out/lib/udev/rules.d/42-syride.rules
    chmod 644 $out/lib/udev/rules.d/*

    sed -i -e "s|/usr/local/|$out/|g" $out/share/applications/*.desktop
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  meta = {
    homepage = "https://www.syride.com/fr/logiciel";
    description = "SYS PC TOOL Software";
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.jloyet ];
  };

}
