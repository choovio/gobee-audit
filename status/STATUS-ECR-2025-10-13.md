# SBX ECR Digest Lock — 2025-10-13
Namespace: `gobee`  |  Region: `us-west-2`
Origin: https://sbx.gobee.io  |  API Base: /api

## Pushed images (13)
- OK   bootstrap -> gobee/core/bootstrap@sha256:5ee5151b419895b6ce7b66413c8c72d4d502975e43ccdd37f295b86b267d699e
- OK   users -> gobee/core/users@sha256:5b68c9d2c2b0eed63c14b07930fc5e16db89db7aab54a62feb7034ca97cb0f41
- OK   domains -> gobee/core/domains@sha256:4ee3334f7bf0d41460cbe0f41e2f2db237b2662fdab225bf522fd7b8e0660014
- OK   certs -> gobee/core/certs@sha256:692e693150148ea01ddaf339ace7f67b14d1c6d28339c6a12757f9b5dd67aa3b
- OK   provision -> gobee/core/provision@sha256:9100da4030d28be0b15bf685db976c4fd644bb3775721cd5e481cd5847e7ad96
- OK   alarms -> gobee/processing/alarms@sha256:0f4fd61d3418faf80bd1965b9e2bfbb40a183d860ede2750571dbdc21f0a89dc
- OK   reports -> gobee/processing/reports@sha256:53aff9a32694718b3350fe8540c4307bc35ab33c123e9618ce492edee8a1795c
- OK   http -> gobee/adapters/http@sha256:dac8690faf54ae80b0ed580eda3eef95731273b4f8734a1f994ea4959d2a23c7
- OK   ws -> gobee/adapters/ws@sha256:31973dd07190a72c80b143b2aab7d417e9a9a300a18f3ed107a50795516358c8
- OK   mqtt -> gobee/adapters/mqtt@sha256:56f0845c1889dc1a9c4e23d607398a83e700337fc411933f7cf3db7e0e8f8f17
- OK   coap -> gobee/adapters/coap@sha256:4d26d0589e232245998c6c514b8be3150d1dbff9c126a36b7f94929585d6f2ad
- OK   lora -> gobee/adapters/lora@sha256:0903c4a5bb51cc44a5f851ab4702a063e54d9111d38e81143734da415607b5d3
- OK   opcua -> gobee/adapters/opcua@sha256:db5e826b9be19faca1c89b980e7a4e89943c863e13e9bddc8339c02e9577368a

## Skipped legacy (not in modern upstream)
- things, readers, writers, rules, nats

Notes:
- Built via root Dockerfile with `--build-arg SVC=<service>` and Go 1.25 toolchain.
- Digest-pinned per our standards.
