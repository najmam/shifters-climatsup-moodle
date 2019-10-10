Ce dépôt contient des fichiers dont je me sers pour faire tourner une instance de Moodle localement.  
Je n'ai pas essayé de fournir une procédure clé en mains mais ce serait utile pour le projet, notamment lorsqu'on aura plus de mains qui toucheront à l'IHM.  
Ne pas trop avancer là-dessus dès maintenant (jeudi 10/10) parcequ'il vaut mieux que ces instances locales soient assez proches du déploiement sur le mutualisé, or on ne sait pas encore à quoi ressemble le mutualisé.

Ces instructions sont données pour Ubuntu 18.04.3.

## Installation

- [installer Docker Engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository) : j'ai utilisé la procédure décrite dans la section "Install using the repository"
- `systemctl start docker`
- clôner ce dépôt : `mkdir -p ~/work && git clone https://github.com/najmam/shifters-climatsup-moodle`
- installer Docker Compose : (je le fais dans un "virtualenv" Python)
  - installer `python3-virtualenv` si besoin
  - `cd ~/work/shifters-climatsup-moodle`
  - `virtualenv -p $(which python3) venv`
  - `source venv/bin/activate`
  - `pip install docker-compose`

## Réplication des données du projet

[La plateforme actuelle](https://moodle-dev.francecentral.cloudapp.azure.com/) est basée sur un déploiement Kubernetes+Docker hébergé sur Microsoft Azure.  
Christian a configuré des backups des volumes MariaDB et Moodle.  
Je n'ai pas utilisé ces backups car je n'y avais pas accès quand j'ai configuré mon environnement.  
Peut-être que [le dépôt de Christian](https://github.com/chateauvieux/shifters-moodle) contient assez d'infos pour aller récupérer les backups.  
Pour ma part, la présence des couches Azure+Kubernetes avec lesquelles je ne suis pas familier et le fait que je ne voyais pas les mots de passe Azure (j'ai p-ê mal cherché) m'a conduit à faire autrement :
je me suis dit qu'installer un Moodle vierge et le configurer m'apprendrait plus que d'insister à restaurer les backups existants. Je pense que c'était en effet une bonne décision.  
Si tu n'as jamais utilisé Moodle, je te conseille de faire pareil : installe un "vierge" et prends en main l'outil en le configurant "from scratch". Une fois qu'on aura le mutualisé, on configurera des exports MariaDB + zip des fichiers Moodle, et on pourra vraiment répliquer la plateforme en local. On peut raisonnablement estimer qu'on aura ça en place entre le 14 et le 20 octobre. 

Réfère-toi à la section "configuration" de [la page sur le wiki](http://benevoles-tsp.org/MediaWiki/index.php?title=Plateforme_p%C3%A9dagogique) si tu veux te rapprocher de l'existant.  
De mon côté j'ai installé un seul plugin, qui est [le thème Adaptable](https://moodle.org/plugins/theme_adaptable), histoire de vérifier qu'il offrait au moins la fonctionnalité "gérer la mise en page de la page d'accueil sans avoir à connaître HTML".

## Utilisation

Démarrer

```
cd ~/work/shifters-climatsup-moodle
source venv/bin/activate
docker-compose --project-name climatsup up --detach
```

Arrêter

```
cd ~/work/shifters-climatsup-moodle
source venv/bin/activate
docker-compose --project-name climatsup down
```

Consulter les logs : `docker-compose -p climatsup logs --follow`

### Pour aller plus vite

Extraits de mon `~/.bashrc` :

```
nj_climatsup_load() {
  cd ~/work/shifters-climatsup-moodle
  source venv/bin/activate
}
nj_climatsup_start() {
  systemctl start docker
  nj_climatsup_load
  docker-compose --project-name climatsup up --detach
}
nj_climatsup_stop() {
  nj_climatsup_load
  docker-compose --project-name climatsup down
}
```
