# SAMP server installation

## Contents

- [With docker (recommended)](#Docker)
- [Linux](#Linux)
- [Windows installation](#Windows)

## Docker

### Prerequisites 

- Docker installed on your machine
- User added to the Docker group: ```sudo usermod -aG docker {USER_NAME}```

### Installation

```bash
docker pull ghcr.io/2rage/kuller_su/samp_zombie_server:latest
```

## Linux

### Prerequisites 

- On Debian we will enable the 32-bit architecture: ```sudo dpkg --add-architecture i386```
- Update repo and install packages for 32-bit architecture: 

```bash
sudo apt install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386
```

### Installation

```bash
git clone https://github.com/2rage/KulleR.su.git
cd kuller_su/samp_mod
git checkout linux
chmod +x samp03svr
./samp3svr &
 ```

Use shorcut **Ctrl + C** to stop SAMP server


### Systemd service for starting and stopping the samp server

1. Make sure to replace ```your_user``` with the username that should run the server, ```your_group``` with the appropriate group, and ```/home/the2rage/kuller_su/samp_mod/``` with the actual path to your SA-MP server directory.

```bash
cat << EOF |sudo tee -a /lib/systemd/system/samp-server.service
[Unit]
Description=SA-MP Server
After=network.target

[Service]
User=your_user
Group=your_group
WorkingDirectory=/home/the2rage/kuller_su/samp_mod/
ExecStart=/home/the2rage/kuller_su/samp_mod/samp03svr
ExecStop=/bin/kill -s SIGTERM $MAINPID

[Install]
WantedBy=multi-user.target
EOF
```
2. Reload the systemd manager configuration to apply the new service file:

```bash
sudo systemctl daemon-reload
```
3. Enable the service to start on boot:

```bash
sudo systemctl enable samp-server
```
4. Start the service:

```bash
sudo systemctl start samp-server
```
- To stop the service, you can use:

```bash
sudo systemctl stop samp-server
```
- To check the status of the service:

```bash
sudo systemctl status samp-server
```

## Windows

```powershell
git clone https://github.com/2rage/KulleR.su.git
cd kuller_su/samp_mod
.\samp-server.exe
 ```