# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0

Namespace: gobee

Shared Infra (Running):

NATS: 1× Deployment, ClusterIP svc nats (4222/8222)

Redis: 1× Deployment, ClusterIP svc redis (6379)

Postgres (in-cluster): to be removed after RDS migration

Prior CrashLoop due to lost+found; mitigations added (fsGroup:70, PGDATA=/var/lib/postgresql/data/pgdata, initContainer to prep subdir)
