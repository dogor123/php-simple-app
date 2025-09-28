FROM php:8.2-cli

# Argumento para versión del build
ARG BUILD_VERSION
ENV BUILD_VERSION=$BUILD_VERSION

# Copiar solo el contenido necesario
COPY src/ /var/www/html/

# Servidor embebido de PHP
CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html/"]

EXPOSE 80