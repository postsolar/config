{ pkgs, ... }:

let

  ocr = pkgs.writers.writeFishBin "ocr"
    ''
    set langs (
      tesseract --list-langs \
        | fzf-window --header-lines 1 \
        | string join +
    )

    # act on the provided image if there is one, otherwise take a screenshot
    if set -q argv[1]
      set text "$(tesseract -l $langs $argv[1] -)"
    else
      # let selector window close
      sleep 0.5
      set text "$(
        # grim -t ppm - \
        #   | satty -f - -o - \
        #       --initial-tool crop \
        #       --default-hide-toolbars \
        #       --actions-on-enter save-to-file,exit \
        #   | tesseract -l $langs - -
        grim -t png -g $(slurp) - | tesseract -l $langs - -
      )"
    end

    if test -n $text
      printf '%s' $text | wl-copy &>/dev/null
      notify-send -e -i ok -a OCR -u low 'Text copied to clipboard'
    else
      notify-send -e -i error -a OCR -u normal 'No text recognized'
      exit 1
    end
    '';

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

