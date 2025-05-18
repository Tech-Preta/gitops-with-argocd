# Arquitetura de Componentes do Argo CD

O Argo CD foi projetado com uma arquitetura baseada em componentes. O objetivo é separar as responsabilidades em diferentes unidades implantáveis para obter os seguintes benefícios:

- **Modularidade:** Proporciona um alto nível de flexibilidade. Os componentes interagem entre si por meio de interfaces. Isso significa que, desde que o contrato da interface seja respeitado, um componente pode ser substituído sem exigir adaptações do restante do sistema. Também é possível executar o sistema sem determinados componentes caso um grupo específico de funcionalidades não seja desejado.

- **Responsabilidade única:** Ajuda a determinar onde cada tipo de funcionalidade deve ser implementada, promovendo maior coesão do sistema.

- **Reutilização:** Interfaces bem definidas facilitam a descoberta de funcionalidades, o que beneficia a reutilização de serviços.

A instalação padrão do Argo CD é composta por diferentes componentes e controladores do Kubernetes. Os controladores não são categorizados como componentes, pois possuem interfaces proprietárias (CRDs) e, portanto, não têm natureza modular. Outros recursos são criados durante a instalação do Argo CD (ConfigMaps, Services, etc), mas para simplificar, aqui abordamos apenas os diretamente relacionados à arquitetura de componentes.

---

## Dependências

O diagrama abaixo representa todas as dependências entre os diferentes componentes utilizados na instalação padrão do Argo CD:

**Diagrama de Componentes**

![Diagrama de Componentes do Argo CD](https://argo-cd.readthedocs.io/en/stable/assets/argocd-components.png)

Existem 4 camadas lógicas representadas no diagrama:

- **UI:** Camada de apresentação. Os usuários interagem com o Argo CD principalmente por meio dos componentes desta camada.
- **Application:** Funcionalidades necessárias para dar suporte aos componentes da camada UI.
- **Core:** A principal funcionalidade GitOps do Argo CD é implementada por componentes e controladores Kubernetes desta camada.
- **Infra:** Representa as ferramentas das quais o Argo CD depende como parte de sua infraestrutura.

As camadas lógicas também ajudam a tornar o diagrama mais fácil de entender, pois as dependências são representadas em uma relação de cima para baixo. Isso significa que componentes das camadas superiores podem depender de qualquer componente das camadas inferiores, mas nunca o contrário.

---

## Responsabilidades

Abaixo está uma breve descrição dos componentes do Argo CD e suas principais responsabilidades.

### Webapp

O Argo CD possui uma interface web poderosa que permite gerenciar aplicações implantadas em um cluster Kubernetes.

### CLI

O Argo CD fornece uma CLI que pode ser utilizada por usuários para interagir com a API do Argo CD. A CLI também pode ser usada para automação e scripts.

### API Server

Define a API proprietária exposta pelo Argo CD, que alimenta as funcionalidades da Webapp e da CLI.

### Application Controller

Responsável por reconciliar o recurso Application no Kubernetes, sincronizando o estado desejado da aplicação (definido no Git) com o estado atual (no Kubernetes). Também é responsável por reconciliar o recurso Project.

### ApplicationSet Controller

Responsável por reconciliar o recurso ApplicationSet.

### Repo Server

Tem papel fundamental na arquitetura do Argo CD, pois é responsável por interagir com o repositório Git para gerar o estado desejado de todos os recursos Kubernetes pertencentes a uma aplicação.

### Redis

O Redis é utilizado pelo Argo CD para fornecer uma camada de cache, reduzindo as requisições enviadas para a Kube API e para o provedor Git. Também dá suporte a algumas operações da interface web.

### Kube API

Os controladores do Argo CD se conectam à API do Kubernetes para executar o loop de reconciliação.

### Git

Como ferramenta GitOps, o Argo CD exige que o estado desejado dos recursos Kubernetes seja fornecido em um repositório Git.

> Aqui, "git" pode representar um repositório git, um repositório Helm ou um repositório de artefatos OCI. O Argo CD suporta todas essas opções.

### Dex

O Argo CD utiliza o Dex para fornecer autenticação com provedores OIDC externos. No entanto, outras ferramentas podem ser usadas no lugar do Dex. Consulte a documentação de gerenciamento de usuários para mais detalhes.