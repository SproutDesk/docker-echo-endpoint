FROM alpine:3.14

RUN apk add --no-cache \
    nginx \
    nginx-mod-http-fancyindex \
    nginx-mod-http-echo

ADD https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64 /usr/local/bin/envsubst
RUN chmod +x /usr/local/bin/envsubst

RUN rm -f /etc/nginx/http.d/default.conf
RUN mkdir -p /echofiles/webroot /echofiles/theme \
    && chown nginx:nginx /echofiles/ -R
COPY theme /echofiles/theme
COPY nginx.conf /etc/nginx/nginx.conf
COPY echo.conf.template /etc/nginx/templates/

COPY ./docker-entrypoint.sh /
COPY ./docker-entrypoint.d /docker-entrypoint.d
RUN chmod +x /docker-entrypoint.sh /docker-entrypoint.d/*
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR "/echofiles"

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]