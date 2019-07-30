#!/bin/bash

# Loop by line
IFS=$'\n'

old_proces=$(ps -eo command)

while true
do
  new_process=$(ps -eo command)
  diff <(echo "$old_process") < (echo "$new_process") | grep [\<\>]
  sleep 1
  old_process=$new_process
done