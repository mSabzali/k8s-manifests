#!/bin/bash

# Directory for backups
BACKUP_DIR="backup-manifest/$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

# List of resource types you want to back up
RESOURCES=("deployment" "service" "ingress" "configmap" "secret" "pvc")

echo "Backing up all manifests to $BACKUP_DIR ..."
echo

# Loop through all namespaces
for ns in $(kubectl get ns --no-headers -o custom-columns=:metadata.name); do
  echo "🔹 Namespace: $ns"
  mkdir -p "$BACKUP_DIR/$ns"
  
  # Loop through all resource types
  for r in "${RESOURCES[@]}"; do
    echo "  - Exporting $r ..."
    kubectl get "$r" -n "$ns" -o yaml > "$BACKUP_DIR/$ns/${r}s.yaml" 2>/dev/null
  done
  echo
done

echo "✅ Backup completed! Files saved in $BACKUP_DIR"

