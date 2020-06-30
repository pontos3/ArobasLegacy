# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][Keep a Changelog] and this project adheres to [Semantic Versioning][Semantic Versioning].

## [Unreleased]

* [ ] database
  * [ ] créer un compte dbo pour chacune des bases de données restaurées après le restauration.
  * [ ] forcer un schrink database après la restauration afin de limiter la taille du fichier de log.

---

## [Released]

## [draft-1.1.0] - 2020-06-26

### Added

Création d'un arborescence pour l'ajout d'une UI de gestion des utilisateurs des droits utilisés pour l'authentification:

Ajout des éléments nécessaires pour l'authentification des utilisateurs:

* Création d'une arborescence pour le déploiement de shibboleth
* Ajout d'un serveur apache tomcat 9 pour l'authentification shibboleth
* Ajout d'un sptest spéraré du proxy.
* Ajout d'un fichier .env pour le paramétrage
* Prise en compte des pré-livrables A3 avec le remplacement des variables d'environnement

### Removed

* Suppression de la partie sp_test sur la configuration du proxy
* Suppression des fichiers de configuration apache inutilisés.

## [1.0.0] - 2020-04-23

### Added

Première version foncionnelle comprenant les éléments suivants:

* Un moteur de base de données sql server 2017 developer edition.
* Un serveur proxy apache 2.4
* Un serveur tomcat 6

---

<!-- Links -->
[Keep a Changelog]: https://keepachangelog.com/
[Semantic Versioning]: https://semver.org/

<!-- Versions -->
[Unreleased]: https://github.com/pontos3/ArobasLegacy/compare/v1.0.0...HEAD
[Released]: https://github.com/pontos3/ArobasLegacy/releases
[1.1.0]: https://github.com/pontos3/ArobasLegacy/compare/v1.0.0..v1.1.0
[1.0.0]: https://github.com/pontos3/ArobasLegacy/releases/v1.0.
