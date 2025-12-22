# -----------------------------------------------------
#                      _     
# |_  _. _|_   _ _ .__|_o _  
# |_)(_|_>| | (_(_)| || |(_| 
#                        _|
# -----------------------------------------------------
# DON'T CHANGE THIS FILE
# =====================================================
# You can define your custom configuration by adding files in ~/.bashrc.d, which
# will be sourced at the shell startup.
# You can also create a .bashrc_custom file in your home directory
#
# For changing your prompt, please see ~/.bashrc.d/prompt
# =====================================================
# Configuration
# -----------------------------------------------------
fortune=false
fortune_voice=false
load_nvm=true
load_ssh_agent=false
load_blesh=true
load_linuxbrew=true
load_zoxide=true
zoxide_cmd=z












# -----------------------------------------------------
# Load function
# -----------------------------------------------------
load_dir() {
    local dir="${1:-$HOME/.bashrc.d}"

    if [ ! -d "$dir" ]; then
        echo "✖ directory $dir does not exist, or is not a directory"
        return 0
    fi

    while IFS= read -r -d '' file; do
        if [ -f "$file" ] && [[ ! "$file" =~ \.(dsd|brk)$ ]]; then
            source "$file"
        fi
    done < <(find "$dir" -type f -print0)
}

load() {
    local file="$1"

    if [ -z "$file" ]; then
        return
    fi

    if [ ! -f "$file" ]; then
        echo "✖ file $file does not exist or isn't a regular file."
        return
    fi

    source "$file"
}

# -----------------------------------------------------
# Load modular configuration
# -----------------------------------------------------
# Linuxbrew has to be loaded before loading the modular config
if [[ $load_linuxbrew == true ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# Ble.sh has to be loaded before loading the modular config
if [[ "$load_blesh" == true ]]; then
    [ -f "$HOME/.local/share/blesh/ble.sh" ] && source ~/.local/share/blesh/ble.sh
fi

load_dir ~/.bashrc.d

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------
[ -f ~/.bashrc_custom ] && load ~/.bashrc_custom

# -----------------------------------------------------
# Conditional loads
# -----------------------------------------------------
if [[ "$load_nvm" == true ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if [[ "$fortune" == true ]]; then
    fortune ~/.fortune/dev.fortune | tee ~/.for-espeak
    if [[ "$fortune_voice" == true ]]; then
        [ -x "$(command -v espeak)" ] && cat ~/.for-espeak | espeak &
        disown %1
    fi
fi

if [[ "$load_zoxide" == true ]]; then
    eval $(zoxide init --cmd "$zoxide_cmd" bash)
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

