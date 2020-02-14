{{ define "generic-service.selector-labels" -}}
app: '{{ required "Set name" .Values.name }}'
release: '{{ .Release.Name }}'
{{- end }}


{{ define "generic-service.default-labels" -}}
{{ include "generic-service.selector-labels" . }}
app.kubernetes.io/name: '{{ required "Set name" .Values.name }}'
app.kubernetes.io/version: '{{ required "Set image.tag" .Values.image.tag }}'
app.kubernetes.io/instance: '{{ .Release.Name }}'
app.kubernetes.io/managed-by: '{{ .Release.Service }}'
helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'

{{- if .Values.global.tenant.id }}
tenantId: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
axoom.com/customer: '{{ required "Set global.tenant.id" .Values.global.tenant.id }}'
{{- end }}

{{- if .Values.labels }}
{{ .Values.labels | toYaml }}
{{- end }}

{{- end }}


{{ define "requests-total" }}{{ if .Values.ingress.istio.enabled }}istio_requests_total{{ else }}traefik_backend_requests_total{{ end }}{{ end }}

{{ define "request-duration" }}{{ if .Values.ingress.istio.enabled }}istio_request_duration_seconds_sum{{ else }}traefik_backend_request_duration_seconds_sum{{ end }}{{ end }}

{{ define "response-code" }}{{ if .Values.ingress.istio.enabled }}response_code{{ else }}code{{ end }}{{ end }}

{{ define "requests-filter" }}{{ if .Values.ingress.istio.enabled }}destination_service_namespace="{{ .Release.Namespace }}", destination_service_name="{{ .Values.name }}"{{ else }}backend="{{ .Values.ingress.domain }}"{{ end }}{{ end }}
