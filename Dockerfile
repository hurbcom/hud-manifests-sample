FROM golang:1.10-alpine AS base
    COPY requirements.txt ./

    RUN apk update && \
        apk upgrade && \
        apk add --update --no-cache `cat requirements.txt` && \
        rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

FROM base AS code
    COPY main.go ${APPDIR}
    COPY manifests ${APPDIR}
    RUN cd manifests;tar -zcf hud-catalog.tgz --exclude hud-catalog.tgz --exclude README.md .; rm -Rf manifests; cd ..

FROM code AS compiler
    RUN CGO_ENABLED=0 GOOS=linux GARCH=amd64 go build -o /bin/hudserver

FROM alpine:3.7 AS release
    ENV PORT 9090
    EXPOSE ${PORT}

    COPY --from=compiler /bin/hudserver /bin/hudserver

    RUN addgroup -g 1000 -S hud && \
        adduser -u 1000 -S hud -G hud
    USER hud

    COPY install ${APPDIR}
    COPY index.html ${APPDIR}
    COPY manifests/hud-catalog.tgz ${APPDIR}

    CMD ["/bin/hudserver"]
