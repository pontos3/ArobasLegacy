# AROBAS_ENV

## objectif

Fournir une infrastructure rassemblant

* Un serveur de base de données **SQLSERVER 2017 developer edition**
* un serveur Applicatif **Tomcat 6 java 8**
* un serveur proxy **apache-httpd**

## Installer docker et docker-compose

1. installer docker comme indiqué par le site à l'adresse suivante : [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

1. installer docker-compose comme indiqué par le site à l'adresse suivante : [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

1. Tester l'installation en chargeant une première image et un premier conteneur

Voici la ligne de commande

 ```bash
docker run hello-world
 ```

## L'arborescence du projet

``` bash
.
├── appsrv
│   ├── conf            ## Répertoire de configuration de tomcat
│   ├── pre_build       ## Répertoire où déployer les fichiers répertoires contenant les pré-livrables A3
│   ├── scripts         ## Répertoire contenant le script de démarrage du conteneur appsrv
│   └── logs            ## Répertoire où les logs seronts déposés
├── authsrv             ## Le configuration du serveur de base de données
│   ├── delivrable      ## répertoire contenant le livrable shibboleth
│   ├── export_metadata ## L'emplacement où dpéoser les fichier métadata des applications clientes du SSO
│   ├── logs            ## L'emplacement à destination des logs lorsqu'ils sont activés dan le fichier docker-compose.
│   └── scripts         ## scripts de lancement du conteneur et de prise en compte des métadonnées.
├── database            ## Le configuration du serveur de base de données
│   ├── backup          ## répertoire vers lequels ont peut envoyer les sauvegardes de base de données
│   ├── restore         ## L'emplacement des fichier .bak pour les restaurations automatique des BDD
│   └── scripts         ## Les sqcripts SQL et BASH pour la restauration des bases de données
├── proxy
│   ├── conf            ## Répertoire de conf Apache
│   └── www             ## Répertoire des fichiers statics des applications
├── sptest
│   ├── pre_build       ## emplacement des fichiers de configuration du fichier sptest
│   └── scripts         ## scripts de lancement du conteneur.
├── docker-compose.yaml ## Fichier permettant de monter l'infrastructure
└── README.md
```

## Adapter le fichier .env à son poste

Editer le fichier .env afin d'en adapter les paramètres à votre environnement.

L'exemple suivant vous indique les valeurs à mettre par défaut.

``` properties
# Numéro de port d'accès aux bases de données sqlserveur 2017 depuis le host
EXPOSE_EXPOSE_DATABASE_PORT=1433

# Numéro de port sécurisé sur lequel les applications et l'authentification sont accessibles depuis le host
EXPOSE_PROXY_HTTPS_PORT=443

# Numéro de port sur lequel les api sont accessibles depuis le host
EXPOSE_PROXY_HTTP_PORT=80

# nom d'hôte utilisé pour l'accès aux applications
EXPOSE_PROXY_APP_HOST=localhost

#nom du serveur depuis lequel l'idp est accessible sur l'hôte.
EXPOSE_PROXY_AUTH_SRV_NAME=idp

#nom de domaine depuis lequel l'idp est accessible sur l'hôte
EXPOSE_PROXY_AUTH_DOMAIN=localhost

EXPOSE_SPTEST_HOST=localhost
EXPOSE_SPTEST_SECURE_PORT=445
```

Dans le cas ou l'on souhaite adapter  le fichier, il faut s'assure des points suivants:

* les noms de domaine doivent être résolus par la machine hôte.
* les numéros de port doivent être libres pour que les conteneurs démarrent

>**Pour information** : des exemples d'URL d'accès aux API, à l'authentification ou à l'application Arobas, sont donnés dans le fichier **".env"**

## Gestion des conteneurs

### Télécharger les images, contruire et démarrer l'ensemble des conteneurs

La ligne de commande ci-dessous vous permet de télécharger, contstruire et  exécuter les différents conteneurs nécessaires à l'infra. Cette commande doit être exécutée à la racine du projet afin que le fichier .env soit pris en compte. Si le fichier .env est modifié, il est nécessaire d'exécuter à nouveau cette commande.

```bash
docker-compose up -d --build
```

Le résultat attendu est le suivant :

<details>
  <summary>Click to expand!</summary>

```bash
.
.
.
Step 10/16 : FROM unicon/shibboleth-sp:3.0.4
 ---> 201cbf433f22
Step 11/16 : WORKDIR /etc/shibboleth/
 ---> Using cache
 ---> c7dff3526bc4
Step 12/16 : COPY --from=subst /opt/pre_build/sp_shibboleth/ /etc/shibboleth/
 ---> Using cache
 ---> a14e242bc972
Step 13/16 : COPY --from=subst /opt/pre_build/appfiles/ /var/www/html/
 ---> Using cache
 ---> db8fab78f20f
Step 14/16 : COPY scripts/*.sh /opt/sptest/bin/
 ---> Using cache
 ---> 81d6424ec995
Step 15/16 : RUN mkdir -p /usr/share/etc/ssl/saml/
 ---> Using cache
 ---> cc4d85e8e43b
Step 16/16 : CMD [ "/opt/sptest/bin/wrapper.sh" ]
 ---> Using cache
 ---> 58b7d165936c

Successfully built 58b7d165936c
Successfully tagged arobaslegacy_sptest:latest
Creating network "arobaslegacy_arobas_network" with the default driver
Creating arobaslegacy_database_1 ... done
Creating arobaslegacy_appsrv_1   ... done
Creating arobaslegacy_authsrv_1  ... done
Creating arobaslegacy_sptest_1   ... done
Creating arobaslegacy_proxy_1    ... done
```

 </details>

### Démarrer l'ensemble des conteneurs sont les re-contruire

Dans le cas ou le fichier .env n'a pas été modifié, il est possible de re-démarrer l'ensemble des conteneurs plus rapidement. La ligne de commande suivante, répond à ce besoin :

```bash
docker-compose up -d
```

### Arrêter les conteneurs en les supprimant

La ligne de commande ci-dessous vous permet d'arrêter tous les conteneurs et de supprimer les images associées. Les données et les fichiers de configuration ne sont pas perdus. Cette commande doit être exécutée à la racine du projet afin que le fichier .env soit pris en compte.

```bash
docker-compose down
```

Le résultat attendu est le suivant :

<details>
  <summary>Click to expand!</summary>

```bash
Stopping arobaslegacy_proxy_1    ... done
Stopping arobaslegacy_sptest_1   ... done
Stopping arobaslegacy_authsrv_1  ... done
Stopping arobaslegacy_appsrv_1   ... done
Stopping arobaslegacy_database_1 ... done
Removing arobaslegacy_proxy_1    ... done
Removing arobaslegacy_sptest_1   ... done
Removing arobaslegacy_authsrv_1  ... done
Removing arobaslegacy_appsrv_1   ... done
Removing arobaslegacy_database_1 ... done
Removing network arobaslegacy_arobas_network
```

</details>

## Gestion du serveur de base de données

### Créer la base de données

Il est possible de créer une base de données en déposant un simple fichier de backup sqlserver dans le répertoire **"./database/restore"**.

Toutes les 60 secondes, un script consomme les fichiers **.bak** présents dans le répertoire **"./database/restore"** afin de restaurer une base de données du même nom. À la suite de ce traitement, l'extension du fichier est changée en **.oldbak**

> Attention Dans le cas où une base de données avec le même nom que le fichier à restaurer existe déjà, la base sera alors écrasée par le fichier restauré.

### Accéder à la base de données

La base de données restaurée est alors accessible en local sur le port **"{EXPOSE_DATABASE_PORT}"** à l'aide du compte **"SA"** et du mot de passe **"P@ssw0rd"**.

La base de données sera également disponible par le conteneur **"appsrv"**. Le nom dns à utiliser est **"database"**, le port est **"1433"**, le compte est **"SA"** et le mot de passe est **"P@ssw0rd"**

>debut de à modifier

## Gestion du serveur applicatif **"Tomcat"**

### Déployer une application WEB sur appsrv

Pour effectuer cette opération, il est nécessaire de posséder une archive xxx4docker.tar.gz et effectuer les opérations ci-dessous :

* déposer l'archive à la racine du projet.
* ouvrir une ligne de commande à la racine du projet
* décompresser l'archive à l'aide de la commande ci-dessous :

```bash
tar -xzf shibboleth4docker.tar.gz -C .
```

## Quelques exmples de requêtes utiles.

### Suivre les logs du conteneur appsrv

* Ouvrir une console bash sur le container appsrv

```bash
    docker-compose exec appsrv /bin/bash
```

* Lister les fichiers de logs disponibles sur le container appsrv

```bash
    docker-compose exec appsrv ls -l /usr/local/tomcat/logs/
```

* regarder les logs défiler avec la commande tail sur appsrv

```bash
    docker-compose exec appsrv tail -f /usr/local/tomcat/logs/arobas-2.7.9.log
```

* regarder les logs défiler avec la commande tail sur authsrv

```bash
    docker-compose exec authsrv tail -f /usr/local/tomcat/logs/idp-process.log
```

### Modififier le fichier log4j d'une application pour passer en debug

* Regarder le contenu du fichier log4j.propoerties d'une application existante. L'exemple est donné pour arobasapi

```bash
    docker-compose exec appsrv cat /usr/local/tomcat/webapps/arobasapi/WEB-INF/classes/log4j.properties
```

* Copier le contenu du fichier log4j.propoerties dans un fichier sur l'hôte.

```bash
    docker cp arobas_env_appsrv_1:/usr/local/tomcat/webapps/arobasapi/WEB-INF/classes/log4j.properties ./appsrv/conf/tmp/log4j.properties
```

* Modifier le fichier avant de le renvoyer sur le container.

```bash
    docker cp ./appsrv/conf/tmp/log4j.properties arobas_env_appsrv_1:/usr/local/tomcat/webapps/arobasapi/WEB-INF/classes/log4j.properties
```

* Redémarrer le conteneur afin que la modification soit prise en compte

```bash
    docker-compose restart appsrv
```
