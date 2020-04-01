## objectif :

Fournir une infrastructure rassemblant
* Un serveur de base de données SQLSERVER 2017
* un serveur Applicatif Tomcat 6 java 8
* un serveur proxy apache pour les pages statiques

## Démarrer le projet

1. installer docker comme indiqué par le site à l'adresse suivante : https://docs.docker.com/install/linux/docker-ce/debian/

1. Tester l'installation en chargeant une première image et un premier conteneur. La ligne de commande ci-dessous permet l'opération:

 ```bash
docker run hello-world
 ```

## L'arborescence du projet

```
.
├── appsrv
│   ├── conf            ## Répertoire de configuration de tomcat
│   └── webapps         ## Répertoire où déployer les fichiers war des applications
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

## Adapter la configuration à son poste :

Tous les paramètres de ce fichier peuvent-être modifiés. Seuls les plus importants sont indiqués ci-dessous.


```yaml
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

Voici une description des différents paramètre :

- [ ] ***DATABASE_SA_PASSWORD*** : Mot de passe du compte SA de la base de données.

- [ ] ***DATABASE_DATA_DIR*** : Répertoire hôte qui contiendra les fichiers de base de données.

- [ ] ***DATABASE_BACKUP_DIR*** : Répertoire hôte utilisé lors des sauvegarde des bases de données.

- [ ] ***DATABASE_RESTORE_DIR*** : Répertoire hôte où déposer les fichier backup de base de données pour créer ou écraser une base de données. Exécution d'un CRON toutes les 30 secondes, prenant en compte les fichiers ***.bak*** pour les restaurer et les transformer en fichier ***.oldbak***.

- [ ] ***DATABASE_PORT*** : Port hôte permettant d'accéder à la base de données depuis l'hôte pour exécuter des scripts sql.

- [ ] ***APPSRV_PORT*** : Port hôte permettant d'accéder au service ***Tomcat*** en direct sans passer par le proxy apache

- [ ] ***APPSRV_CONF_DIR*** : Emplacement des fichiers de configuration ***Tomcat*** pris en compte par le conteneur tomcat au démarrage.

- [ ] ***APPSRV_WEBAPPS_DIR***: Emplacement où déposer les livrables (fichiers ***.war*** ) pour qu'ils soient pris en compte par ***Tomcat***.

- [ ] ***PROXY_PORT*** : Port de l'hôte qui permettra d'accéder au service web et donc aux applications déployées.

- [ ] ***PROXY_CONF_DIR*** : Répertoire de l'hôte contenant les fichiers de configuration du service ***Apache-httpd*** pris en compte au démarrage du service.

- [ ] ***PROXY_WEB_DIR*** : Répertoire de l'hôte contenant les fichiers statiques (pages WEB) du service ***Apache-httpd*** pris en compte au démarrage du service.

L'exemple ci-dessous s'exécute sur debian :

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

1.  Editer le fichier [./docker-compose.yaml](./docker-compose.yaml). 
1.  modifier la partie volumes du service *database*. Indiquer l'emplacement des répertoires où seront stockés les fichiers de base de données et les fichiers de backup sur le système hôte. Lors de la restauration d'une base, les fichiers mdf et ldf seront créés à cet emplacement.

        ```yaml
            database:
                ...
                volumes:
                    - {à modifier}:/var/opt/mssql/data/
                    - {à modifier}:/var/opt/mssql/backup/
                    - ./database/restore/:/var/opt/mssql/restore/
                ...
        ```

1.  modifier la partie ports du services database afin 

> un texte comme un autre


## Le serveur de base de données



## Le serveur Applicatif


un lien vers un exemple d'import de données :https://docs.microsoft.com/fr-fr/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15

un lien vers la doc de sql server sur Linux : https://docs.microsoft.com/fr-fr/sql/linux/sql-server-linux-migrate-restore-database?view=sql-server-ver15#move-the-backup-file-before-restoring

https://docs.microsoft.com/fr-fr/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15