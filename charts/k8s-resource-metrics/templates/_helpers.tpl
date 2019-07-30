{{ define "k8s-resource-metrics.selector-labels" -}}
app: 'k8s-resource-metrics'
release: '{{ .Release.Name }}'
{{- end }}

{{ define "k8s-resource-metrics.default-labels" -}}
{{ include "k8s-resource-metrics.selector-labels" . }}
app.kubernetes.io/name: 'k8s-resource-metrics'
app.kubernetes.io/version: '{{ .Chart.Version }}'
app.kubernetes.io/instance: '{{ .Release.Name }}'
app.kubernetes.io/managed-by: '{{ .Release.Service }}'
helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'
{{- end }}
