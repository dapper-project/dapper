#!/bin/bash
qemu-system-x86_64 \
  -hda /vm/x86.img \
  -m 2048 \
  -smp 2 \
  -netdev user,id=net0,hostfwd=tcp::22-:22 \
  -device e1000,netdev=net0 \
  -nographic \
  #-enable-kvm
