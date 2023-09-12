#!/bin/bash
set -e

# Eliminar swap file || true es para permitir que el script siga ejecutandose si el comando falla
swapoff /swap.img || true
sed -i '/^\/swap\.img/d' /etc/fstab || true

# Instalar docker a cri-dockerd
apt update && apt upgrade -y
apt install wget docker.io -y
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.4/cri-dockerd_0.3.4.3-0.ubuntu-jammy_amd64.deb
apt install ./cri-dockerd_0.3.4.3-0.ubuntu-jammy_amd64.deb

# Instalar kubeadm, kubelet y kubectl
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


# Funcion a ejecutar si se esta instalando kubernetes en head
install_head() {
  # Inicializar kubeadm con el socket de cri-dockerd y la red flannel
  kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock

  # Configurar kubectl para el usuario head
  su head << EOF
    rm -rf \$HOME/.kube
    mkdir -p \$HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config
    sudo chown head \$HOME/.kube/config
    echo "export KUBECONFIG=\$HOME/.kube/config" >> \$HOME/.bashrc
EOF
  echo -e "Instalando red flannel ...\n\n"
  export KUBECONFIG=/etc/kubernetes/admin.conf
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
}

# Preguntar si se esta instalando kubernetes en head
read -p "Instalar head? (yes/no): " choice
case "$choice" in
  [Yy][Ee][Ss]|[Yy])
    install_head
    ;;
  *)
    echo -e "Instalacion finalizada. Ejecuta el comando 'kubeadm join' \ncon los parametros que se muestran en el nodo head y el \nargumento '--cri-socket=unix:///var/run/cri-dockerd.sock'."
    ;;
esac

