# arch-docker
ArchLinux Dockerfile

## Usage

### Build the Docker image

```console
docker build -t archlinux-hoel-image .
```

### Run it

```console
docker run --gpus all -t -i --name hoel-docker --rm archlinux-hoel-image
```

Or:

```console
docker run --gpus all -t -i -v $(pwd)/:/home/hoel/project -p 9098:9098 --name hoel-docker --rm archlinux-hoel-image zsh
```
