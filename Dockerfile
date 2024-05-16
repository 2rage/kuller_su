FROM debian:latest

LABEL org.opencontainers.image.title="samp_zombie_server"
LABEL org.opencontainers.image.description="Zombie SAMP server KulleR.su old project."
LABEL org.opencontainers.image.version="v0.23-2f"
LABEL org.opencontainers.image.created="2024-05-16T00:00:00Z"
LABEL org.opencontainers.image.authors="2rage"
LABEL org.opencontainers.image.source="https://github.com/2rage/kuller_su"
LABEL org.opencontainers.image.documentation="https://github.com/2rage/kuller_su"

RUN dpkg --add-architecture i386 \
    && apt-get update

RUN apt-get install -y \
    libfontconfig1:i386 \
    libx11-6:i386 \
    libxrender1:i386 \
    libxt6:i386 \
    libxext6:i386 \
    libgl1-mesa-glx:i386 \
    libgl1:i386 \
    libsm6:i386

COPY . /samp_zombie_server

WORKDIR /samp_zombie_server
RUN chmod +x ./samp03svr

EXPOSE 7777/udp

CMD ["./samp03svr"]
