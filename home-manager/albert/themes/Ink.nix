{ theme, lib, ... }:

let
  inherit (theme) colors;
  unhash = lib.strings.removePrefix "#";
in

# css (actually qss)
''
/* Based on Yosemite Dark theme with minimal modifications */

* {
  border: none;
  font-weight: 200;
  color: ${colors.text};
  background-color: #f4${unhash colors.background};
}

#frame {
  padding: 8px;
  background-color: #ff${unhash colors.background};

  /* Workaround for Qt to get fixed size button */
  min-width: 640px;
  max-width: 640px;
}

#inputLine {
  font-size: 16px;
  selection-color: #f4${unhash colors.background};
  selection-background-color: ${unhash colors.text};
  background-color: transparent;
}

#settingsButton {
  color: #484848;
  background-color: transparent;
  padding: 8px;

  /* Workaround for Qt to get fixed size button */
  min-width: 14px;
  min-height: 14px;
  max-width: 14px;
  max-height: 14px;
}

/* ListViews */

QListView {
  selection-color: #ffffff;
}

QListView::item:selected {
  background: ${colors.border};
}

QListView QScrollBar:vertical {
  width: 2px;
  background: transparent;
}

QListView QScrollBar::handle:vertical {
  background: #484848;
  min-height: 24px;
}

QListView QScrollBar::add-line:vertical,
QScrollBar::sub-line:vertical,
QListView QScrollBar::up-arrow:vertical,
QScrollBar::down-arrow:vertical,
QListView QScrollBar::add-page:vertical,
QScrollBar::sub-page:vertical {
  border: 0px;
  width: 0px;
  height: 0px;
  background: transparent;
}

/* actionList */

QListView#actionList {
  font-size: 14px;
}

QListView#actionList::item {
  height: 28px;
}

/* resultsList */

QListView#resultsList {
  icon-size: 24px;
  font-size: 14px;
}

QListView#resultsList::item {
  height: 48px;
}
''

