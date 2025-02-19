FROM php:7-cli-alpine

LABEL maintainer.name="xczh" \
      maintainer.email="xczh.me@foxmail.com" \
      maintainer.description="OLAINDEX: Another OneDrive Directory Index"
ENV LANG=C.UTF-8
WORKDIR /OLAINDEX
RUN apk add --no-cache tzdata git composer && \
    echo "Asia/Shanghai" > /etc/timezone && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata && \
    docker-php-ext-install bcmath && \
    git clone --depth 1 https://github.com/goddaren/OLAINDEX.git . && \
    composer install -vvv && \
    composer run install-app && \
    addgroup -g 900 -S olaindex && \
    adduser -h /OLAINDEX -s /bin/sh -G olaindex -u 900 -S olaindex && \
    chown -R olaindex:olaindex /OLAINDEX && \
    chmod 755 /OLAINDEX/storage

EXPOSE $PORT

CMD ["su", "olaindex", "-c","php artisan key:generate"]
CMD ["su", "olaindex", "-c","php artisan config:clear"]
CMD ["su", "olaindex", "-c","php artisan config:cache"]
CMD ["su", "olaindex", "-c","php artisan migrate --seed"]
CMD ["su", "olaindex", "-c", "php artisan serve --host=0.0.0.0 --port=$PORT --tries=0 --no-interaction"]
