# pre_build

1. Déposer dans ce répertoire, les prélivrables des Applications_A3 adaptés (Applications ou API). Attention créer un répertoire différent par application ou api

    Voici la liste attendue pour une application utilisant SAML. L'exemple est donné pour l'application Arobas :  

   * dynamique.xml
   * dynamique.properties
   * livrable-arobas-dynamique-2.7.9-20191018.war
   * arobas_metadata.xml
   * arobassamlKeystore.jks

    La partie statique n'est pas déposée dans ce répertoire.

2. Ajouter une extension subst aux fichiers dont vous souhaitez qu'une substitution de variables d'environnement soit effectuée.

    Voicie la liste précédente avec les fichiers renommés :

   * dynamique.xml
   * dynamique.properties.subst
   * livrable-arobas-dynamique-2.7.9-20191018.war
   * arobas_metadata.xml.subst
   * arobassamlKeystore.jks

3. Positionner les variables d'environnement souhaitées dans les fichiers .subst.

    exemple pour le fichier **dynamique.properties.subst** :

    ``` properties
    #===============================================================================
    # Configuration Appel aux écrans partagés arobas
    #===============================================================================
    # Le port utilisé.
    build.arobasIhm.protocol=${PROXY_APP_SCHEME}

    # Le domaine
    build.arobasIhm.server=${PROXY_APP_HOST}

    # Le port utilisé.
    build.arobasIhm.port=${PROXY_APP_PORT}
    ...
    ```

    exemple pour un fichier metadata.xml

    ``` xml
    <?xml version="1.0" encoding="UTF-8"?>
    <md:EntityDescriptor ID="${PROXY_APP_SCHEME}___${PROXY_APP_HOST}_arobas" entityID="${PROXY_APP_SCHEME}://${PROXY_CALC_HOST_PORT}/arobas" 
        xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata">
        <md:SPSSODescriptor AuthnRequestsSigned="true" WantAssertionsSigned="true" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
            <md:KeyDescriptor use="signing">
                <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
                    <ds:X509Data>...
    ```

    La liste des variables d'environnement disponibles est la suivante :

    * PROXY_APP_SCHEME : valoriser à https
    * PROXY_APP_HOST : nom d'hôte du serveur valorisé à $EXPOSE_PROXY_APP_HOST
    * PROXY_APP_PORT : numéro de port valorisé à $EXPOSE_PROXY_HTTPS_PORT
    * PROXY_CALC_HOST_PORT : variable calculée contenant le host et le port.
