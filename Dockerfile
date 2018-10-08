FROM golang:1.10-alpine AS base
    ENV APPDIR /usr/hud
    WORKDIR ${APPDIR}
   COPY requirements.txt ${APPDIR}
 
    RUN apk update && \
        apk upgrade && \
        apk add --update --no-cache `cat ${APPDIR}/requirements.txt` && \
        rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

FROM base AS code
    COPY main.go ${APPDIR}
    COPY manifests ${APPDIR}
    RUN cd manifests;tar -zcf hud-catalog.tgz --exclude hud-catalog.tgz --exclude README.md .; rm -Rf manifests; cd ..

FROM code AS compiler
    RUN CGO_ENABLED=0 GOOS=linux GARCH=amd64 go build -o /bin/hudserver

FROM compiler AS development
    ENV PORT 80
    EXPOSE ${PORT}

    CMD ["/bin/hudserver"]


FROM alpine:3.7 AS release
    ENV PORT 9090
    ENV APPDIR /usr/hud
    
    EXPOSE ${PORT}
    WORKDIR ${APPDIR}

    COPY --from=compiler /bin/hudserver /bin/hudserver

    RUN addgroup -g 1000 -S hud && \
        adduser -u 1000 -S hud -G hud

    COPY index.html ${APPDIR}
    COPY --from=code ${APPDIR}/manifests/hud-catalog.tgz ${APPDIR}

    USER hud
    CMD ["/bin/hudserver"]
