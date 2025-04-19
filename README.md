# GitOps com ArgoCD

## O que é GitOps?
GitOps é uma abordagem de DevOps que utiliza o Git como única fonte de verdade para a infraestrutura e aplicações. Com o GitOps, todas as alterações na infraestrutura e nas aplicações são feitas, por exemplo, através de pull requests no repositório Git, permitindo um controle de versão completo e auditável. 

## O que é ArgoCD?

ArgoCD é uma ferramenta de entrega contínua (CD) para Kubernetes que permite implementar práticas de GitOps. Ele monitora repositórios Git e aplica automaticamente as alterações no cluster Kubernetes, garantindo que o estado desejado da aplicação esteja sempre em sincronia com o estado real.

## O que é Helm?

Helm é um gerenciador de pacotes para Kubernetes que facilita a instalação e o gerenciamento de aplicações no cluster. Ele utiliza charts, que são pacotes pré-configurados de recursos do Kubernetes, permitindo uma instalação rápida e fácil de aplicações complexas.

## O que é Kustomize?
Kustomize é uma ferramenta de personalização de manifestos do Kubernetes que permite criar e gerenciar configurações específicas para diferentes ambientes (desenvolvimento, teste, produção) sem duplicar os manifestos. Ele utiliza arquivos de configuração YAML para aplicar patches e sobreposições nos manifestos existentes.


O objetivo deste projeto é exemplificar o uso de GitOps para deploy automatizado e versionado de aplicações no Kubernetes, utilizando o ArgoCD como ferramenta principal de entrega contínua. São utilizados Helm e Kustomize para gerenciamento e customização dos manifestos.


---

## Pré-requisitos

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)


### Deploy com ArgoCD

1. Instale o ArgoCD no cluster Kubernetes (caso ainda não tenha):

   ```sh
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. Crie um novo Application no ArgoCD apontando para este repositório e o caminho desejado (`giropops-senhas/helm`, `giropops-senhas/kustomization` ou `random-logger/helm`).


## Detalhes dos Componentes

- **giropops-senhas**: Aplicação principal, com dependência Redis, disponível para deploy via Helm ou Kustomize.
- **random-logger**: Aplicação de exemplo para geração de logs aleatórios, deploy via Helm.

---

## Personalização

- **Helm**: Edite os arquivos `values.yaml` para customizar imagens, réplicas, portas e variáveis de ambiente.
- **Kustomize**: Modifique o `kustomization.yaml` para adicionar labels, patches ou alterar recursos.

---

## Contribuição

Contribuições são bem-vindas!  
Para contribuir, faça um fork deste repositório, crie uma branch com sua feature ou correção e abra um Pull Request.

---

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.