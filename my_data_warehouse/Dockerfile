FROM golang:1.15 as builder
WORKDIR /app
ENV DBT_PROD_CONFIG "prod"
COPY invoke.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

FROM xemuliam/dbt:1.3
ENV DBT_AMMO_ENV "prod"
USER root
WORKDIR /dbt
COPY --from=builder /app/server ./
COPY scripts/*.sh ./
COPY . ./

ENTRYPOINT "./server"