xrandr --output HDMI-1 --brightness 0.3
#export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export KUBECONFIG=~/.kube/config
source ~/.docker-aliases
GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/symlinks
alias gc='git clone'
#/home/uri/AppImages/xrandr-brightness-adjuster &
export PS1="$PS1\[\e]1337;CurrentDir="'$(pwd)\a\]'