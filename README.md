# Revolt-Bot

Projet de bot en *Bash* pour *Revolt*.
…Un peu de *Python* aussi.

Si `revolt_bot.sh` est exécutable l’aide est disponible comme suit :
```bash
revolt_bot.sh --help
```

## Dépendances

Ce petit bot en *Bash* dépend de deux outils :

### *cURL*

*cURL* permet de communiquer avec l’API de *Revolt* (un serveur *Revolt Delta*) via le HTTP.
Pour l’installer via `apt` :
```bash
sudo apt install curl
```

### *Py-ULID*

*Py-ULID* permet de générer des codes de type ULID sous forme de 26 caractères.
Pour l’installer via `pip` :
```bash
pip install py-ulid
```

## Usage

Pour envoyer un message `MESSAGE` via son bot le jeton d’identification `BOT_TOKEN` et l’identifiant du salon `CHANNEL_ID` sont nécessaires.
```bash
revolt_bot.sh -t $BOT_TOKEN -c $CHANNEL_ID -m $MESSAGE
```
