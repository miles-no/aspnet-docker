FROM microsoft/aspnet:1.0.0-beta4
COPY ./bin/output /app
WORKDIR /app
EXPOSE 5004
ENTRYPOINT ["/app/kestrel"]

