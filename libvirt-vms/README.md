talosctl gen config talos-cluster https://192.168.122.10:6443 --output-dir ./cluster-config

talosctl apply-config --insecure --nodes 192.168.122.10 --file ./cluster-config/controlplane.yaml
