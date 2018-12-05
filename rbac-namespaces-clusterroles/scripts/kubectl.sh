#!/bin/bash

set -e

SERVICE_ACCOUNT_NAME="webapp-service-account"
NAMESPACE="webapp-namespace"
KUBECFG_FILE_NAME="admin.conf"

SECRET_NAME=$(kubectl get sa "${SERVICE_ACCOUNT_NAME}" --namespace="${NAMESPACE}" -o json | jq -r .secrets[].name)
kubectl get secret --namespace="${NAMESPACE}" "${SECRET_NAME}" -o json | jq -r '.data["ca.crt"]' | base64 --decode > ca.crt
USER_TOKEN=$(kubectl get secret --namespace webapp-namespace "${SECRET_NAME}" -o json | jq -r '.data["token"]' | base64 --decode)
context=$(kubectl config current-context)
CLUSTER_NAME=$(kubectl config get-contexts "$context" | awk '{print $3}' | tail -n 1)
ENDPOINT=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")
kubectl config set-cluster "${CLUSTER_NAME}" --kubeconfig="${KUBECFG_FILE_NAME}" --server="${ENDPOINT}" --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" --kubeconfig="${KUBECFG_FILE_NAME}" --token="${USER_TOKEN}"
kubectl config set-context "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" --kubeconfig="${KUBECFG_FILE_NAME}" --cluster="${CLUSTER_NAME}" --user="${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" --namespace="${NAMESPACE}"
kubectl config use-context "${SERVICE_ACCOUNT_NAME}-${NAMESPACE}-${CLUSTER_NAME}" --kubeconfig="${KUBECFG_FILE_NAME}"
