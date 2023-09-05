#!/bin/sh

sleep 20

printf "Forking :::4000 onto 0.0.0.0:5000\n"
socat TCP-LISTEN:5000,fork TCP:127.0.0.1:4000
