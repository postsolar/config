{ pkgs, ... }:

let

  ocr = pkgs.writeShellApplication {
    name = "ocr";
    runtimeInputs = [
      pkgs.tesseract
      pkgs.fuzzel
      pkgs.grim
      pkgs.slurp
      pkgs.libnotify
      pkgs.wl-clipboard
    ];
    text =
      ''
      langs="$(tesseract --list-langs | tail -n +2 | fuzzel --dmenu --placeholder 'Select language (or multiple, chained with +)')"
      text="$(
        if [[ -v 1 ]]; then
          tesseract -l "$langs" "$1" -
        else
          tmp=$(mktemp --suffix .png)
          grim -t ppm - | satty -f - -o "$tmp" --initial-tool crop --early-exit --action-on-enter save-to-file >/dev/null 2>&1
          tesseract -l "$langs" "$tmp" -
          rm -- "$tmp"
        fi
      )"
      if [[ "$text" ]]; then
        printf '%s' "$text" | wl-copy >/dev/null 2>/dev/null
        notify-send -e -i ok -a OCR -u low 'Text copied to clipboard'
      else
        notify-send -e -i error -a OCR -u normal 'No text recognized'
        exit 1
      fi
      '';
  };

in

{
  xdg.desktopEntries = {
    ocr-image = {
      name = "OCR image";
      comment = "Retrieve text from an image";
      exec = "${ocr}/bin/ocr %F";
      # WARN IDK what filetypes tesseract actually supports
      mimeType = [ "image/*" ];
    };
    ocr-screenshot = {
      name = "OCR screenshot";
      comment = "Retrieve text from a screenshot";
      exec = "${ocr}/bin/ocr";
    };
  };

  home.packages = [ pkgs.tesseract ocr ];
}

