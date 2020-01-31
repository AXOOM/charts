{{ define "etcd.selector-labels" -}}
app: '{{ required "Set name" .Values.name }}'
release: '{{ .Release.Name }}'
{{- end }}


{{ define "etcd.default-labels" -}}
{{ include "etcd.selector-labels" . }}
app.kubernetes.io/name: '{{ required "Set name" .Values.name }}'
app.kubernetes.io/instance: '{{ .Release.Name }}'
app.kubernetes.io/managed-by: '{{ .Release.Service }}'
helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'

{{- if .Values.labels }}
{{ .Values.labels | toYaml }}
{{- end }}

{{- end }}
