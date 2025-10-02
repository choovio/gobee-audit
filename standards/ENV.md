# Environment Matrix (SBX baseline)

## Global
- PUBLIC_ORIGIN=https://sbx.gobee.io
- API_BASE_PATH=/api
- CF_DNS=Cloudflare (managed)
- NAMESPACE=magistrala

## Magistrala (examples)
- MG_DB_DSN=postgres://user:pass@timescale:5432/magistrala?sslmode=disable
- MG_REDIS_URL=redis://redis:6379/0
- MG_AUTH_PUBLIC_URL=${PUBLIC_ORIGIN}  # avoids localhost redirects
- MG_RULES_URL=http://rules:8080

## LoRa Adapter
- MG_LORA_ADAPTER_MESSAGES_URL=tcp://mosquitto:1883
- MG_REDIS_URL=redis://redis:6379/1

## ChirpStack (slim SBX)
- CS_POSTGRES_DSN=postgres://cs_user:cs_pass@cs-postgres:5432/chirpstack?sslmode=disable
- CS_REDIS_ADDR=cs-redis:6379
- CS_MQTT_BROKER=tcp://mosquitto:1883