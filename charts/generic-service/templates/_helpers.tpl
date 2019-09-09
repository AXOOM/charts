{{ define "axoom.selector-labels" -}}
app: '{{ required "Set name" .Values.name }}'
release: '{{ .Release.Name }}'
{{- end }}


{{ define "axoom.default-labels" -}}
{{ include "axoom.selector-labels" . }}
app.kubernetes.io/name: '{{ required "Set name" .Values.name }}'
app.kubernetes.io/version: '{{ .Chart.Version }}'
app.kubernetes.io/instance: '{{ .Release.Name }}'
app.kubernetes.io/managed-by: '{{ .Release.Service }}'
helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'

{{- if .Values.global.tenant.id }}
tenantId: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
axoom.com/customer: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
{{- end }}

{{- end }}
