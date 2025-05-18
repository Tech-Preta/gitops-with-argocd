# GitOps com Argo CD

Este repositório demonstra a implementação de GitOps utilizando o Argo CD para gerenciar aplicações Kubernetes, incluindo exemplos de ApplicationSet, App of Apps, Helm e Kustomize.

## Estrutura do Projeto

- **applications/**: Manifests do Argo CD para aplicações, incluindo App of Apps e ApplicationSet.
- **app-of-apps/**: Helm chart para o padrão App of Apps, facilitando o gerenciamento de múltiplas aplicações via um único manifesto.
- **app-of-apps-monitoring/**: Helm chart para monitoramento, incluindo aplicações como Grafana e Prometheus.
- **giropops-senhas/**: Exemplo de aplicação com deploy via Helm e Kustomize, incluindo dependências como Redis.
- **random-logger/**: Exemplo de aplicação com deploy via Helm.
- **grafana/** e **prometheus/**: Valores customizados para as aplicações de monitoramento.

## Principais Conceitos

### GitOps
GitOps é uma abordagem para automação de infraestrutura e aplicações baseada em Git como fonte única de verdade e ferramentas de reconciliação como o Argo CD.

### Argo CD
O Argo CD é uma ferramenta de Continuous Delivery para Kubernetes baseada em GitOps. Ele sincroniza o estado do cluster com o que está definido no repositório Git.

### App of Apps
O padrão App of Apps permite gerenciar múltiplas aplicações Argo CD a partir de um único manifesto, facilitando a organização e o versionamento.

### ApplicationSet
Permite criar múltiplas aplicações Argo CD de forma dinâmica, útil para cenários multi-cluster ou multi-ambiente.

### Helm e Kustomize
O projeto utiliza Helm charts e Kustomize para empacotamento e customização dos manifests Kubernetes.

## Como usar

1. **Suba um cluster Kubernetes local (ex: Kind ou Minikube).**
2. **Instale o Argo CD:**
   ```sh
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```
3. **Acesse o Argo CD UI:**
   ```sh
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   # Acesse https://localhost:8080
   ```
4. **Aplique os manifests do diretório `applications/` para criar as aplicações no Argo CD:**
   ```sh
   kubectl apply -f applications/
   ```
5. **Acompanhe o deploy e sincronização das aplicações via interface do Argo CD.**

## Referências
- [Documentação oficial do Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [GitOps com Argo CD - Guia prático](https://github.com/argoproj/argo-cd)
