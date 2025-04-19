# Conceitos Fundamentais

Vamos assumir que você já está familiarizado com os conceitos básicos de Git, Docker, Kubernetes, Entrega Contínua e GitOps. 

Abaixo estão alguns dos conceitos específicos do Argo CD.

- **Application (Aplicação):** Um grupo de recursos do Kubernetes definidos por um manifesto. Este é um Custom Resource Definition (CRD).
- **Application source type (Tipo de fonte da aplicação):** Qual ferramenta é usada para construir a aplicação.
- **Target state (Estado desejado):** O estado desejado de uma aplicação, representado por arquivos em um repositório Git.
- **Live state (Estado atual):** O estado atual dessa aplicação. Quais pods, etc., estão implantados.
- **Sync status (Status de sincronização):** Indica se o estado atual corresponde ao estado desejado. A aplicação implantada está igual ao que o Git define?
- **Sync (Sincronização):** O processo de fazer a aplicação atingir seu estado desejado, por exemplo, aplicando mudanças em um cluster Kubernetes.
- **Sync operation status (Status da operação de sincronização):** Indica se uma sincronização foi bem-sucedida ou não.
- **Refresh (Atualizar):** Compara o código mais recente no Git com o estado atual. Identifica o que está diferente.
- **Health (Saúde):** A saúde da aplicação, se está rodando corretamente e se pode atender requisições.
- **Tool (Ferramenta):** Uma ferramenta para criar manifestos a partir de um diretório de arquivos, por exemplo, Kustomize. Veja "Application Source Type".
- **Configuration management tool (Ferramenta de gerenciamento de configuração):** Veja "Tool".
- **Configuration management plugin (Plugin de gerenciamento de configuração):** Uma ferramenta personalizada.