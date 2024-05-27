FROM python:3.8
WORKDIR /app
ENV DBT_PROD_CONFIG "prod"
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

FROM xemuliam/dbt:1.3
ENV DBT_PROD_CONFIG "prod"
USER root
WORKDIR /dbt
COPY --from=builder /app/server ./
COPY scripts/*.sh ./
COPY . ./

ENTRYPOINT "./server"