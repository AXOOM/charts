{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "default-labels" -}}
    app: '{{ required "Set name" .Values.name }}'
    release: '{{ .Release.Name }}'
    chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'
    heritage: '{{ .Release.Service }}'
    tenantId: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
    tenantDomain: '{{ required "Set global.tenant.domain" .Values.global.tenant.domain }}'
{{- end -}}
