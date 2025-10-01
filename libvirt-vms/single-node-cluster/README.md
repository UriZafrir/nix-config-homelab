NODE_IP=192.168.123.90

talosctl gen secrets
<!-- talosctl gen config single-node-cluster https://${NODE_IP}:6443 --install-disk /dev/vda --config-patch @cluster-patch.yaml --with-secrets secrets.yaml -->

talosctl gen config \
    cozystack https://${NODE_IP}:6443 \
    --with-secrets secrets.yaml \
    --config-patch=@patch.yaml \
    --config-patch-control-plane @patch-controlplane.yaml \
    --install-disk /dev/vda \
    --force
export TALOSCONFIG=$PWD/talosconfig

talosctl -n ${NODE_IP} apply-config --insecure --file controlplane.yaml

talosctl -n ${NODE_IP} -e ${NODE_IP} bootstrap


rm ~/.kube/config
talosctl kubeconfig -n ${NODE_IP} -e ${NODE_IP} -f ~/.kube/config

#for reapplying the generated config use without --insecure:
#talosctl apply-config --endpoints ${NODE_IP} -n ${NODE_IP} -f controlplane.yaml
helm upgrade --install -n kube-system cilium cilium/cilium --version 1.19.0-pre.0 \
  --set operator.replicas=1 \
  --set kubeProxyReplacement=true \
  --set envoy.enabled=false

cilium:
  kubeProxyReplacement: true
  envoy:
    enabled: false
