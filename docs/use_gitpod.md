# Usando o Gitpod para testar o projeto

O Gitpod é uma plataforma de código aberto para ambientes de desenvolvimento automatizados e prontos para codificação. O Gitpod é provavelmente a maneira mais fácil de se preparar para usar o ambiente de desenvolvimento, com a maioria das ferramentas necessárias para o desenvolvimento do Argo CD.

1. Faça o fork do repositório [argo-cd](https://github.com/argoproj/argo-cd) no GitHub.
2. Crie um workspace no Gitpod no seu navegador com o seguinte link:
   ```
   https://gitpod.io/#https://github.com/<USERNAME>/argo-cd
   ```

3. O Gitpod irá abrir um novo workspace com o repositório clonado e todas as dependências necessárias instaladas.

Após a criação do workspace, você pode usar o terminal integrado para executar os comandos necessários para configurar o Argo CD e implantar suas aplicações. O Gitpod fornece um ambiente de desenvolvimento completo, permitindo que você edite arquivos, execute comandos e visualize logs diretamente no navegador.

O processo de inicialização faz o download de todas as depêndências necessárias, incluindo um cluster Kubernetes local (usando o KinD) e o Argo CD. Será exibida uma mensagem "Kubeconfig is available at /home/gitpod/.kube/config" quando o cluster estiver pronto. Você pode usar o comando `kubectl` para interagir com o cluster local.

4. Execute o comando `goreman start` para iniciar o Argo CD. Isso iniciará todos os serviços necessários para o Argo CD, incluindo o servidor API, o servidor de controle e o servidor de sincronização.
5. Após o Argo CD estar em execução, você pode acessar a interface do usuário do Argo CD no navegador. O Gitpod fornece um link para acessar a interface do usuário diretamente no painel do Gitpod.
6. Para acessar a interface do usuário do Argo CD, clique no link fornecido pelo Gitpod ou acesse `https://nataliagranato-argocd-crtumq20bt1.ws-us118.gitpod.io/` no seu navegador.