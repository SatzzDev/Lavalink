#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan dengan sudo/root."
  exit 1
fi

REPO="https://github.com/SatzzDev/Lavalink"
DIR="/opt/lavalink"
JAR="Lavalink.jar"

install_node_full() {
  if command -v apt-get >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
  elif command -v yum >/dev/null 2>&1; then
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    yum install -y nodejs
  else
    echo "Install Node.js manual."
    exit 1
  fi
}

if ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y git
  elif command -v yum >/dev/null 2>&1; then
    yum install -y git
  else
    echo "Install git manual."
    exit 1
  fi
fi

if ! command -v java >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y openjdk-17-jre-headless
  elif command -v yum >/dev/null 2>&1; then
    yum install -y java-17-openjdk
  else
    echo "Install Java 17 manual."
    exit 1
  fi
fi

if ! command -v node >/dev/null 2>&1; then
  install_node_full
fi

if ! command -v npm >/dev/null 2>&1; then
  install_node_full
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm tetap tidak ditemukan, install Node.js gagal."
  exit 1
fi

if ! command -v pm2 >/dev/null 2>&1; then
  npm install -g pm2
fi

if [ -d "$DIR" ]; then
  cd "$DIR"
  if [ -d ".git" ]; then
    git pull --rebase
  else
    rm -rf "$DIR"
    git clone "$REPO" "$DIR"
  fi
else
  git clone "$REPO" "$DIR"
fi

cd "$DIR"

if [ ! -f "$JAR" ]; then
  echo "$JAR tidak ditemukan."
  exit 1
fi

pm2 delete lavalink >/dev/null 2>&1 || true
pm2 start "java -jar $DIR/$JAR" --name lavalink
pm2 save
pm2 startup | bash

IP=$(hostname -I | awk '{print $1}')
PORT=$(grep -E "port:" application.yml | head -n 1 | awk '{print $2}')

echo "========================================="
echo "Lavalink berjalan"
echo "IP: $IP"
echo "Port: ${PORT:-3100}"
echo "PM2 name: lavalink"
echo "Log: pm2 logs lavalink"
echo "========================================="
