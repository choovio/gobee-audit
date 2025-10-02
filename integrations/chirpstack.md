# ChirpStack Integration (SBX Slim)

## Patterns
- **A** Use PROD LNS (guardrails) | **B** SBX LNS (recommended) | **C** Simulated MQTT (dev-only)
**SBX uses B**: Slim ChirpStack in `magistrala` namespace.

## Components
- `chirpstack` (app server)
- `cs-postgres` (StatefulSet)
- `cs-redis` (Deployment)
- `mosquitto` (MQTT broker)
- `lora-adapter` (Magistrala service bridging MQTT ↔ Magistrala)

## Critical settings
- `MG_LORA_ADAPTER_MESSAGES_URL=tcp://mosquitto:1883`
- Ensure **no port clash** with any other MQTT service.
- Public URLs configured (no `localhost`) to prevent auth redirect bugs.

## E2E test
1. Create ChirpStack tenant "SBX".
2. Add device-profile + device (EUI).
3. Map device EUI ↔ Magistrala client via adapter rules.
4. Observe uplink in Magistrala; send downlink; verify ACK via ChirpStack.