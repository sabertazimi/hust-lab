# ics-2017

Repo for ICS PAs

## Install Docker

Get docker from `https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository`

```sh
# run docker without `sudo`
sudo gpasswd -a $USER docker
```

## Install Debian Docker Image

```sh
docker build -t ics-image .
docker images
docker create --name=ics-vm -p 20022:22 ics-image
docker ps -a

docker start ics-vm
docker stop ics-vm
ssh -p 20022 sabertazimi@127.0.0.1
```

## Install tools


```sh
sudo apt-get install build-essential    # build-essential packages, include binary utilities, gcc, make, and so on
sudo apt-get install gdb                # GNU debugger
sudo apt-get install git                # reversion control system
sudo apt-get install libreadline-dev    # a library to use compile the project later
sudo apt-get install libsdl2-dev        # a library to use compile the project later
sudo apt-get install qemu-system-x86    # QEMU
sudo apt-get install vim zsh curl
```

### zsh vim

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh

scp -P 20022 username@127.0.0.1:SRC_PATH HOST_PATH
scp -P 20022 HOST_SRC_PATH username@127.0.0.1:DEST_PATH
```

### tmux

```sh
sudo apt-get install locales
locales -a
sudo locales-gen
tmux new-session -s ics
tmux attach -t ics

C-a s list sessions
C-a d detach session

C-a c create panel
C-a % horizon split
C-a " vertical split
C-a q list panel
C-a x close panel
C-a o toggle panel
```

### git

```sh
git config --global user.name "sabertazimi"
git config --global user.email sabertazimi@gmail.com
git config --global core.editor vim
git config --global push.default simple
git config --global credential.helper store
git config --global commit.template $HOME/.gitmsg.md
git config --global http.postbuffer 524288000
git config --global alias.cm "commit -v --allow-empty"
git config --list
```
