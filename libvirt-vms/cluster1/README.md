https://cozystack.io/docs/install/kubernetes/talosctl/

talosctl gen config \
    cozystack https://192.168.122.10:6443 \
    --with-secrets secrets.yaml \
    --config-patch=@patch.yaml \
    --config-patch-control-plane @patch-controlplane.yaml
export TALOSCONFIG=$PWD/talosconfig


talosctl gen config \
    cozystack https://192.168.122.10:6443 \
    --with-secrets secrets.yaml \
    --config-patch=@patch.yaml \
    --config-patch-control-plane @patch-controlplane.yaml
export TALOSCONFIG=$PWD/talosconfig


talosctl gen config \
    cozystack https://192.168.122.10:6443 \
    --with-secrets secrets.yaml \
    --config-patch=@patch.yaml \
    --config-patch-control-plane @patch-controlplane.yaml
export TALOSCONFIG=$PWD/talosconfig

talosctl apply -f controlplane.yaml -n 192.168.123.11 -e 192.168.123.11 -i
talosctl apply -f controlplane.yaml -n 192.168.123.12 -e 192.168.123.12 -i
talosctl apply -f controlplane.yaml -n 192.168.123.13 -e 192.168.123.13 -i