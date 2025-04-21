{ pkgs, ... }:

{
  home.packages = [
    pkgs.flameshot
  ];

  services = {
    flameshot = {
      # don't know why but copy doesn't work when started as a systemd unit,
      # even if i write a unit from scratch.
      # also doesn't work if wl-clipboard is accompanied by copyq.
      # so, just launch it without systemd
      # enable = true;
      package = pkgs.flameshot;
    };
  };

  xdg.configFile."flameshot/flameshot.ini".text =
    ''
    [General]
    uiColor=#83618d
    contrastUiColor=#fbb22a
    startupLaunch=true
    allowMultipleGuiInstances=true
    copyOnDoubleClick=true
    copyPathAfterSave=true
    saveAsFileExtension=png
    savePath=/data/Pictures/Screenshots
    showDesktopNotification=false
    showHelp=false
    showStartupLaunchMessage=false

    [Shortcuts]
    TYPE_COPY=Return
    '';

}

