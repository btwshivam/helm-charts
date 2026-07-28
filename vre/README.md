# escape-vre

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

The Virtual Research Environment developed at CERN.

**Homepage:** <https://vre-hub.github.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| VRE Team | <vre-team@example.com> | <https://vre-hub.github.io> |

## Source Code

* <https://github.com/vre-hub/vre>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://fluent.github.io/helm-charts | fluent-bit | 0.48.9 |
| https://hub.jupyter.org/helm-chart | jupyterhub | 3.3.7 |
| https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner | nfs-server-provisioner | 1.8.0 |
| https://reanahub.github.io/reana | reana | 0.9.4 |
| oci://ghcr.io/grafana-community/helm-charts | grafana | 9.2.2 |
| oci://ghcr.io/grafana-community/helm-charts | loki | 6.30.1 |
| oci://ghcr.io/paullaycock/charts | npdb | 0.4.3 |
| oci://ghcr.io/prometheus-community/charts | prometheus | 27.20.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| RcloneMount.capacity | string | `"10Gi"` |  |
| RcloneMount.enabled | bool | `false` |  |
| RcloneMount.pvName | string | `"data-rclone-pv"` |  |
| RcloneMount.pvcName | string | `"data-rclone-pvc"` |  |
| RcloneMount.readOnly | bool | `true` |  |
| RcloneMount.reclaimPolicy | string | `"Retain"` |  |
| RcloneMount.remoteName | string | `"rclone"` |  |
| RcloneMount.remotePath | string | `"/"` |  |
| RcloneMount.remoteUrl | string | `""` |  |
| RcloneMount.storageClassName | string | `"rclone"` |  |
| RcloneMount.vendor | string | `"other"` |  |
| RcloneMount.volumeHandle | string | `"rclone-data-id"` |  |
| bootstrap.enabled | bool | `true` |  |
| bootstrap.image.pullPolicy | string | `"IfNotPresent"` |  |
| bootstrap.image.repository | string | `"alpine/k8s"` |  |
| bootstrap.image.tag | string | `"1.30.14"` |  |
| bootstrap.initImage.pullPolicy | string | `"IfNotPresent"` |  |
| bootstrap.initImage.repository | string | `"postgres"` |  |
| bootstrap.initImage.tag | string | `"17.5"` |  |
| bootstrap.reanaAdminEmail | string | `nil` |  |
| bootstrap.reanaAdminPassword | string | `nil` |  |
| condaSetup.configMapName | string | `"conda-setup"` |  |
| condaSetup.enabled | bool | `false` |  |
| crm.enabled | bool | `false` |  |
| crm.namespace | string | `"monitoring"` |  |
| fluent-bit.config.inputs | string | `"[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    multiline.parser docker, cri\n    Tag kube.*\n    Mem_Buf_Limit 5MB\n    Buffer_Chunk_Size 1\n    Refresh_Interval 1\n    Skip_Long_Lines On\n"` |  |
| fluent-bit.config.outputs | string | `"[FILTER]\n    Name grep\n    Match *\n\n[OUTPUT]\n    Name        loki\n    Match       *\n    Host        {{ .Release.Name }}-loki-gateway\n    port        80\n    tls         off\n    tls.verify  off\n"` |  |
| fluent-bit.config.rbac.create | bool | `true` |  |
| fluent-bit.config.rbac.eventsAccess | bool | `true` |  |
| fluent-bit.enabled | bool | `false` |  |
| grafana.enabled | bool | `false` |  |
| grafana.persistentVolume.size | string | `"1Gi"` |  |
| grafana.prometheus-node-exporter.enabled | bool | `false` |  |
| grafana.retention | string | `"15d"` |  |
| grafana.testFramework.enabled | bool | `false` |  |
| jupyterhub.enabled | bool | `true` |  |
| jupyterhub.hub.config.JupyterHub.authenticator_class | string | `"generic-oauth"` |  |
| jupyterhub.hub.config.RucioAuthenticator.allow_all | bool | `true` |  |
| jupyterhub.hub.config.RucioAuthenticator.authorize_url | string | `"https://iam-escape.cloud.cnaf.infn.it/authorize"` |  |
| jupyterhub.hub.config.RucioAuthenticator.client_id | string | `nil` |  |
| jupyterhub.hub.config.RucioAuthenticator.client_secret | string | `nil` |  |
| jupyterhub.hub.config.RucioAuthenticator.enable_auth_state | bool | `true` |  |
| jupyterhub.hub.config.RucioAuthenticator.oauth_callback_url | string | `"https://jhub-vre.obsuks4.unige.ch/hub/oauth_callback"` |  |
| jupyterhub.hub.config.RucioAuthenticator.scope[0] | string | `"openid"` |  |
| jupyterhub.hub.config.RucioAuthenticator.scope[1] | string | `"profile"` |  |
| jupyterhub.hub.config.RucioAuthenticator.scope[2] | string | `"email"` |  |
| jupyterhub.hub.config.RucioAuthenticator.token_url | string | `"https://iam-escape.cloud.cnaf.infn.it/token"` |  |
| jupyterhub.hub.config.RucioAuthenticator.userdata_url | string | `"https://iam-escape.cloud.cnaf.infn.it/userinfo"` |  |
| jupyterhub.hub.config.RucioAuthenticator.username_key | string | `"preferred_username"` |  |
| jupyterhub.hub.db.type | string | `"postgres"` |  |
| jupyterhub.hub.db.url | string | `nil` |  |
| jupyterhub.hub.extraConfig.token-exchange | string | `"import pprint\nimport os\nimport warnings\nimport requests\nfrom oauthenticator.generic import GenericOAuthenticator\n\n# custom authenticator to enable auth_state and get access token to set as env var for rucio extension\nclass RucioAuthenticator(GenericOAuthenticator):\n    def __init__(self, **kwargs):\n        super().__init__(**kwargs)\n        self.enable_auth_state = True\n\n    def exchange_token(self, token):\n        params = {\n            'client_id': self.client_id,\n            'client_secret': self.client_secret,\n            'grant_type': 'urn:ietf:params:oauth:grant-type:token-exchange',\n            'subject_token_type': 'urn:ietf:params:oauth:token-type:access_token',\n            'subject_token': token,\n            'scope': 'openid profile',\n            'audience': 'rucio'\n        }\n        response = requests.post(self.token_url, data=params)\n        print(\"EXCHANGE TOKEN for params\", params)\n        print(response.json())\n        rucio_token = response.json()['access_token']\n\n        return rucio_token\n\n    async def pre_spawn_start(self, user, spawner):\n        auth_state = await user.get_auth_state()\n        #print(\"AUTH_state\")\n        #pprint.pprint(auth_state)\n        if not auth_state:\n            # user has no auth state\n            return False\n\n        # define token environment variable from auth_state\n        spawner.environment['RUCIO_ACCESS_TOKEN'] = self.exchange_token(auth_state['access_token'])\n        spawner.environment['EOS_ACCESS_TOKEN'] = auth_state['access_token']\n        spawner.environment['NOPAYLOADDB_TOKEN'] = auth_state['access_token']\n\n# set the above authenticator as the default\nc.JupyterHub.authenticator_class = RucioAuthenticator\n\n# enable authentication state\nc.GenericOAuthenticator.enable_auth_state = True\n"` |  |
| jupyterhub.hub.networkPolicy.enabled | bool | `false` |  |
| jupyterhub.hub.service.type | string | `"ClusterIP"` |  |
| jupyterhub.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| jupyterhub.ingress.annotations."ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| jupyterhub.ingress.annotations."traefik.frontend.entryPoints" | string | `"http,https"` |  |
| jupyterhub.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| jupyterhub.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| jupyterhub.ingress.enabled | bool | `true` |  |
| jupyterhub.ingress.hosts | list | `[]` |  |
| jupyterhub.ingress.ingressClassName | string | `nil` |  |
| jupyterhub.prePuller.hook.enabled | bool | `true` |  |
| jupyterhub.proxy.service.type | string | `"ClusterIP"` |  |
| jupyterhub.singleuser.cloudMetadata.blockWithIptables | bool | `false` |  |
| jupyterhub.singleuser.cmd | string | `nil` |  |
| jupyterhub.singleuser.defaultUrl | string | `"/lab"` |  |
| jupyterhub.singleuser.extraEnv.CONDA_ENV_NAME | string | `"IGWN"` |  |
| jupyterhub.singleuser.extraEnv.CONDA_ENV_SOURCE_URL | string | `"https://computing.docs.ligo.org/conda/environments/linux-aarch64/igwn.yaml"` |  |
| jupyterhub.singleuser.extraEnv.CONDA_PKGS_EXCLUDE | string | `"_x86_64-microarch-level=3=3_haswell"` |  |
| jupyterhub.singleuser.extraEnv.NOPAYLOADDB_FILES_URL | string | `"http://escape-vre-npdb-nginx"` |  |
| jupyterhub.singleuser.extraEnv.NOPAYLOADDB_SOURCE_NAME | string | `"Escape VRE HSF CDB"` |  |
| jupyterhub.singleuser.extraEnv.NOPAYLOADDB_URL | string | `"http://escape-vre-npdb-nginx"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_AUTH_URL | string | `"https://et-rucio-server.to.infn.it"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_BASE_URL | string | `"https://et-rucio-server.to.infn.it"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_DEFAULT_AUTH_TYPE | string | `"oidc"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_DESTINATION_RSE | string | `"LOUVAIN"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_DISPLAY_NAME | string | `"RUCIO - ETAP VRE"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_MODE | string | `"replica"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_MULTI_HOST_COMMANDS | string | `"whoami, ping, list, download"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_MULTI_HOST_SERVERS | string | `"ET server, CE server"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_NAME | string | `"et-rucio-server.to.infn.it"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OAUTH_ID | string | `"rucio"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_AUDIENCE | string | `"rucio"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_AUTH | string | `"env"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_ENV_NAME | string | `"RUCIO_ACCESS_TOKEN"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_ISSUER | string | `"et-indigo-iam"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_POLLING | string | `"true"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_REFRESH_ACTIVATE | string | `"true"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_OIDC_SCOPE | string | `"openid profile offline_access storage.read:/ storage.modify:/"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_RSE_MOUNT_PATH | string | `"/data"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_SITE_NAME | string | `"ETAP"` |  |
| jupyterhub.singleuser.extraEnv.RUCIO_WILDCARD_ENABLED | string | `"1"` |  |
| jupyterhub.singleuser.image.name | string | `"ghcr.io/vre-hub/vre-singleuser-py311"` |  |
| jupyterhub.singleuser.image.pullPolicy | string | `"Always"` |  |
| jupyterhub.singleuser.image.tag | string | `"sha-281055c"` |  |
| jupyterhub.singleuser.lifecycleHooks.postStart.exec.command[0] | string | `"sh"` |  |
| jupyterhub.singleuser.lifecycleHooks.postStart.exec.command[1] | string | `"-c"` |  |
| jupyterhub.singleuser.lifecycleHooks.postStart.exec.command[2] | string | `"bash /hooks/rucio/postStart_rucio.sh > /tmp/postStart_rucio.log 2>&1 || true\nbash /hooks/conda/postStart_conda.sh > /tmp/postStart_conda.log 2>&1 || true\n"` |  |
| jupyterhub.singleuser.networkPolicy.enabled | bool | `false` |  |
| jupyterhub.singleuser.profileList[0].default | bool | `true` |  |
| jupyterhub.singleuser.profileList[0].description | string | `"Based on a scipy notebook environment with a python-3.11 kernel, the rucio jupyterlab extension and the reana client installed."` |  |
| jupyterhub.singleuser.profileList[0].display_name | string | `"Default environment"` |  |
| jupyterhub.singleuser.profileList[1].default | bool | `false` |  |
| jupyterhub.singleuser.profileList[1].description | string | `"Based on a scipy notebook environment with a python-3.11 kernel, the rucio jupyterlab extension and the reana client installed."` |  |
| jupyterhub.singleuser.profileList[1].display_name | string | `"Default environment, multi-RI rucio 39.2"` |  |
| jupyterhub.singleuser.startTimeout | int | `1200` |  |
| jupyterhub.singleuser.storage.capacity | string | `"100Gi"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[0].mountPath | string | `"/data"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[0].name | string | `"jupyterhub-shared"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[0].readOnly | bool | `true` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[1].mountPath | string | `"/hooks/rucio"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[1].name | string | `"rucio-client-setup"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[2].mountPath | string | `"/hooks/conda"` |  |
| jupyterhub.singleuser.storage.extraVolumeMounts[2].name | string | `"conda-setup"` |  |
| jupyterhub.singleuser.storage.extraVolumes[0].name | string | `"jupyterhub-shared"` |  |
| jupyterhub.singleuser.storage.extraVolumes[0].persistentVolumeClaim.claimName | string | `"data-rclone-pvc"` |  |
| jupyterhub.singleuser.storage.extraVolumes[1].configMap.defaultMode | int | `493` |  |
| jupyterhub.singleuser.storage.extraVolumes[1].configMap.name | string | `"rucio-client-setup"` |  |
| jupyterhub.singleuser.storage.extraVolumes[1].name | string | `"rucio-client-setup"` |  |
| jupyterhub.singleuser.storage.extraVolumes[2].configMap.defaultMode | int | `493` |  |
| jupyterhub.singleuser.storage.extraVolumes[2].configMap.name | string | `"conda-setup"` |  |
| jupyterhub.singleuser.storage.extraVolumes[2].name | string | `"conda-setup"` |  |
| loki.backend.replicas | int | `0` |  |
| loki.bloomCompactor.replicas | int | `0` |  |
| loki.bloomGateway.replicas | int | `0` |  |
| loki.compactor.replicas | int | `0` |  |
| loki.deploymentMode | string | `"SingleBinary"` |  |
| loki.distributor.replicas | int | `0` |  |
| loki.enabled | bool | `false` |  |
| loki.indexGateway.replicas | int | `0` |  |
| loki.ingester.replicas | int | `0` |  |
| loki.loki.auth_enabled | bool | `false` |  |
| loki.loki.commonConfig.replication_factor | int | `1` |  |
| loki.loki.limits_config.allow_structured_metadata | bool | `true` |  |
| loki.loki.limits_config.volume_enabled | bool | `true` |  |
| loki.loki.pattern_ingester.enabled | bool | `true` |  |
| loki.loki.ruler.enable_api | bool | `true` |  |
| loki.loki.schemaConfig.configs[0].from | string | `"2024-04-01"` |  |
| loki.loki.schemaConfig.configs[0].index.period | string | `"24h"` |  |
| loki.loki.schemaConfig.configs[0].index.prefix | string | `"loki_index_"` |  |
| loki.loki.schemaConfig.configs[0].object_store | string | `"s3"` |  |
| loki.loki.schemaConfig.configs[0].schema | string | `"v13"` |  |
| loki.loki.schemaConfig.configs[0].store | string | `"tsdb"` |  |
| loki.minio.enabled | bool | `true` |  |
| loki.monitoring.selfMonitoring.enabled | bool | `false` |  |
| loki.monitoring.selfMonitoring.grafanaAgent.installOperator | bool | `false` |  |
| loki.monitoring.selfMonitoring.lokiCanary.enabled | bool | `false` |  |
| loki.querier.replicas | int | `0` |  |
| loki.queryFrontend.replicas | int | `0` |  |
| loki.queryScheduler.replicas | int | `0` |  |
| loki.read.replicas | int | `0` |  |
| loki.rollout_operator.enabled | bool | `false` |  |
| loki.singleBinary.replicas | int | `1` |  |
| loki.test.enabled | bool | `false` |  |
| loki.write.replicas | int | `0` |  |
| multiRI.enabled | bool | `false` |  |
| nfs-server-provisioner.enabled | bool | `true` |  |
| nfs-server-provisioner.persistence.enabled | bool | `true` |  |
| nfs-server-provisioner.persistence.size | string | `"10Gi"` |  |
| nfs-server-provisioner.persistence.storageClass | string | `""` |  |
| nfs-server-provisioner.storageClass.mountOptions[0] | string | `"tcp"` |  |
| nfs-server-provisioner.storageClass.mountOptions[1] | string | `"nfsvers=4.1"` |  |
| nfs-server-provisioner.storageClass.mountOptions[2] | string | `"retrans=2"` |  |
| nfs-server-provisioner.storageClass.mountOptions[3] | string | `"timeo=30"` |  |
| nfs-server-provisioner.storageClass.name | string | `"escape-vre-shared-volume-storage-class"` |  |
| nfs-server-provisioner.tolerations[0].effect | string | `"NoSchedule"` |  |
| nfs-server-provisioner.tolerations[0].key | string | `"CriticalAddonsOnly"` |  |
| nfs-server-provisioner.tolerations[0].operator | string | `"Exists"` |  |
| npdb.backend.type | string | `"django"` |  |
| npdb.django.migrations.enabled | bool | `true` |  |
| npdb.django.replicas | int | `1` |  |
| npdb.enabled | bool | `true` |  |
| npdb.files.authentication.requireForDownloads | bool | `false` |  |
| npdb.files.authentication.userinfoUrl | string | `"https://iam-et.cloud.cnaf.infn.it/userinfo"` |  |
| npdb.files.upload.enabled | bool | `true` |  |
| npdb.hosts.api | string | `"npdb-api"` |  |
| npdb.hosts.files | string | `"npdb-files"` |  |
| npdb.ingress.enabled | bool | `false` |  |
| npdb.nginx.podSecurityContext.fsGroup | int | `101` |  |
| npdb.pgbouncer.enabled | bool | `false` |  |
| npdb.platform | string | `"kubernetes"` |  |
| npdb.postgresql.auth.database | string | `"cdb"` |  |
| npdb.postgresql.auth.password | string | `"change-me"` |  |
| npdb.postgresql.auth.username | string | `"cdb"` |  |
| npdb.postgresql.enabled | bool | `true` |  |
| npdb.postgresql.primary.persistence.enabled | bool | `true` |  |
| npdb.postgresql.primary.persistence.size | string | `"8Gi"` |  |
| npdb.storage.payload.create | bool | `true` |  |
| npdb.storage.payload.size | string | `"2Gi"` |  |
| npdb.storage.payload.storageClass | string | `"escape-vre-shared-volume-storage-class"` |  |
| prometheus.enabled | bool | `false` |  |
| reana.components.reana_db.enabled | bool | `true` |  |
| reana.components.reana_server.environment.REANA_USER_EMAIL_CONFIRMATION | bool | `false` |  |
| reana.components.reana_ui.enabled | bool | `true` |  |
| reana.components.reana_ui.local_users | bool | `false` |  |
| reana.components.reana_workflow_controller.environment.REANA_JOB_STATUS_CONSUMER_PREFETCH_COUNT | int | `10` |  |
| reana.components.reana_workflow_controller.environment.SHARED_VOLUME_PATH | string | `"/var/reana/"` |  |
| reana.components.reana_workflow_controller.image | string | `"docker.io/reanahub/reana-workflow-controller:0.9.4"` |  |
| reana.components.reana_workflow_controller.imagePullPolicy | string | `"IfNotPresent"` |  |
| reana.compute_backends[0] | string | `"kubernetes"` |  |
| reana.db_env_config.REANA_DB_HOST | string | `"escape-vre-db"` |  |
| reana.db_env_config.REANA_DB_NAME | string | `"postgres"` |  |
| reana.db_env_config.REANA_DB_PORT | string | `"5432"` |  |
| reana.debug.enabled | bool | `false` |  |
| reana.enabled | bool | `true` |  |
| reana.fluent-bit.enabled | bool | `false` |  |
| reana.ingress.enabled | bool | `false` |  |
| reana.ingress_override | bool | `true` |  |
| reana.login[0].config.auth_url | string | `"https://iam-escape.cloud.cnaf.infn.it/authorize"` |  |
| reana.login[0].config.base_url | string | `"https://iam-escape.cloud.cnaf.infn.it"` |  |
| reana.login[0].config.realm_url | string | `"https://iam-escape.cloud.cnaf.infn.it"` |  |
| reana.login[0].config.title | string | `"ESCAPE IAM"` |  |
| reana.login[0].config.token_url | string | `"https://iam-escape.cloud.cnaf.infn.it/token"` |  |
| reana.login[0].config.userinfo_url | string | `"https://iam-escape.cloud.cnaf.infn.it/userinfo"` |  |
| reana.login[0].name | string | `"iam"` |  |
| reana.login[0].type | string | `"keycloak"` |  |
| reana.notifications.enabled | bool | `false` |  |
| reana.quota.default_cpu_limit | int | `36000000` |  |
| reana.quota.default_disk_limit | int | `10737418240` |  |
| reana.reana_hostname | string | `"reana-vre.obsuks4.unige.ch"` |  |
| reana.secrets.database.password | string | `nil` |  |
| reana.secrets.database.user | string | `nil` |  |
| reana.secrets.login.iam.consumer_key | string | `nil` |  |
| reana.secrets.login.iam.consumer_secret | string | `nil` |  |
| reana.shared_storage.access_modes | string | `"ReadWriteMany"` |  |
| reana.shared_storage.backend | string | `"nfs"` |  |
| reana.shared_storage.volume_size | int | `1` |  |
| reana.traefik.enabled | bool | `false` |  |
| reana.workspaces.paths[0] | string | `"/var/reana:/var/reana"` |  |
| reana.workspaces.retention_rules.cronjob_schedule | string | `"0 2 * * *"` |  |
| reana.workspaces.retention_rules.maximum_period | string | `"forever"` |  |
| rucioClientSetup.configMapName | string | `"rucio-client-setup"` |  |
| rucioClientSetup.enabled | bool | `false` |  |

