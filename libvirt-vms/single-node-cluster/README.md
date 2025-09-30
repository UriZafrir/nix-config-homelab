NODE_IP=192.168.122.206
talosctl gen config single-node-cluster https://${NODE_IP}:6443 --install-disk /dev/vda
talosctl -n ${NODE_IP} apply-config --insecure --file controlplane.yaml

export TALOSCONFIG=$PWD/talosconfig
talosctl -n ${NODE_IP} -e ${NODE_IP} bootstrap

talosctl kubeconfig -n ${NODE_IP} -e ${NODE_IP} -f ~/.kube/config
