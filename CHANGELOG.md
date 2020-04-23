# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][Keep a Changelog] and this project adheres to [Semantic Versioning][Semantic Versioning].

## [Unreleased]

* [ ] database
  * [ ] créer un compte dbo pour chacune des bases de données restaurées après le restauration.
  * [ ] forcer un schrink database après la restauration afin de limiter la taille du fichier de log.
* [ ] appsrv
  * [ ] tester le déploiement d'un war et écrire la procédure associée:
    * [ ] copie du fichier en extension *".newwar"* dans le répertoire  webapps
    * [ ] renommer l'extension du fichier *".newwar"* en *".war"*
* [ ] proxy
  * [ ] tester la configuration par application
  * [ ] donner une configuration d'exemple par appli

---

## [Released]

---

<!-- Links -->
[Keep a Changelog]: https://keepachangelog.com/
[Semantic Versioning]: https://semver.org/

<!-- Versions -->
[Unreleased]: https://github.com/pontos3/ArobasLegacy/compare/v1.0.0...HEAD
[Released]: https://github.com/pontos3/ArobasLegacy/releases
[0.0.2]: https://github.com/pontos3/ArobasLegacy/compare/v0.0.1..v0.0.2
[0.0.1]: https://github.com/pontos3/ArobasLegacy/releases/v0.0.1