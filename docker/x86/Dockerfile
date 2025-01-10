FROM ubuntu:20.04

RUN apt-get update && apt-get install -y qemu-system-x86 ssh

COPY start.sh /start.sh
CMD ["bash", "/start.sh"]
