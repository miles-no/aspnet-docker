FROM jstclair/jessie-libuv

COPY ./bin/output /app
WORKDIR /app
EXPOSE 5004
ENTRYPOINT ["/app/kestrel"]

