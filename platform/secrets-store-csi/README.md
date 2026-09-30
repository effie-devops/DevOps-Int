# Secrets Store CSI driver

The reader/writer services get their database credentials from AWS Secrets
Manager (`django-api/uat/db-credentials`) at runtime. The flow is:

1. Terraform creates the secret and an IRSA role
   (`django-api-uat-secrets-access-role`) allowing
   `secretsmanager:GetSecretValue` / `DescribeSecret`. The `*-service-sa`
   service accounts in the `backend` namespace are annotated with that role.
2. Each service defines a `SecretProviderClass` (`secret-provider.yaml`) that
   maps the Secrets Manager JSON into a Kubernetes `Secret`
   (`<service>-db-secret`) via its `secretObjects` block.
3. The deployment **mounts** that `SecretProviderClass` as a CSI volume. The
   mount is what triggers the driver to fetch from Secrets Manager and create
   the Kubernetes secret. The container then reads the values via `secretKeyRef`.

Step 3 only works if the **Secrets Store CSI driver** and the **AWS provider**
are installed in the cluster. This directory installs both.

## Install

```bash
./install.sh
```

Requires `helm` and `kubectl` pointed at the target cluster. The script is
idempotent (`helm upgrade --install`) and is run by the deploy workflow before
the app rollout.

## Verify

```bash
kubectl get csidrivers.storage.k8s.io secrets-store.csi.k8s.io
kubectl -n kube-system get pods | grep -i secrets-store

# After a deploy, the synced secret should exist and the pods should be Ready:
kubectl -n backend get secret writer-service-db-secret
kubectl -n backend get pods -l app=writer-service
```
