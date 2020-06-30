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
│   ├── webapps         ## Répertoire où déployer les fichiers war des applications
│   └── logs            ## Répertoire où les logs seronts déposés
├── database            ## Le configuration du serveur de base de données
│   ├── Dockerfile      ## Le DokerFile permettant d'adapter la base de données
│   ├── restore         ## L'emplacement des fichier .bak pour les restauration des BDD
│   └── scripts         ## Les sqcripts SQL et BASH pour la restauration des bases de données
├── docker-compose.yaml ## Fichier permettant de monter l'infrastructure
├── proxy
│   ├── conf            ## Répertoire de conf Apache
│   └── www             ## Répertoire des fichiers statics des applications
└── README.md
```

## Adapter le fichier docker-compose.yaml à son poste

Editer le fichier docker-compose.yaml afin d'en adapter les paramètres à votre environnement.

Le yaml suivant vous indique l'emplacement de des paramètres.

``` yaml
version: '3.7'
services:
    database:
        build: ./database
        image: mcr.microsoft.com/mssql/server:2017-latest
        environment:
            SA_PASSWORD: {DATABASE_SA_PASSWORD}
            ACCEPT_EULA: Y
        volumes:
            - {DATABASE_DATA_DIR}:/var/opt/mssql/data/
            - {DATABASE_BACKUP_DIR}:/var/opt/mssql/backup/
            - {DATABASE_RESTORE_DIR}:/var/opt/mssql/restore/
        ports:
            - "{DATABASE_PORT}:1433"
        networks:
            arobas_network:

    appsrv:
        image: tomcat:6.0.48
        depends_on:
            - database
        ports:
            - "{APPSRV_PORT}:8080"
        volumes:
            - {APPSRV_CONF_DIR}:/usr/local/tomcat/conf
            - {APPSRV_WEBAPPS_DIR}:/usr/local/tomcat/webapps
            - {APPSRV_LOGS_DIR}:/usr/local/tomcat/logs
        networks:
            arobas_network:

    proxy:
        image: httpd:2.4.41-alpine
        depends_on:
            - appsrv
        ports:
            - "{PROXY_PORT}:80"
        volumes:
            - {PROXY_CONF_DIR}:/usr/local/apache2/conf/
            - {PROXY_WEB_DIR}:/usr/local/apache2/htdocs/
        networks:
            arobas_network:

networks:
    arobas_network:  # Docker sharing network

```

### les différents paramètres

La liste ci-dessous indique la signification de chaque paramètre du fichier docker-compose.yaml

* ***{DATABASE_SA_PASSWORD}*** : Mot de passe du compte SA de la base ***SQLSERVER***.

* ***{DATABASE_DATA_DIR}*** : Répertoire hôte qui contiendra les fichiers de base de données ***SQLSERVER***.

* ***{DATABASE_BACKUP_DIR}*** : Répertoire hôte utilisé lors des sauvegarde des bases de données ***SQLSERVER***.

* ***{DATABASE_RESTORE_DIR}*** : Répertoire hôte où déposer les fichier backup de base de données pour créer ou écraser une base de données ***SQLSERVER***. Exécution d'un CRON toutes les 30 secondes, prenant en compte les fichiers ***.bak*** pour les restaurer et les transformer en fichier ***.oldbak***.

* ***{DATABASE_PORT}*** : Port hôte permettant d'accéder à la base de données depuis l'hôte pour exécuter des scripts sql.

* ***{APPSRV_PORT}*** : Port hôte permettant d'accéder au service ***Tomcat*** en direct sans passer par le proxy apache

* ***{APPSRV_CONF_DIR}*** : Emplacement des fichiers de configuration ***Tomcat*** pris en compte par le conteneur tomcat au démarrage.

* ***{APPSRV_WEBAPPS_DIR}***: Emplacement où déposer les livrables (fichiers ***.war*** ) pour qu'ils soient pris en compte par ***Tomcat***.

* ***{APPSRV_LOGS_DIR}***: Emplacement des fichiers de log générés par ***Tomcat***.

* ***{PROXY_PORT}*** : Port de l'hôte qui permettra d'accéder au service web et donc aux applications déployées.

* ***{PROXY_CONF_DIR}*** : Répertoire de l'hôte contenant les fichiers de configuration du service ***Apache-httpd*** pris en compte au démarrage du service.

* ***{PROXY_WEB_DIR}*** : Répertoire de l'hôte contenant les fichiers statiques (pages WEB) du service ***Apache-httpd*** pris en compte au démarrage du service.

### L'exemple ci-dessous est valide sur une debian

Le code yaml ci-dessous vous donne un exemple de configuration qui devrait fonctionner.

<details>
  <summary>Click to expand!</summary>

```yaml
version: '3.7'
services:
    database:
        build: ./database
        image: mcr.microsoft.com/mssql/server:2017-latest
        environment:
            SA_PASSWORD: P@ssw0rd
            ACCEPT_EULA: Y
        volumes:
            - /var/opt/data/mssql/data/:/var/opt/mssql/data/
            - /var/opt/data/mssql/backup/:/var/opt/mssql/backup/
            - ./database/restore/:/var/opt/mssql/restore/
        ports:
            - "1433:1433"
        networks:
            arobas_network:

    appsrv:
        image: tomcat:6.0.48
        depends_on:
            - database
        # ports:
        #     - "8888:8080"
        volumes:
            - ./appsrv/conf/:/usr/local/tomcat/conf
            - ./appsrv/webapps/:/usr/local/tomcat/webapps
        networks:
            arobas_network:

    proxy:
        image: httpd:2.4.41-alpine
        depends_on:
            - appsrv
        ports:
            - "81:80"
        volumes:
            - ./proxy/conf/:/usr/local/apache2/conf/ #/tmp/pse/apache2/conf
            - ./proxy/www/:/usr/local/apache2/htdocs/ #/tmp/pse/apache2/htdocs
        networks:
            arobas_network:

networks:
    arobas_network:
```

 </details>

## Gestion des conteneurs

### Démarrer l'ensemble des conteneurs

La ligne de commande ci-dessous vous permet de télécharger et exécuter les différents conteneurs nécessaire à l'infra.

```bash
docker-compose up -d --build
```

Le résultat attendu est le suivant :

<details>
  <summary>Click to expand!</summary>

```bash
    Creating network "arobas_env_arobas_network" with the default driver
    Building database
    Step 1/5 : FROM mcr.microsoft.com/mssql/server:2017-latest
    ---> f78cdbed6225
    Step 2/5 : VOLUME /var/opt/mssql/restore
    ---> Running in 6cb93e46a35f
    Removing intermediate container 6cb93e46a35f
    ---> 7ba38a9c73db
    Step 3/5 : COPY ./scripts/bash/*.sh /opt/scripts/bash/
    ---> d20480a92940
    Step 4/5 : RUN chmod 0744 /opt/scripts/bash/*.sh
    ---> Running in d168fdfcc3c8
    Removing intermediate container d168fdfcc3c8
    ---> 5f7099e1d84a
    Step 5/5 : CMD /opt/scripts/bash/wrapper.sh
    ---> Running in d7c3ad467fb3
    Removing intermediate container d7c3ad467fb3
    ---> 49d14143f4b9

    Successfully built 49d14143f4b9
    Successfully tagged mcr.microsoft.com/mssql/server:2017-latest
    Creating arobas_env_database_1 ... done
    Creating arobas_env_appsrv_1   ... done
    Creating arobas_env_proxy_1    ... done
```

 </details>

### Arrêter les conteneurs en les supprimant

La ligne de commande ci-dessous vous permet d'arrêter tous les conteneurs et de supprimer les images associées. Les données et les fichiers de configuration ne sont pas perdus.

```bash
docker-compose down
```

Le résultat attendu est le suivant :

<details>
  <summary>Click to expand!</summary>

```bash
Stopping arobas_env_proxy_1    ... done
Stopping arobas_env_appsrv_1   ... done
Stopping arobas_env_database_1 ... done
Removing arobas_env_proxy_1    ... done
Removing arobas_env_appsrv_1   ... done
Removing arobas_env_database_1 ... done
Removing network arobas_env_arobas_network
```

</details>

## Gestion du serveur de base de données

### Créer la base de données

Il est possible de créer une base de données en déposant un simple fichier de backup sqlserver dans le répertoire **"{DATABASE_RESTORE_DIR}"**.

Toutes les 60 secondes, un script consomme les fichiers **.bak** présents dans le répertoire **"{DATABASE_RESTORE_DIR}"** afin de restaurer une base de données du même nom. À la suite de ce traitement, l'extension du fichier est changée en **.oldbak**

> Attention Dans le cas où une base de données avec le même nom que le fichier à restaurer existe déjà, la base sera alors écrasée par le fichier restauré.

### Accéder à la base de données

La base de données restaurée est alors accessible en local sur le port **"{DATABASE_PORT}"** à l'aide du compte **"SA"** et du mot de passe **"{DATABASE_SA_PASSWORD}"**.

La base de données sera également disponible par le conteneur **"appsrv"**. Le nom dns à utiliser est **"database"**, le port est **"1433"**, le compte est **"SA"** et le mot de passe est celui spécifié dans le fichier ***docker-compose.yaml*** (paramètre *"{DATABASE_SA_PASSWORD}"*)

## Gestion du serveur applicatif **"Tomcat"**

### Déployer une application WEB sur appsrv

Pour effectuer cette opération, deux solutions sont possibles

#### déployer par dépot de fichiers

Effectuer les opérations suivantes dans l'ordre :

* renommer l'extension du fichier *".war"* en *".newwar"*
* copie le fichier en extension *".newwar"* dans le répertoire  **"{APPSRV_WEBAPPS_DIR}"** soit **./appsrv/webapps/** dans l'exemple
* renommer l'extension du fichier *".newwar"* en *".war"*
* laisser tomcat intégrer le fichier et créer un répertoire avec le nom de l'application.

#### déployer à l'aide du manager tomcat

Le manager tomcat est accessible à travers le proxy apache. Il est possible de déployer ue application à travers le manager. Effectuer les opérations suivantes dans l'ordre :

* Accéder au manager par l'url [manager](http://localhost:81/admin/manager/html)
* Déployer le war à l'aide du formulaire.

### Accéder au serveur applicatif

## Le serveur proxy **"Apache-httpd**"

* Déployer la partie statique de votre application dans le répertoire **"{PROXY_WEB_DIR}"**
* Modifier le fichier [./proxy/conf/vhosts/allTomcat.conf](./proxy/conf/vhosts/allTomcat.conf) afin de tenir compte de la partie statique et de l'application web déployée au préalable.

## Quelques exmples de requêtes

### Suivre les logs du conteneur appsrv

* Lister les fichiers de logs disponibles

```bash
    docker-compose exec appsrv /bin/bash
    docker-compose exec appsrv ls -l /usr/local/tomcat/logs/
```

* regarder les logs défiler avec la commande tail

```bash
    docker-compose exec appsrv tail -f /usr/local/tomcat/logs/arobas-2.7.9.log
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
