#! /usr/bin/env sh
kitty -1 --class 'kitty -float' fish -ic "css-colors | xargs >/proc/$$/fd/1" 2>/dev/null
