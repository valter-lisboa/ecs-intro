FROM alpine:3.12

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add nginx && \
    mkdir -p /run/nginx && \
    chown nginx: /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

USER nginx

ENTRYPOINT ["nginx"]
