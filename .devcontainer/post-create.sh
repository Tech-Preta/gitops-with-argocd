#!/bin/bash

set -e
set -x

# Função para verificar se o Docker está funcionando
check_docker() {
  echo "Verificando conectividade com o Docker..."
  if ! sudo docker info > /dev/null 2>&1; then
    echo "ERRO: Não foi possível conectar ao Docker. Verifique se o socket está mapeado corretamente."
    return 1
  fi
  echo "Conectividade com Docker OK!"
  return 0
}

# Função para criar um cluster KinD
create_kind_cluster() {
  echo "Criando cluster KinD..."

  # Verificar se já existe um cluster com este nome
  if sudo kind get clusters 2>/dev/null | grep -q "devcontainer-cluster"; then
    echo "Cluster 'devcontainer-cluster' já existe."
    return 0
  fi

  # Configuração do cluster KinD com mapeamento de portas
  cat > /tmp/kind-config.yaml << EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 8081
    hostPort: 8081
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
  - containerPort: 6443
    hostPort: 16443    # novo hostPort para evitar conflito
    protocol: TCP
EOF

  sudo kind create cluster --name devcontainer-cluster --config /tmp/kind-config.yaml

  echo "Configurando o contexto do kubectl..."
  mkdir -p $HOME/.kube
  sudo kind get kubeconfig --name devcontainer-cluster > $HOME/.kube/config

  # Corrige o endpoint do servidor para localhost:16443 e nomes de contexto/cluster/user
  sed -i 's|server: https://127.0.0.1:[0-9]*|server: https://127.0.0.1:16443|' $HOME/.kube/config
  sed -i 's|name: kind-.*|name: kind-devcontainer-cluster|g' $HOME/.kube/config
  sed -i 's|cluster: kind-.*|cluster: kind-devcontainer-cluster|g' $HOME/.kube/config
  sed -i 's|user: kind-.*|user: kind-devcontainer-cluster|g' $HOME/.kube/config
  sed -i 's|current-context: kind-.*|current-context: kind-devcontainer-cluster|g' $HOME/.kube/config

  sudo chown vscode:vscode $HOME/.kube/config

  # Exporta o kubeconfig para garantir que o kubectl use o contexto correto
  export KUBECONFIG=$HOME/.kube/config

  return 0
}

# Função para instalar e configurar o MetalLB no cluster Kind
install_metallb() {
  echo "Instalando MetalLB..."
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml

  echo "Aguardando pods do MetalLB ficarem prontos..."
  kubectl wait --namespace metallb-system --for=condition=available deployment/controller --timeout=120s
  kubectl wait --namespace metallb-system --for=condition=ready pod -l app=metallb --timeout=120s || true

  if [ -f /workspaces/gitops-with-argocd/metallb-config.yaml ]; then
    echo "Range de IPs configurado para o MetalLB (endereços disponíveis para LoadBalancer):"
    grep 'addresses:' -A 1 /workspaces/gitops-with-argocd/metallb-config.yaml | tail -n1 | tr -d ' -'
    echo "Aplicando configuração do MetalLB..."
    kubectl apply -f /workspaces/gitops-with-argocd/metallb-config.yaml
  else
    echo "Arquivo metallb-config.yaml não encontrado!"
  fi
}

# Função para instalar a CLI do ArgoCD e fazer o deploy no cluster Kind
install_argocd() {
  echo "Instalando CLI do ArgoCD..."

  ARGO_OS="darwin"
  if [[ $(uname -s) != "Darwin" ]]; then
    ARGO_OS="linux"
  fi

  curl -sLO "https://github.com/argoproj/argo-cd/releases/download/v2.11.3/argocd-$ARGO_OS-amd64"
  chmod +x "argocd-$ARGO_OS-amd64"
  sudo mv "./argocd-$ARGO_OS-amd64" /usr/local/bin/argocd

  echo "Deploy do ArgoCD no cluster Kind..."
  kubectl create namespace argocd || true
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

  echo "Alterando o serviço argocd-server para LoadBalancer..."
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

  echo "Aguardando o serviço argocd-server ficar disponível..."
  kubectl wait --namespace argocd --for=condition=available deployment/argocd-server --timeout=180s

  echo "IP do LoadBalancer (NodePort no KinD):"
  kubectl get svc argocd-server -n argocd

  echo "Senha inicial do admin:"
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo
}

# Instalar dependências do projeto (opcional)
install_project_deps() {
  echo "Instalando dependências adicionais do projeto..."
  # Adicione comandos adicionais aqui, se necessário
}

# Execução principal
main() {
  echo "Iniciando configuração do ambiente de desenvolvimento..."

  if check_docker; then
    create_kind_cluster
    install_metallb
    install_argocd
    install_project_deps
    echo "Ambiente de desenvolvimento configurado com sucesso!"
  else
    echo "Falha ao configurar o ambiente de desenvolvimento."
    exit 1
  fi
}

# Executar o script principal
main