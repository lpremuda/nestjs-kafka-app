#!/usr/bin/env bash

curl --request POST \
  --url http://localhost:3000/user \
  --header 'Content-Type: application/json' \
  --data '{ 
	"name": "Lucas Premuda",
	"email": "lucas@yahoo.com" 
}' \
| jq

curl --request POST \
  --url http://localhost:3000/post \
  --header 'Content-Type: application/json' \
  --data '{ 
	"title": "The Title",
	"content": "The Content",
  "authorEmail": "lucas@yahoo.com" 
}' \
| jq

curl --request GET \
  --url http://localhost:3000/post/1 \
  | jq

curl --request PUT \
  --url http://localhost:3000/publish/1 \
  | jq

curl --request GET \
  --url http://localhost:3000/feed \
  | jq