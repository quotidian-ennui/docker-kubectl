# docker-kubectl

> I don't always run latest, and bitnami/kubectl has gone away and it's not coming back.

## Notes

- Just uses the base debian:bookworm-slim image and adds kubectl (this is enough for me).
- Tags will probably follow the kubectl version; with updatecli telling me what to update to.
- No you don't get a v1.33; if you wanted that, then do the right thing with a debian apt source instead

