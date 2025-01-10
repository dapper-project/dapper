FROM ubuntu:20.04

RUN apt-get update && apt-get install -y qemu-system-arm qemu-efi ssh

COPY start.sh /start.sh
CMD ["bash", "/start.sh"]
