DISABLE_AUTO_UPDATE=true               # Disable automatic updates

ZSH=~/.oh-my-zsh/                      # Path to Oh My Zsh Installation
ZSH_CUSTOM=~/.oh-my-zsh/custom         # Path to custom Oh My Zsh folder
ZSH_THEME="cypher"                     # Zsh theme to load from ~/.oh-my-zsh/themes

plugins=(git zsh-syntax-highlighting)  # Plugins to load in ~/.oh-my-zsh/plugins/*
                                       # Custom plugins in  ~/.oh-my-zsh/custom/plugins

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache   # Zsh cache directory
if [[ ! -d $ZSH_CACHE_DIR ]]; then     # Create directory if not already created
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh               # Initialize Oh My Zsh