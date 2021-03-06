FROM alpine:3.9

EXPOSE 8000
ADD requirements.txt /var/www/requirements.txt
WORKDIR /var/www

# postgresql-dev needed for pg_config
# libpq needed by psycopg2
# libffi-dev needed by anonlink
# g++ needed by anonlink/cffi
# yajl, yajl-dev needed by ijson
# gmp-dev, mpfr-dev, mpc1-dev needed by gmpy2

RUN apk add --no-cache python3 libstdc++ mpc1-dev yajl libpq && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apk add --no-cache --virtual .build-deps g++ python3-dev yajl-dev postgresql-dev libffi-dev gmp-dev mpfr-dev && \
    pip3 install --upgrade pip setuptools && \
    pip3 install --upgrade -r requirements.txt && \
    apk del --no-cache .build-deps && \
    rm -fr /tmp/* /var/cache/apk/* /root/.cache/pip

RUN python -c "import anonlink; print('anonlink version:', anonlink.__version__)" && \
    python -c "import clkhash; print('clkhash version:', clkhash.__version__)"

RUN adduser -D -H -h /var/www user && \
    chown user:user /var/www /var/log
USER user

ADD . /var/www

# Serve using gunicorn. Ideally this has nginx in front of it!
CMD gunicorn entityservice:app \
    -n entityservice-web \
    -w 4 \
    -b 0.0.0.0:8000 \
    --timeout 600 \
    --keep-alive 300 \
    --graceful-timeout 120 \
    --log-level info \
    --access-logfile /var/log/gunicorn-access.log

