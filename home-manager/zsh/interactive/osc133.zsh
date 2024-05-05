autoload -Uz add-zsh-hook

osc133 () print -n - $'\e]133;A\e\\'
add-zsh-hook precmd osc133

