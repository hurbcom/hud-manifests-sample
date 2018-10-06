Application manifest catalog for [HUD](https://github.com/HurbCom/hud)

## Adding new applications

Par adicionar uma nova aplicação ao HUD basta criar um arquivo `manifest.json` na pasta **manifests** desse projeto, seguindo o seu [contrato](https://github.com/HurbCom/hud-manifests/wiki/Manifest-file). Após terminar o arquivo abra um pull request e logo que for aceito e for para a master, execute os comandos `make build-catalog` e `make upload-catalog`.

Se você quiser apenas ter um contêiner docker gerenciado pelo HUD para testar algo, basta criar um arquivo `manifest.json` e colocá-lo na pasta `~/.hudctl/manifests`. Qualquer contêiner docker pode ser gerenciado pelo hudctl, bastando que ele tenha um comando para ser configurado, um para iniciar e outro para ser encerrado.


## Different types of manifests

### Local development

A aplicação é mantida por você, o código dela esta na sua máquina e sempre sofre alterações.

E.g.: [Application Border Control](https://github.com/HurbCom/hud-manifests/blob/master/manifests/manifests/hello-world.yml)

### Third-party development

A aplicação é mantida por terceiros e só é preciso iniciar o container Docker dela.

E.g.: [Memcached](https://github.com/HurbCom/hud-manifests/blob/master/manifests/manifests/memcached.yml)

### Local Dockerfiles

A aplicação é mantida por terceiros mas é preciso fazer algumas pequenas configurações.
Nesse caso é necessário criar um arquivo no padrão **Dockerfile**, usando o próprio nome da aplicação, na pasta `Dockerfile` e caso necessário alguma configuração na pasta `Dockerfile/conf`

E.g.: [Thumbor](https://github.com/HurbCom/hud-manifests/blob/master/manifests/manifests/thumbor.yml)
