# Shell integration for notifications on command completion

# Only source this inside Hyprland
[[ -n ${HYPRLAND_INSTANCE_SIGNATURE-} && -v commands[hyprctl] ]] || return

autoload -Uz add-zsh-hook

: ${NOTIFY_THRESHOLD=0000}

# Get active hyprland window address
__hyprland_active_window () {
  command hyprctl activewindow -j | jq -r .address
}

# Save current hyprland window address
HYPRLAND_WINDOW_ADDRESS=${ __hyprland_active_window }

# Return current time in milliseconds
unix_ms () print -P '%D{%s%3.}'

# Save time at the moment before execution and before drawing the next prompt
__save_time_preexec () \
  typeset -gi __cmd_start_time=${ unix_ms }

__save_time_precmd () {
  local now=${ unix_ms }
  [[ -v __cmd_start_time ]] || return
  typeset -gi CMD_DURATION=$(( now - __cmd_start_time ))
}

add-zsh-hook preexec __save_time_preexec

# Return human-readable (albeit minimal) duration calculated from milliseconds
duration_from_ms () {
  local h m s ms=$1
  h=$((  ms / 3600000 ))
  ms=$(( ms % 3600000 ))
  m=$((  ms / 60000 ))
  ms=$(( ms % 60000 ))
  s=$((  ms / 1000 ))
  ms=$(( ms % 1000 ))
  local durs=(${h}m ${m}m ${s}s ${ms}ms)
  print ${durs:#0*}
}

# Check if sending notification would be valid at this point
__should_notify () {
  local activeHlWin=${ __hyprland_active_window }
  [[ $activeHlWin != $HYPRLAND_WINDOW_ADDRESS ]] && (( CMD_DURATION >= NOTIFY_THRESHOLD ))
}

# Send the notification
__notify_on_command_completion () {
  local -i lastStatus=$?
  __save_time_precmd
  cmd=${ fc -Lnl -1 2>/dev/null } || return
  if __should_notify; then
    duration=${ duration_from_ms $CMD_DURATION }
    case $lastStatus in
      0) notify-send -- "✔ Finished in $duration"  "$cmd" ;;
      *) notify-send -- "✘ Failed after $duration" "$cmd" ;;
    esac
  fi
}

add-zsh-hook precmd __notify_on_command_completion

