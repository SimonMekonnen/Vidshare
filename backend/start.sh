#!/bin/bash
python manage.py collectstatic --noinput
python manage.py migrate
gunicorn vidshare.wsgi:application --bind 0.0.0.0:$PORT