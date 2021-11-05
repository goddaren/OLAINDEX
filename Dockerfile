FROM php:7-cli-alpine

LABEL maintainer.name="xczh" \
      maintainer.email="xczh.me@foxmail.com" \
      maintainer.description="OLAINDEX: Another OneDrive Directory Index"

ENV LANG=C.UTF-8

WORKDIR ./

RUN docker-php-ext-install bcmath && \
    composer install -vvv && \
    composer run install-app

EXPOSE $PORT

CMD ["php artisan config:clear"]
CMD ["php artisan config:cache"]
CMD ["php artisan migrate --seed"]
CMD ["php artisan serve --host=0.0.0.0 --port=$PORT --tries=0 --no-interaction"]
