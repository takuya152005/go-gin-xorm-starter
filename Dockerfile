FROM gemcook/golang:1.11.0 as builder

# install depencencies.
RUN apk add --update gcc musl-dev

ENV APPDIR=github.com/gemcook/go-gin-xorm-starter

WORKDIR /go/src/${APPDIR}
COPY . .
RUN dep ensure
RUN make lint
RUN make test
RUN make build
RUN cp ./bin/starter /tmp/starter

FROM alpine

COPY --from=builder /tmp/starter /opt/api/starter
RUN apk add --no-cache ca-certificates
ENV GIN_MODE=release
ENV PORT=80
CMD ["/opt/api/starter"]
