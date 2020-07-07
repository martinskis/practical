{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "practical.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "practical.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "practical.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "practical.labels" -}}
helm.sh/chart: {{ include "practical.chart" . }}
{{ include "practical.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "practical.selectorLabels" -}}
app.kubernetes.io/name: {{ include "practical.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "practical.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "practical.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Construct MONGODB_URL
*/}}
{{- define "practical.mongodb_url" -}}
{{- printf "mongodb://%s:%s@%s:27017/%s" .Values.mongodb.mongodbUsername .Values.mongodb.mongodbPassword (include "practical.mongodb_hostname" .) .Values.mongodb.mongodbDatabase }}
{{- end }}

{{/*
Construct mongodb cluster hostname
*/}}
{{- define "practical.mongodb_hostname" -}}
{{ .Release.Name }}-mongodb.{{ .Release.Namespace }}.svc.{{ .Values.mongodb.clusterDomain }}
{{- end }}

