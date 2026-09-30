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

helm repo update >/dev/null

# syncSecret.enabled=true is required so the driver creates the Kubernetes Secret
# from the SecretProviderClass 'secretObjects' block (that is the object our
# deployments consume via secretKeyRef). enableSecretRotation keeps it fresh.
helm upgrade --install csi-secrets-store \
  secrets-store-csi-driver/secrets-store-csi-driver \
  --namespace kube-system \
  --set syncSecret.enabled=true \
  --set enableSecretRotation=true

# 2) AWS provider for the driver.
#
# NOTE: we intentionally install the AWS provider from its raw manifest rather
# than its Helm chart. The provider Helm chart bundles the Secrets Store CSI
# driver as a dependency and, by default, tries to own the shared
# "secrets-store-csi-driver" ServiceAccount. Since we install the driver as its
# own Helm release (csi-secrets-store) above, the chart install fails with a
# Helm ownership/import error on that ServiceAccount. The manifest install has
# no such conflict and matches how the provider is already deployed on-cluster.
# kubectl apply is idempotent, so this is safe to re-run every deploy.
kubectl apply -f \
  https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

# Wait for the driver + provider daemonsets to be ready before workloads try to
# mount CSI volumes, otherwise the first rollout can race the driver install.
kubectl -n kube-system rollout status daemonset/csi-secrets-store-secrets-store-csi-driver --timeout=180s
kubectl -n kube-system rollout status daemonset/csi-secrets-store-provider-aws --timeout=180s
