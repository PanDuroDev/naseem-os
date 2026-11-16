#!/usr/bin/env bash
set -euo pipefail

QCOW2=$(ls release/*.qcow2 | head -n1)
LOG=$(mktemp)
VARS=$(mktemp)

CODE=$(ls /usr/share/OVMF/OVMF_CODE_4M.fd /usr/share/OVMF/OVMF_CODE.fd /usr/share/edk2/x64/OVMF_CODE.4m.fd 2>/dev/null | head -n1)
VARS_T=$(ls /usr/share/OVMF/OVMF_VARS_4M.fd /usr/share/OVMF/OVMF_VARS.fd /usr/share/edk2/x64/OVMF_VARS.4m.fd 2>/dev/null | head -n1)
echo "firmware: $CODE"
cp "$VARS_T" "$VARS"

qemu-system-x86_64 \
  -machine q35,accel=tcg -cpu max -smp 2 -m 2048 \
  -drive if=pflash,format=raw,readonly=on,file="$CODE" \
  -drive if=pflash,format=raw,file="$VARS" \
  -drive file="$QCOW2",format=qcow2,if=virtio,snapshot=on \
  -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
  -display none -serial "file:$LOG" -no-reboot &

PID=$!

for i in $(seq 1 84); do
  if grep -q NASEEM_BOOT_OK "$LOG" 2>/dev/null; then
    echo "boot OK after $((i * 5))s"
    kill $PID 2>/dev/null || true
    wait $PID 2>/dev/null || true
    tail -n 20 "$LOG"
    exit 0
  fi
  if ! kill -0 $PID 2>/dev/null; then
    echo "::error::qemu exited early"
    tail -n 100 "$LOG"
    exit 1
  fi
  sleep 5
done

echo "::error::guest did not reach boot marker within 420s"
tail -n 200 "$LOG"
kill $PID 2>/dev/null || true
exit 1