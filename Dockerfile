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
    openssh \
    && systemctl enable sshd.service


# Install shell
RUN pacman -S --noconfirm zsh

# Install shell utilities
RUN pacman -S --noconfirm \
    neofetch \
    exa \
    htop \
    nvtop \
    bat \
    mlocate \
    rsync \
    ripgrep \
    git-delta \
    && updatedb

# Install python packages
RUN pacman -S --noconfirm \
    python \
    python-pip \
    python-poetry \
    pyenv \
    ipython

# Install IDEs (helix, emacs)
RUN pacman -S --noconfirm \
    helix \
    emacs

# Configure pacman
RUN sed -i "s|#Color|Color|" /etc/pacman.conf

# Create a non-root user with sudo privileges
RUN groupadd sudo
RUN useradd -m -G sudo -s /bin/zsh hoel
RUN sed -i "s|\# %sudo\tALL=(ALL:ALL) ALL|%sudo ALL=(ALL:ALL) NOPASSWD: ALL|" /etc/sudoers

# Install yay (and switch to non-root user)
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

RUN echo "env_default 'PAGER' 'bat'" >> ~/.oh-my-zsh/lib/misc.zsh \
    && echo "env_default 'LESS' '-FRSX'" >> ~/.oh-my-zsh/lib/misc.zsh  \
    && echo "env_default 'BAT_PAGER' = 'less -iRx4'" >> ~/.oh-my-zsh/lib/misc.zsh

# Get dotfiles
RUN git clone --separate-git-dir=$HOME/.dotfiles https://github.com/hoel-bagard/.dotfiles.git $HOME/myconf-tmp --recurse-submodules \
    && mv -v ~/myconf-tmp/.* ~/ \
    && mv -v ~/myconf-tmp/*.* ~/ \
    && rmdir myconf-tmp

# Get spacemacs
RUN git clone --single-branch --branch develop https://github.com/syl20bnr/spacemacs ~/.emacs.d

# Install plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Set the locale
ENV LANG en_US.UTF-8

CMD ["/bin/zsh"]

