zmodload zsh/net/tcp

# connect to kanata's tcp server
port=${KANATA_PORT-4422}
ztcp 127.0.0.1 $port
fd=$REPLY

# another fd for sending messages -- we don't want
# this one to mess with the one listening, it causes
# bugs in parsing the output somehow
ztcp 127.0.0.1 $port
fdSend=$REPLY

# hyprctl helpers
currHyprlandLayout () {
  hyprctl devices -j \
    | fx .keyboards '.find(kb => kb.name == "kanata")' .active_keymap
}
nextHyprlandLayout () hyprctl switchxkblayout kanata next

# main loop
rg 'next-layout' --line-buffered <&$fd | while read -r _; do
  nextHyprlandLayout
  currLyt=${ currHyprlandLayout }
  if [[ $currLyt = 'English (US)' ]]; then
    >&$fdSend print '{"ChangeLayer":{"new":"colemak-dh"}}'
  else
    >&$fdSend print '{"ChangeLayer":{"new":"qwerty"}}'
  fi
done

