{{- if .Values.enabled }}{{- if .Values.dashboard.enabled }}
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-ingress
  namespace: {{ .Release.Namespace | quote }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "2"
    # Global annotations
    {{- if .Values.global.commonAnnotations }}
      {{- toYaml .Values.global.commonAnnotations | nindent 4 }}
    {{- end }}
  {{- if .Values.global.commonLabels }}
  labels:
    # Global labels
    {{- toYaml .Values.global.commonLabels | nindent 4 }}
  {{- end }}
spec:
  entryPoints:
    - {{ .Values.dashboard.entrypoint | quote }}
  routes:
    - match: Host(`{{ .Values.dashboard.ingressUrl }}`)
      kind: Rule
      {{- if .Values.dashboard.middlewares }}
      middlewares:
        {{- range .Values.dashboard.middlewares }}
        - name: {{ . | quote }}
        {{- end }}
      {{- end }}
      services:
        - name: longhorn-frontend
          port: 80
  tls:
    secretName: {{ .Values.dashboard.certName | quote }}
{{- end }}{{- end }}
