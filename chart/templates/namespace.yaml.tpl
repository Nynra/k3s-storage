apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"