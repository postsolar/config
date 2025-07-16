{ config, lib, pkgs, ... }:

let

  chrome =
    pkgs.google-chrome.override
      { commandLineArgs =
          [ "--new-window"
            "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
            "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation"
            "--enable-wayland-ime=true"
            "--ozone-platform-hint=auto"
          ];
      };

  ff = pkgs.firefox;

  brave =
    (pkgs.brave.overrideAttrs (n: o: {
      # postInstall = (o.postInstall or "") +
      #   ''
      #   sed -i 's/exec -a/exec -a env LANGUAGE=en_US.UTF-8 /' $out/bin/brave
      #   '';
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

