{{- if .Values.dashboard.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-ingress
  namespace: {{ .Values.namespace }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "2"
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`{{ .Values.dashboard.ingressUrl }}`)
      kind: Rule
      # middlewares:
      #   - name: lan-only-ref
      #     kind: TraefikService
      services:
        - name: longhorn-frontend
          port: 80
  tls:
    secretName: {{ .Values.dashboard.externalCert.name }}
{{- end }}
