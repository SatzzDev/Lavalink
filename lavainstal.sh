#!/bin/bash
apt update -y
apt install -y curl wget unzip openjdk-17-jre screen

npm install -g pm2

mkdir -p lavalink
cd lavalink

wget https://github.com/lavalink-devs/Lavalink/releases/latest/download/Lavalink.jar

mkdir plugins
cd plugins

wget https://github.com/lavalink-devs/lavalink-plugins/releases/latest/download/LavaSrcPlugin.jar
wget https://github.com/DuncteBot/skybot-lavalink-plugin/releases/download/PRE_1.7.0_45/skybot-lavalink-plugin-1.7.0.jar
wget https://github.com/esmBot/lava-xm-plugin/releases/download/v0.2.8/lava-xm-plugin-0.2.8.jar

cd /opt/lavalink

if [ ! -f application.yml ]; then
cat > application.yml <<EOF
server:
  port: 80
  address: 0.0.0.0

lavalink:
  server:
    password: SatzzDev
    youtubeSearchEnabled: true
    soundcloudSearchEnabled: true
    opusEncodingQuality: 10
    resamplingQuality: HIGH
    bufferDurationMs: 400
    frameBufferDurationMs: 5000

plugins:
  directory: ./plugins
EOF
fi

pm2 delete lavalink
pm2 start "java -jar Lavalink.jar" --name lavalink --cwd lavalink
pm2 save
pm2 logs

echo "Lavalink installed and running under PM2 on port 80"
