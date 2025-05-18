# O que é uma ApplicationSet?

## Introdução

O ApplicationSet Controller é um controlador do Kubernetes que adiciona suporte ao CustomResourceDefinition (CRD) ApplicationSet. Esse controlador/CRD permite automação e maior flexibilidade no gerenciamento de Applications do Argo CD em um grande número de clusters e em monorepositórios, além de possibilitar o uso self-service em clusters Kubernetes multi-tenant.

O ApplicationSet Controller funciona junto com uma instalação existente do Argo CD. O Argo CD é uma ferramenta declarativa de entrega contínua (GitOps), que permite aos desenvolvedores definir e controlar o deploy de recursos de aplicações Kubernetes a partir do fluxo de trabalho já existente no Git.

A partir do Argo CD v2.3, o ApplicationSet Controller já vem incluído no Argo CD.

O ApplicationSet Controller complementa o Argo CD adicionando recursos voltados para cenários de administração de clusters, como:

- Utilizar um único manifesto Kubernetes para direcionar múltiplos clusters Kubernetes com o Argo CD.
- Utilizar um único manifesto Kubernetes para fazer deploy de múltiplas aplicações a partir de um ou mais repositórios Git com o Argo CD.
- Melhor suporte a monorepos: no contexto do Argo CD, um monorepo é um repositório Git que define múltiplos recursos Application do Argo CD.
- Em clusters multi-tenant, facilita que inquilinos do cluster possam fazer deploy de aplicações usando o Argo CD, sem precisar envolver administradores privilegiados para habilitar clusters/namespaces de destino.

> **Atenção:**  
> Esteja ciente das implicações de segurança ao utilizar ApplicationSets.

---

## O recurso ApplicationSet

Veja um exemplo de definição de um novo recurso guestbook do tipo ApplicationSet:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: guestbook
spec:
  goTemplate: true
  goTemplateOptions: ["missingkey=error"]
  generators:
  - list:
      elements:
      - cluster: engineering-dev
        url: https://1.2.3.4
      - cluster: engineering-prod
        url: https://2.4.6.8
      - cluster: finance-preprod
        url: https://9.8.7.6
  template:
    metadata:
      name: '{{.cluster}}-guestbook'
    spec:
      project: my-project
      source:
        repoURL: https://github.com/infra-team/cluster-deployments.git
        targetRevision: HEAD
        path: guestbook/{{.cluster}}
      destination:
        server: '{{.url}}'
        namespace: guestbook
