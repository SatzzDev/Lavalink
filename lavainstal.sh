#!/bin/bash
apt update -y
apt install -y curl wget unzip openjdk-17-jre screen

mkdir -p /opt/lavalink
cd /opt/lavalink

wget https://github.com/lavalink-devs/Lavalink/releases/latest/download/Lavalink.jar

mkdir plugins
cd plugins

wget https://github.com/lavalink-devs/lavalink-plugins/releases/latest/download/LavaSrcPlugin.jar
wget https://github.com/floweryvoice/flowery-tts-lavalink/releases/latest/download/FloweryTTSPlugin.jar
wget https://github.com/lavalink-devs/ytdlp-plugin/releases/latest/download/YtDlpPlugin.jar

cd /opt/lavalink

if [ ! -f application.yml ]; then
cat > application.yml <<EOF
server:
  port: 6666
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

cat > /etc/systemd/system/lavalink.service <<EOF
[Unit]
Description=Lavalink Server
After=network.target

[Service]
WorkingDirectory=/opt/lavalink
ExecStart=/usr/bin/java -jar Lavalink.jar
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable lavalink
systemctl start lavalink

echo "Lavalink installed and running on port 6666"
