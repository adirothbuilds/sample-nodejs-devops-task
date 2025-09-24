{{ define "simple-nodejs.name" -}}
{{- $values := .Values | default (dict) -}}
{{- $chart := .Chart | default (dict "Name" "chart") -}}
{{- default $chart.Name $values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "simple-nodejs.fullname" -}}
{{- $values := .Values | default (dict) -}}
{{- $chart := .Chart | default (dict "Name" "chart") -}}
{{- $release := .Release | default (dict "Name" "release") -}}
{{- if $values.fullnameOverride | default "" -}}
{{- $values.fullnameOverride | default "" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default $chart.Name $values.nameOverride -}}
{{- printf "%s-%s" $release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{- define "simple-nodejs.labels" -}}
{{- $chart := .Chart | default (dict "AppVersion" "0.0.0" "Metadata" (dict)) -}}
{{- $release := .Release | default (dict "Name" "release" "Service" "Helm") -}}
{{- $image := .Values.image | default (dict) -}}
app.kubernetes.io/name: {{ include "simple-nodejs.name" . }}
app.kubernetes.io/instance: {{ $release.Name }}
app.kubernetes.io/version: {{ default $chart.AppVersion $image.tag }}
app.kubernetes.io/managed-by: {{ $release.Service }}
{{- if $chart.Metadata.Home }}
app.kubernetes.io/part-of: {{ $chart.Metadata.Home | replace "https://github.com/" "" | replace ".git" "" }}
{{- end }}
{{- $values := .Values | default (dict) -}}
{{- if $values.component }}
app.kubernetes.io/component: {{ $values.component }}
{{- end }}
{{- end -}}

{{- define "simple-nodejs.selectorLabels" -}}
{{- $release := .Release | default (dict "Name" "release") -}}
app.kubernetes.io/name: {{ include "simple-nodejs.name" . }}
app.kubernetes.io/instance: {{ $release.Name }}
{{- end -}}

{{- define "simple-nodejs.serviceAccountName" -}}
{{- $values := .Values | default (dict) -}}
{{- $serviceAccount := default (dict "create" false) $values.serviceAccount -}}
{{- if $serviceAccount.create -}}
{{- default (include "simple-nodejs.fullname" .) $serviceAccount.name -}}
{{- else -}}
{{- "default" -}}
{{- end -}}
{{- end -}}
