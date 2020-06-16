#!/bin/bash
# #############################################################################
#	Activation des metadata de SP presents dans /metadata de l'IdP MAE
# ############################# Historique ####################################
# 180123, jlb : Creation
# 200306, pse : Changement pour le fonctionnement avec Docker
# #############################################################################
set -e

cd `dirname $BASH_SOURCE`/../metadata_sp

echo `dirname $BASH_SOURCE`/../metadata_sp

#Generation des liens sha1 vers les fichiers metadata
for f in $(find . -type f -name "*.xml"); do
	if [ ! "$f" == "./idp-metadata.xml" ]; then 
                entityID=$(grep -i entityID= $f | sed 's/^.*[eE][nN][tT][iI][tT][yY][iI][dD]="//' | awk -F "\"" '{print $1}')
                entityIDsha1=$(echo -n $entityID | openssl sha1 | awk '{print $2}')
                if [ ! -f ../metadata/$entityIDsha1.xml ]; then
                        echo "Activation de $entityID, sha1 : $entityIDsha1"

                        #Suppression des anciens liens (si l'entityid a change pour un meme fichier)
                        for l in $(find -L ../metadata/ -xtype l -samefile $f); do
                                echo "Suppression de l'ancien lien $l"
                                rm -f $l
                        done

                        #Creation du nouveau lien
                        ln -sf ../metadata_sp/$f ../metadata/$entityIDsha1.xml
                else
                        echo "	$entityID, sha1 : $entityIDsha1"        
                fi
        fi
done


#Suppression des liens morts
for f in $(find -H ../metadata/ -xtype l -name "*.xml"); do
	echo "Suppression du lien $f"
	rm -f $f
done

echo $(date) > last-activate.log
