# Check if current directory is a Git repository
test -d .git
IS_GIT=$? # 0 if yes, 1 if not
if $IS_GIT then
  git clone --depth 1 https://github.com/isoextension/dotfiles
  cd dotfiles
fi
mv ./dotfiles/.config ~ 
mv ./dotfiles/.bashrc* ~
mv ./dotfiles/.fortune ~
sudo pacman -S --needed eza gum fd ripgrep dust ranger neovim
