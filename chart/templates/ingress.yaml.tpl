{{- if .Values.enabled }}{{- if .Values.dashboard.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-ingress
  namespace: {{ .Values.namespace.name | quote }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "2"
    # Global annotations
    {{- if .Values.global.commonAnnotations }}
      {{- toYaml .Values.global.commonAnnotations | nindent 4 }}
    {{- end }}
    # Custom annotations
    {{- if .Values.dashboard.commonAnnotations }}
    {{- toYaml .Values.dashboard.commonAnnotations | nindent 4 }}
    {{- end }}
  labels:
    # Global labels
    {{- if .Values.global.commonLabels }}
      {{- toYaml .Values.global.commonLabels | nindent 4 }}
    {{- end }}
    # Custom labels
    {{- if .Values.dashboard.commonLabels }}
    {{- toYaml .Values.dashboard.commonLabels | nindent 4 }}
    {{- end }}
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
    secretName: {{ .Values.dashboard.certName | quote }}
{{- end }}{{- end }}
