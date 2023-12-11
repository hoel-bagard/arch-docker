# Use the official Arch Linux base image from the Docker Hub
FROM archlinux:base

# Update the package repository
RUN pacman -Syu --noconfirm

# Install base packages
RUN pacman -S --noconfirm \
  base-devel \
  sudo \
  wget \
  git \
  openssh

# Install shell
RUN pacman -S --noconfirm \
  zsh \
  neofetch

# Install python packages
RUN pacman -S --noconfirm \
  python \
  python-pip \
  python-poetry \
  pyenv \
  ipython

# Install IDE (helix)
RUN pacman -S --noconfirm \
  helix

# Create a non-root user with sudo privileges
RUN groupadd sudo
RUN useradd -m -G sudo -s /bin/zsh hoel
RUN sed -i "s|\# %sudo\tALL=(ALL:ALL) ALL|%sudo ALL=(ALL:ALL) NOPASSWD: ALL|" /etc/sudoers

# Install yay
USER hoel
WORKDIR /home/hoel
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -si --noconfirm \
  && cd .. \
  && rm -r yay

# Setup shell
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

RUN yay -S --noconfirm zsh-theme-powerlevel10k-git \
  && echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# RUN mkdir temp_fonts \
#   && cd temp_fonts \
#   && wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf \
#   && wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf \
#   && wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf \
#   && wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf \
#   && sudo mv *.ttf  /usr/share/fonts/ \
#   && cd .. \
#   && rmdir temp_fonts


# # "hoel.bagard@gmail.com"
# ssh-keygen -t ed25519 -C "hoel.bagard.hy@hitachi-hightech.com" -f /home/hoel/.ssh/id_ed25519 -N ""
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519
# cat ~/.ssh/id_ed25519.pub
# # -> Need to be manually added to GH to work.

# mkdir ~/.ssh
# chmod 700 ~/.ssh
# ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

# Get dotfiles
RUN git clone --separate-git-dir=$HOME/.dotfiles https://github.com/hoel-bagard/.dotfiles.git $HOME/myconf-tmp --recurse-submodules \
  && mv -v ~/myconf-tmp/.* ~/ \
  && mv -v ~/myconf-tmp/*.* ~/ \
  && rmdir myconf-tmp

# Install plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Set the locale
ENV LANG en_US.UTF-8

WORKDIR /home/hoel
CMD ["/bin/zsh"]

