#!/usr/bin/env bash

# proxy settings
dropboxd proxy "manual" "socks5" '127.0.0.1' 1080

# Autostart at login
dropboxd autostart y
dropboxd start -i
