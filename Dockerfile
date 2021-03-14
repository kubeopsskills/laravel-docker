# From Nginx-PHP-FPM
FROM wyveo/nginx-php-fpm:php80

# Add Laravel App
COPY laravel /usr/share/nginx/html/

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel Dependencies
WORKDIR /usr/share/nginx/html
RUN composer install --no-dev

# Add Nginx config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
ADD nginx/nginx.conf /etc/nginx/nginx.conf

# Add PHP-FPM config
COPY php-fpm/www.conf /etc/php/8.0/fpm/pool.d/www.conf

# Set Timezone to Asia/Bangkok (GMT+7)
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone	
	
# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/app.log && \
    ln -sf /dev/stderr /var/log/nginx/app.error.log
