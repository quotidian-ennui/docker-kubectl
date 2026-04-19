# docker-kubectl

> I don't always run latest, and bitnami/kubectl has gone away and it's not coming back.

## Notes

- Just uses the base ~~debian:bookworm-slim~~ debian:trixie-slim image and adds kubectl (this is enough for me).
  - 1.35.4 still uses `bookworm:slim`
  - Releases after 1.35.4 will use `trixie-slim` because Aug 2025 was a _long time ago_
- Tags will probably follow the kubectl version; with updatecli telling me what to update to.
- You should probably use the explicit semver rather than the less explicit 1.33 variant but that's up to you.
