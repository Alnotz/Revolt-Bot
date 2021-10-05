#!/usr/bin/env bash
#COMMANDE:
#```bash
#bash revolt_bot.sh \
#  -t 'JETON' \
#  -s 'STATUT'
#```
#COMMANDE:
#```bash
#bash revolt_bot.sh \
#  -t 'JETON' \
#  -c 'SALON' \
#  -m 'TEXTE'
#```
#NOTE : pour cURL et la partie Python
#```bash
#sudo apt install curl
#pip install py-ulid
#```
declare BOT_TOKEN
declare STATUS
declare CHANNEL_ID
declare MESSAGE
T_FLAG=0
S_FLAG=0
C_FLAG=0
M_FLAG=0
function presence()
{
  #$1: 'Online'|'Idle'
  echo 'Présence du bot :'
  curl -H "x-bot-token: $BOT_TOKEN" \
    -X 'PATCH' \
    --data """
{
  \"status\": {
    \"text\": \"$1\",
    \"presence\": \"$1\"
  }
}
""" \
    -w "\n%{http_code}\n" \
    -- 'https://api.revolt.chat/users/@me'
  echo
}
function message()
{
  #$1: $CHANNEL_ID
  #$2: $MESSAGE
  ULID=$( python ./revolt_bot.py )
  echo 'Message à mon salon :'
  curl -H "x-bot-token: $BOT_TOKEN" \
    --data """
{
  \"content\": \"$2\",
  \"nonce\": \"$ULID\"
}
""" \
    -- "https://api.revolt.chat/channels/$1/messages/"
  echo
}
#Premier examen si aide.
if [[ $1 == '-h' ]] || [[ $1 == '--help' ]]
then
  echo -e """
$0 (-h|--help)
$0 (-t|--token) BOT_TOKEN (-s|--status) (on|off)
$0 (-t|--token) BOT_TOKEN (-c|--channel) CHANNEL_ID (-m|--message|--) MESSAGE
"""
  exit 0
fi
#Examens suivants si pas d’aide.
#Balayage des arguments par paires.
for NB in {0..10}
do
  case $1 in
  ('-t'|'--token')
    if [[ $2 != "" ]]
    then
      BOT_TOKEN=$2
      T_FLAG=1
    fi
    shift 2;;

  ('-s'|'--status')
    case $2 in
    ('on')
      STATUS='Online'
      S_FLAG=1;;
    ('off')
      STATUS='Idle'
      S_FLAG=1;;
    (*);;
    esac
    shift 2;;
    
  ('-c'|'--channel')
    if [[ $2 != "" ]]
    then
      CHANNEL_ID=$2
      C_FLAG=1
    fi
    shift 2;;

  ('-m'|'--message'|'--')
    if [[ $2 == - ]]
    then
      MESSAGE=/dev/stdin
    elif [[ $2 == "" ]]
    then
      MESSAGE=""
    else
      MESSAGE=$2
    fi
    M_FLAG=1
    shift 2;;

  (*)
    if [[ $T_FLAG == 1 ]] && [[ $S_FLAG == 1 ]]
    then
      presence $STATUS
      exit 0
    elif [[ $T_FLAG == 1 ]] && [[ $C_FLAG == 1 ]] && [[ $M_FLAG == 1 ]]
    then
      message $CHANNEL_ID $MESSAGE
      exit 0
    else
      echo 'Erreur: mauvais arguments.'
      echo 'Taper '$0' --help.'
      exit 1
    fi;;
  esac
done
