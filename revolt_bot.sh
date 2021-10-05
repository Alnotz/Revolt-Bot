#!/usr/bin/env bash
#NOTE : pour cURL et la partie Python
#```bash
#sudo apt install curl
#pip install py-ulid
#```
BOT_TOKEN='kzTf-pE6z5fPsOolRmsFTzB-WWxz9QDMIf9V8SYp-_UWnMxSyhqgG828mNx5na4S'
case $1 in
(-h | --help)
  echo -e """
$0 (-h|--help)
$0 (-s|--status) (on|off)
$0 MESSAGE [CHANNEL_ID]
""";;

(-s | --status)
  case $2 in
  (on)
    STATUS='Online'
    echo 'Présence du bot :'
    curl -H "x-bot-token: $BOT_TOKEN" \
      -X PATCH \
      --data """
{
  \"status\": {
    \"text\": \"discute\",
    \"presence\": \"$STATUS\"
  }
}
""" \
      -w "\n%{http_code}\n" \
      -- 'https://api.revolt.chat/users/@me';;
  (off)
    STATUS='Idle'
    echo 'Abscence du bot :'
    curl -H "x-bot-token: $BOT_TOKEN" \
      -X PATCH \
      --data """
{
  \"status\": {
    \"text\": \"dort\",
    \"presence\": \"$STATUS\"
  }
}
""" \
      -w "\n%{http_code}\n" \
      -- 'https://api.revolt.chat/users/@me';;
  (*);;
  esac;;
  
(*) 
  if [[ $2 = "" ]]
  then
    CHANNEL_ID='01FH6SSZ0AB0N9CSK2WSCTT9T5'
  else
    CHANNEL_ID=$2
  fi
  ULID=$( python -c 'from ulid import ULID; ulid = ULID(); print(ulid.generate())' )
  echo 'Message à mon salon :'
  curl -H "x-bot-token: $BOT_TOKEN" \
    --data """
{
  \"content\": \"$1\",
  \"nonce\": \"$ULID\"
}
    """ \
    -- "https://api.revolt.chat/channels/$CHANNEL_ID/messages/"
  echo ;;
esac
