#! /bin/bash

LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;36;40:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# If XDG_RUNTIME_DIR is not set, set it to a sane default
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR=/run/user/$UID
    if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
        export XDG_RUNTIME_DIR=/tmp/$USER-runtime
        if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
          mkdir -m 0700 "$XDG_RUNTIME_DIR"
        fi
    fi
fi

# If WSL then prepend wsl distro name to PS1 and set DISPLAY
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    if echo $PS1 | grep -v WSL > /dev/null; then
        export PS1="WSL:$WSL_DISTRO_NAME $PS1"
    fi

    if [[ -z "$DISPLAY" ]]; then
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    fi

    alias ls="ls -I NTUSER.DAT\* --color=auto"
fi

# If WSL use windows ssh-agent if possible
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    LOCALAPPDATA=$(wslpath "$(wslvar LOCALAPPDATA)")
    test -f "$LOCALAPPDATA/wsl-ssh-agent.sock" && export SSH_AUTH_SOCK="$LOCALAPPDATA/wsl-ssh-agent.sock"
fi

echoretval() { "$@"; echo 'exited with value:' $?; }
alias sshu="ssh -o StrictHostKeyChecking=no"
alias R="R --no-save --no-restore --quiet"

function _docker-args-or-ps-q() {
    if [[ $# -gt 0 ]]; then
	(for x in "$@"; do
	    docker ps -q -f name="$x"
	    docker ps -q -f id="$x"
	done) | sort | uniq
    else
	docker ps -q
    fi
}

function _docker-args-or-images-q() {
    if [[ $# -gt 0 ]]; then
	(for x in "$@"; do
	    docker images -q -f reference="*$x*"
	    docker images -q | fgrep "$x"
	done) | sort | uniq
    else
	docker images -q
    fi
}

function docker-ip() {
   _docker-args-or-ps-q "$@" \
       | xargs -r docker inspect -f '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
       | sed 's/^.//' \
       | column -t
}

function docker-ports() {
    _docker-args-or-ps-q "$@" \
	| xargs -r docker inspect -f '{{ .Name }} {{ range $k, $v := .NetworkSettings.Ports }}{{ printf "\n\t" }}{{ $k }} {{ $v }}{{ end }}' \
	| sed 's/^\S//' \
	| awk 'BEGIN {print "CONTAINER", "PORT", "BIND"}; /^\S/ {prefix=$1}; /^\s/ {print prefix, $0}' \
	| column -t
}

function docker-ports-json() {
    (
	echo -n '['
	previous=0
	for x in $(_docker-args-or-ps-q "$@"); do
	    echo -ne "{\"$(docker inspect -f '{{ .Name }}' $x | sed 's/^.//')\":"
	    docker inspect -f '{{ json .NetworkSettings.Ports }}' $x
	    echo -ne "},"
	done
	echo -n ']'
    ) \
	| sed -e 's/,}/}/' -e 's/,]/]/' \
	| jq
}

function docker-mounts() {
    _docker-args-or-ps-q "$@" \
	| xargs -r docker inspect -f '{{ .Name }}{{ range .Mounts }}{{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }} {{ .Name }} {{ .Destination }}{{ end }}' \
	| sed 's/^\///' \
	| awk 'BEGIN {print "CONTAINER", "TYPE", "VOLUME", "MOUNTED"}; /^\S/ {prefix=$1}; /^\s/ {print prefix, $0}' \
	| column -t
}

function docker-mounts-json() {
    (
	echo -n '['
	previous=0
	for x in $(_docker-args-or-ps-q "$@"); do
	    echo -ne "{\"$(docker inspect -f '{{ .Name }}' $x | sed 's/^.//')\":"
	    docker inspect -f '{{ json .Mounts }}' $x
	    echo -ne "},"
	done
	echo -n ']'
    ) \
	| sed -e 's/,}/}/' -e 's/,]/]/' \
	| jq
}

function docker-image-volumes() {
    _docker-args-or-images-q "$@" \
	| xargs -r docker image inspect -f '{{ index .RepoTags 0 }}{{ range $k, $v := .ContainerConfig.Volumes }}{{ printf "\n\t" }}{{ $k }}{{ printf "\t" }}{{ $v }}{{ end }}' \
	| awk 'BEGIN {print "TAG", "MOUNTPOINT", "OPTIONS"}; /^\S/ {prefix=$1}; /^\s/ {print prefix, $0}' \
	| column -t
}

alias docker-volume-cleanup="(docker volume ls  -f dangling=true -f driver=local -q | awk '/[0-9a-f]{64}/ {print}' | xargs docker volume rm)"
alias docker-volume-ls-unnamed="(docker volume ls -q | awk '/[0-9a-f]{64}/ {print}')"
alias docker-volume-ls-named="(docker volume ls -q | awk '/[^0-9a-f]/ || length != 64 {print}')"

alias docker-cleanup="docker system prune --force; docker-volume-cleanup"

function docker-stop-rm() { docker stop "$@"; docker rm -v "$@"; }

function pip-install-save {
    pip install $1 && pip freeze | grep $1 >> requirements.txt
}

function functions() {
    compgen -A function
}
function functionaliaslist() {
    echo
    echo -e "\033[1;4;32m""Functions:""\033[0;34m"
    compgen -A function
    echo
    echo -e "\033[1;4;32m""Aliases:""\033[0;34m"
    compgen -A alias
    echo
    echo -e "\033[0m"
}
source ~/dotfiles/pathutils.sh

path_has $PATH ~/.local/bin || export PATH=$PATH:~/.local/bin
path_has $PATH ~/.local/lib/npm/bin || export PATH=$PATH:~/.local/lib/npm/bin
path_has $PATH ~/bin || export PATH=$PATH:~/bin

# rm permanently? using nvmi instead
# export NPM_CONFIG_PREFIX=~/.local/lib/npm

if [[ -z "$HOMEBREW_PREFIX" ]]; then
    if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
fi

# if [ -r ~/.Xresources -a -n $(command -v xrdb) ]; then
#     xrdb -merge ~/.Xresources
# fi

if type -P keychain > /dev/null; then
    eval $(keychain -q --eval)
fi

activate () {
    if [[ $# != 0 ]]; then
        pushd "$1" || return
    fi
    . ./bin/activate
    if [[ $# != 0 ]]; then
        popd
    fi
}
