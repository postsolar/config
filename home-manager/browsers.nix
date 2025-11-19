{ config, lib, pkgs, ... }:

let

  chrome =
    pkgs.google-chrome.override
      { commandLineArgs =
          [ "--new-window"
            "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
            "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
            # i think the 2 below are now default and dont need to be set
            # TODO check
            "--enable-wayland-ime=true"
            "--ozone-platform-hint=auto"
          ];
      };

  ff = pkgs.firefox;

  brave =
    (pkgs.brave.overrideAttrs (n: o: {
      # problem: chromium browsers dont allow configuring locale and just use system locale
      # solution: wrap it with english
      preFixup = (o.preFixup or "") +
        ''
        gappsWrapperArgs+=(
          --set "LANGUAGE" "en_US.UTF-8"
        )
        '';
    })).override {
      commandLineArgs =
          [ "--enable-features=TouchpadOverscrollHistoryNavigation"
            "--enable-wayland-ime=true"
          ];
    }
    ;

in

{
  home.packages = [
    chrome
    ff
    brave
  ];
}

