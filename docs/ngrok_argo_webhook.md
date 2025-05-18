# NGrok e Argo Webhook

O Ngrok é uma ferramenta que permite expor serviços locais para a internet, facilitando o acesso a aplicações em desenvolvimento. O Argo Webhook é um recurso do ArgoCD que permite acionar eventos de sincronização automaticamente quando alterações são detectadas em um repositório Git.

Neste guia, vamos aprender como configurar o Ngrok para expor o Argo Webhook e permitir que o ArgoCD receba notificações de eventos de sincronização.

## Pré-requisitos
- Ter o Ngrok instalado e configurado em sua máquina.
- Ter o ArgoCD instalado e configurado em seu cluster Kubernetes.

Para instalar o Ngrok, você pode seguir as instruções disponíveis na [documentação oficial do Ngrok](https://ngrok.com/docs/getting-started/installation).

## Passo 1: Iniciar o Ngrok

Primeiro, inicie o Ngrok para expor o serviço do ArgoCD. Execute o seguinte comando no terminal:

```bash
ngrok http https://localhost:8080
```

Você verá uma saída semelhante a esta:

```
ngrok                                                                                                                  (Ctrl+C to quit)

Take our ngrok in production survey! https://forms.gle/aXiBFWzEA36DudFn6

Session Status                online
Account                       Natália Granato (Plan: Free)
Version                       3.22.1
Region                        South America (sa)
Latency                       11ms
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://44dd-177-55-231-141.ngrok-free.app -> https://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              8       2       0.21    0.21    0.10    3.80

HTTP Requests
-------------

17:50:32.921 -05 GET /assets/images/argo.png                      200 OK
17:50:32.921 -05 GET /assets/images/stars.gif                     200 OK
17:50:32.740 -05 GET /api/v1/settings                             200 OK
17:50:32.533 -05 GET /api/v1/session/userinfo                     200 OK
17:50:32.518 -05 GET /assets/favicon/favicon-32x32.png            200 OK
17:50:32.670 -05 GET /api/v1/settings                             200 OK
17:50:32.459 -05 GET /api/v1/clusters                             401 Unauthorized
17:50:32.459 -05 GET /api/v1/applications                         401 Unauthorized
17:50:32.697 -05 GET /assets/images/argo_o.svg                    200 OK
17:50:32.924 -05 GET /assets/fonts/google-fonts/Heebo-Light.woff2 200 OK
```

Você pode acessar a interface do Ngrok em `http://127.0.0.1:4040/inspect/http` para visualizar as requisições que estão sendo encaminhadas.

## Passo 2: Fazer um port-forwarding para o ArgoCD
Em outro terminal, faça um port-forwarding para o ArgoCD. Execute o seguinte comando:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Isso irá encaminhar o tráfego da porta 8080 do seu localhost para a porta 443 do serviço `argocd-server` no namespace `argocd`.


## Passo 3: Configurar o Webhook

No seu repositório Git (GitHub, GitLab, etc.), configure um webhook apontando para a URL fornecida pelo Ngrok, adicionando o endpoint do ArgoCD webhook, por exemplo:

```
https://44dd-177-55-231-141.ngrok-free.app
```

Assim, sempre que houver um push ou evento configurado, o ArgoCD receberá a notificação e poderá sincronizar automaticamente.

## Observações
- O endereço gerado pelo Ngrok muda a cada nova sessão (a menos que você tenha um plano pago com domínio fixo).
- Certifique-se de que o ArgoCD está configurado para aceitar webhooks.

## Referências
- [Documentação oficial do Ngrok](https://ngrok.com/docs)
- [Webhooks no ArgoCD](https://argo-cd.readthedocs.io/en/stable/user-guide/webhook/)