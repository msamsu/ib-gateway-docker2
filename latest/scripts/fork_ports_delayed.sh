#!/bin/sh

printf "Forking :::4000 onto 0.0.0.0:4001\n"
socat TCP-LISTEN:5000,fork TCP:127.0.0.1:4000
