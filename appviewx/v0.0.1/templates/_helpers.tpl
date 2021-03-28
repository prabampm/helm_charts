{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "appviewx.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "appviewx.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate appviewx workload certificate
*/}}
{{- define "appviewx.appviewx-workload-certificate" }}
{{- if (not (empty .Values.ingress.appviewxWorkload.certificate)) }}
{{- printf .Values.ingress.appviewxWorkload.certificate }}
{{- else }}
{{- printf "%s-appviewx-workload-letsencrypt" (include "appviewx.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate appviewx workload hostname
*/}}
{{- define "appviewx.appviewx-workload-hostname" }}
{{- if (and .Values.config.appviewxWorkload.hostname (not (empty .Values.config.appviewxWorkload.hostname))) }}
{{- printf .Values.config.appviewxWorkload.hostname }}
{{- else }}
{{- if .Values.ingress.appviewxWorkload.enabled }}
{{- printf .Values.ingress.appviewxWorkload.hostname }}
{{- else }}
{{- printf "%s-appviewx-workload" (include "appviewx.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate appviewx workload base url
*/}}
{{- define "appviewx.appviewx-workload-base-url" }}
{{- if (and .Values.config.appviewxWorkload.baseUrl (not (empty .Values.config.appviewxWorkload.baseUrl))) }}
{{- printf .Values.config.appviewxWorkload.baseUrl }}
{{- else }}
{{- if .Values.ingress.appviewxWorkload.enabled }}
{{- $hostname := ((empty (include "appviewx.appviewx-workload-hostname" .)) | ternary .Values.ingress.appviewxWorkload.hostname (include "appviewx.appviewx-workload-hostname" .)) }}
{{- $protocol := (.Values.ingress.appviewxWorkload.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "appviewx.appviewx-workload-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
