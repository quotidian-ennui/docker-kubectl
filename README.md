# docker-kubectl

> I don't always run latest, and bitnami/kubectl has gone away and it's not coming back.

## Notes

- Just uses the base debian:bookworm-slim image and adds kubectl (this is enough for me).
- Tags will probably follow the kubectl version; with updatecli telling me what to update to.
- You should probably use the explicit semver rather than the less explicit 1.33 variant but that's up to you.

