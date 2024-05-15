FROM debian:latest

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
