# -----------------------------------------------------
#                      _     
# |_  _. _|_   _ _ .__|_o _  
# |_)(_|_>| | (_(_)| || |(_| 
#                        _|
# -----------------------------------------------------
# DON'T CHANGE THIS FILE
# =====================================================
# You can define your custom configuration by adding
# files in ~/.bashrc.d
# with copies of files from ~/.bashrc.d
# You can also create a .bashrc_custom file in your home directory
# =====================================================
# Configuration
# -----------------------------------------------------
fortune=true
fortune_voice=false
load_nvm=true
load_ssh_agent=false
load_blesh=true
load_linuxbrew=true













# -----------------------------------------------------
# Load function
# -----------------------------------------------------
load_dir() {
    local dir="${1:-$HOME/.bashrc.d}"

    if [ ! -d "$dir" ]; then
        echo "✖ directory '$dir' does not exist"
        return 0
    fi

    while IFS= read -r -d '' file; do
        if [ -f "$file" ] && [[ ! "$file" =~ \.(disabled|broken)$ ]]; then
            source "$file"
        fi
    done < <(find "$dir" -type f -print0)
}

# -----------------------------------------------------
# Load modular configuration
# =====================================================
# Linuxbrew has to be loaded before loading the modular config
if [[ $load_linuxbrew == "true" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
load_dir ~/.bashrc.d

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------
if [ -f ~/.bashrc_custom ]; then
    source ~/.bashrc_custom
fi

# -----------------------------------------------------
# Conditional loads
# -----------------------------------------------------
if [[ "$load_nvm" == true ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if [[ "$load_blesh" == true ]]; then
    [ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
fi

if [[ "$fortune" == true ]]; then
    fortune ~/.fortune/dev.fortune | grep -v \\-\\- 2>/dev/null | tee ~/.for-espeak
    if [[ "$fortune_voice" == true ]]; then
        [ -x "$(command -v espeak)" ] && cat ~/.for-espeak | espeak &
        disown %1
    fi
fi
