# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0

ECR images (13) pushed and targeted from choovio/gobee-source:

core/bootstrap

core/users

core/domains

core/certs

core/provision

processing/alarms

processing/reports

adapters/http

adapters/ws

adapters/mqtt

adapters/coap

adapters/lora

adapters/opcua

Services: all ClusterIP (CoAP UDP exposed internally)

Current rollout: applied in SBX overlay; DB-backed core services will point to RDS PG (see db note)
