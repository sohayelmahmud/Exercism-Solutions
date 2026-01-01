#!/usr/bin/env bash
echo "$@" | perl -pe 's/((s?qu|[xy](?=[aeiouy])|[bcdfghjklmnpqrstvwz]+))?(\S+)/\3\1ay/g'
