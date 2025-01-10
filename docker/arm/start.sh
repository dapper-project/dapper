#!/bin/bash
qemu-system-aarch64 \
  -hda /vm/arm.img \
  -m 2048 \
  -smp 2 \
  -cpu cortex-a57 \
  -M virt \
  -netdev user,id=net0,hostfwd=tcp::22-:22 \
  -device virtio-net-pci,netdev=net0 \
  -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd \
  -nographic
