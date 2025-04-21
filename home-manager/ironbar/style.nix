{ colors, fonts, ... }:

# scss
''
/* this stylesheet is meant to be used with Phocus GTK theme or something similar */

/* -- colors -- */

$col1: ${colors.background};
$col2: ${colors.border};
$text: ${colors.text};

$border_radius: 8px;

/* -- base styles -- */

* {
  border: none;
  border-radius: 0;
}

.background {
  background: none;
}

box,
menubar,
button {
  background-image: none;
  box-shadow: none;
}

button,
label {
  color: $text;
  font-size: 11px;
  font-family: "${builtins.head fonts.sansSerif}";
}

scale trough {
  min-width: 1px;
  min-height: 2px;
}

scale contents trough highlight {
  background-color: $col2;
}

scale contents trough slider {
  background: $col2;
}

/* -- the bar -- */

#bar {
  margin: 3px 6px 0px 6px;
}

box#start,
box#center,
box#end {
  background-color: rgba($col1, 0.7);
  border-radius: $border_radius;

  .widget {
    border-radius: $border_radius;
  }

  .widget:not(:hover) {
    background-color: unset;
  }
}

box#end .widget-container:first-child revealer .widget {
  padding-left: 10px
}

box#end .widget-container:last-child revealer .widget {
  padding-right: 10px
}

/* -- popups -- */

.popup {
  background-color: rgba($col1, 0.7);
  border-radius: $border_radius;
  border: 2px solid $col2;
  padding: 10px;
}

/* -- music -- */

.popup-music {

  .title .icon,
  .title .label {
    font-size: 14px;
  }

  .controls * {
    margin: 0px 4px 0px 4px;
  }

  .volume .slider slider,
  .progress .slider slider {
    border-radius: 100%;
  }
}

/* -- clock/calendar -- */

.popup-clock .calendar-clock {
  color: $text;
  font-size: 2.0em;
  padding-bottom: 0.1em;
}

.popup-clock .calendar .header {
  border-top: 1px solid $col2;
  font-size: 1.5em;
}

.popup-clock .calendar:selected {
  background-color: ${colors.selection};
}

/* -- keyboard -- */

.keyboard button:not(:hover) {
  background: none;
}

.niri-keyboard {
  margin-left: 10px;
  margin-right: 5px;
}

/* -- workspaces -- */

.workspaces {
  .item:not(:hover) {
    background: none;
  }

  .item:first-child {
    padding-left: 10px;
    border-top-left-radius: $border_radius;
    border-bottom-left-radius: $border_radius;
  }

  .item.focused:first-child {
    border-top-left-radius: $border_radius;
    border-bottom-left-radius: $border_radius;
  }

  .item:last-child {
    padding-right: 10px;
    border-top-right-radius: $border_radius;
    border-bottom-right-radius: $border_radius;
  }

  .item.focused:last-child {
    border-top-right-radius: $border_radius;
    border-bottom-right-radius: $border_radius;
  }

  .item.focused {
    background-color: rgba($col1, 0.2);
    border-bottom: 3px solid ghostwhite;
  }

  .item.urgent {
    border-bottom: 3px solid ${colors.terminalBright1};
  }
}
''
