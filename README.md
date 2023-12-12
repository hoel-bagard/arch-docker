# arch-docker
ArchLinux Dockerfile

## Usage

### Build the Docker image

```console
docker build -t archlinux-hoel-image .
```
Note: you may need to use the `--no-cache` option in order to update the package repository.

### Run it

```console
docker run --gpus all -t -i --name hoel-docker --rm archlinux-hoel-image
```

Or:

```console
docker run --gpus all -t -i -v $(pwd)/:/home/hoel/project -p 9098:9098 --name hoel-docker --rm archlinux-hoel-image zsh
```

## Environment setup

For the docker to work as expected, a few things need to be setup on the host computer or setup manually.

### Install fonts

The commands below work for an ArchLinux system ([source](https://github.com/hoel-bagard/arch-cheatsheet/blob/master/4-shell.md#install-fonts)). Other distros/Windows might need a different setup.


```console
mkdir temp_fonts
cd temp_fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
sudo mv *.ttf  /usr/share/fonts/
cd ..
rmdir temp_fonts
```

### GitHub Setup
#### ssh
If the docker will be used to create commit, then generate the keys and enter them to GitHub ([source](https://github.com/hoel-bagard/arch-cheatsheet/blob/master/3-dev_env.md#github)).

```console
ssh-keygen -t ed25519 -C "hoel.bagard@gmail.com" -f /home/hoel/.ssh/id_ed25519 -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
Finally, add the key [here](https://github.com/settings/keys)

Optional, if automating things, the github ssh key can be added automatically with:
```console
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
```

#### GPG
Follow [these instructions](https://github.com/hoel-bagard/arch-cheatsheet/blob/master/3-dev_env.md#gpg-key).
