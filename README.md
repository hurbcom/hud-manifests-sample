# Sample application manifest catalog for [HUD](https://github.com/HurbCom/hud)

## Adding new applications

Adding a new application into HUD means you just need to create a yaml manifest file following it's [scheme](https://github.com/hurbcom/hud-manifests/wiki/Arquivo-manifest.json). After finishing your manifest file you should run `hudctl manifest-add folder-for/manifest-files-name.yml` to add it to you local manifests catalog. It will be available just for you.

If you need it to share it with your colleagues you will need to  pack and deploy the catalog on a centralized server. You can use the `Dockerfile` provided here to pack and server the catalog at any domain you would like. Then you'll need to change the `manifestUrl` at the `~/.hudctl/config.yml`

Any docker container can be "managed" by HUD, you just need to create a simple manifest file with commands to setup, start and stop and then add it to you local catalog. For instance, if you are using a docker container that does not have a manifest file it will be available at **container-name.hud** as well.


## Different types of manifests

### Local development

The application is maintained by you, the code is in your machine and is under high development.

E.g.: [Hello World](https://github.com/HurbCom/hud-manifests-sample/blob/master/manifests/manifests/hello-world.yml)

### Third-party development

The application is maintained by others and you just need to start it's container.

E.g.: [Memcached](https://github.com/HurbCom/hud-manifests-sample/blob/master/manifests/manifests/memcached.yml)

### Local Dockerfiles

The application is maintained by others but you need to do some small hacks.
In this scenario you must create a **Dockerfile** named as **your application-name-and-not-as- Dockerfile** at the `Dockerfile` folder. If you need any extra configuration file you can place it at the `Dockerfile/conf` folder.
On the following example the Thumbor dockerfile is placed as `thumbor` in the `Dockefile` folder

E.g.: [Thumbor](https://github.com/HurbCom/hud-manifests-sample/blob/master/manifests/manifests/thumbor.yml)
