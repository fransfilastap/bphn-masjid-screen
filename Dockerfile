FROM composer AS composer

# copying the source directory and install the dependencies with composer
COPY ./app /app

# run composer install to install the dependencies
RUN composer install \
  --optimize-autoloader \
  --no-interaction \
  --no-progress

# continue stage build with the desired image and copy the source including the
# dependencies downloaded by composer
FROM trafex/php-nginx

# Add environment variable for port
ENV PORT=8080

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

COPY --chown=nobody --from=composer /app /var/www/html

# Expose the port
EXPOSE ${PORT}