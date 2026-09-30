#!/usr/bin/env bash
#
# Installs the Secrets Store CSI driver + the AWS provider into the cluster.
#
# This is what actually lets pods mount SecretProviderClass volumes and have the
# referenced Kubernetes secret (e.g. writer-service-db-secret) synced from AWS
# Secrets Manager. Without these two components, the CSI volume mounts added to
# the reader/writer deployments do nothing and the secretKeyRef lookups fail.
#
# Idempotent: safe to run on every deploy. `helm upgrade --install` creates the
# release on first run and no-ops (or updates) on subsequent runs.
#
# Prereqs: kubectl + helm configured against the target cluster.
set -euo pipefail

# 1) Secrets Store CSI driver (upstream).
helm repo add secrets-store-csi-driver \
  https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts >/dev/null 2>&1 || true

# 2) AWS provider for the driver.
helm repo add aws-secrets-manager \
  https://aws.github.io/secrets-store-csi-driver-provider-aws >/dev/null 2>&1 || true

helm repo update >/dev/null

# syncSecret.enabled=true is required so the driver creates the Kubernetes Secret
# from the SecretProviderClass 'secretObjects' block (that is the object our
# deployments consume via secretKeyRef). enableSecretRotation keeps it fresh.
helm upgrade --install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set syncSecret.enabled=true \
  --set enableSecretRotation=true

helm upgrade --install secrets-provider-aws \
  aws-secrets-manager/secrets-store-csi-driver-provider-aws \
  --namespace kube-system

# Wait for the driver + provider daemonsets to be ready before workloads try to
# mount CSI volumes, otherwise the first rollout can race the driver install.
kubectl -n kube-system rollout status daemonset/csi-secrets-store-secrets-store-csi-driver --timeout=180s
kubectl -n kube-system rollout status daemonset/secrets-provider-aws-secrets-store-csi-driver-provider-aws --timeout=180s
