FROM golang:1.11.2-alpine3.8

RUN apk add --update vim && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /web/static/ 

COPY web.go /web/web.go
COPY index.html /web/static/index.html

EXPOSE 3000

WORKDIR /web

ENTRYPOINT go run /web/web.go

