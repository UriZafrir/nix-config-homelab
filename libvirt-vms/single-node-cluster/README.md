NODE_IP=192.168.123.99
talosctl gen config single-node-cluster https://${NODE_IP}:6443 --install-disk /dev/vda --config-patch @cluster-patch.yaml
talosctl -n ${NODE_IP} apply-config --insecure --file controlplane.yaml

export TALOSCONFIG=$PWD/talosconfig
talosctl -n ${NODE_IP} -e ${NODE_IP} bootstrap


rm ~/.kube/config
talosctl kubeconfig -n ${NODE_IP} -e ${NODE_IP} -f ~/.kube/config



#talosctl -n ${NODE_IP} apply-config  --file controlplane.yaml
#talosctl apply-config --endpoints ${NODE_IP} -n ${NODE_IP} -f controlplane.yaml
