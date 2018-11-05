{{- define "axoom.default-labels" -}}
    app: '{{ required "Set name" .Values.name }}'
    release: '{{ .Release.Name }}'
    chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'
    heritage: '{{ .Release.Service }}'

    {{- if .Values.global.tenant.id }}
    tenantId: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
    {{- end }}

    {{- if .Values.global.tenant.domain }}
    tenantDomain: '{{ required "Set global.tenant.domain" .Values.global.tenant.domain }}'
    {{- end }}
{{- end -}}
