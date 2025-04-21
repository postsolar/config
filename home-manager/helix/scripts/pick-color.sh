#! /usr/bin/env sh
foot -a -float fish -ic "printf %s (css-colors | string trim) > /proc/$$/fd/1" 2>/dev/null
