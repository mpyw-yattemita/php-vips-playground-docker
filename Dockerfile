FROM php:8.1-cli
LABEL maintainer="mpyw <mpyw628@gmail.com>"

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

ENV LIBVIPS_VERSION=8.12.2 DEBIAN_FRONTEND=noninteractive

# https://github.com/marcbachmann/dockerfile-libvips
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake build-essential curl gobject-introspection gtk-doc-tools libglib2.0-dev \
        libpng-dev libjpeg62-turbo-dev libwebp-dev libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev \
        swig libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev libgsf-1-dev fftw3-dev liborc-0.4-dev \
        librsvg2-dev libimagequant-dev libffi-dev \
    && cd /tmp \
    && curl -L \
        https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz \
        > vips-$LIBVIPS_VERSION.tar.gz \
    && tar xf vips-$LIBVIPS_VERSION.tar.gz \
    && cd vips-$LIBVIPS_VERSION \
    && ./configure --enable-debug=no --without-python --without-magick \
    && make \
    && make install \
    && ldconfig \
    && apt-get remove -y curl automake build-essential \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://www.labohyt.net/blog/server/post-3309/
RUN pecl install vips \
    && echo "extension=vips.so" >> "$PHP_INI_DIR/vips.ini" \
    && docker-php-ext-configure ffi --with-ffi \
    && docker-php-ext-install ffi

WORKDIR /code
