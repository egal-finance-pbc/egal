#!/bin/bash

NAME="conellas"                           # Name of the application
DJANGODIR=./../../../entorno/egal/web                 # Django project directory
SOCKFILE=./home/ubuntu/entorno/run/gunicorn.sock
USER=ec2-user                             # User to run as
GROUP=ec2-user
NUM_WORKERS=3                                # Worker processes to spawn
DJANGO_SETTINGS_MODULE=conellas.settings                #uld Django use
DJANGO_WSGI_MODULE=conellas.wsgi          # WSGI module name

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source ./../../../entorno/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

#Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should 
# not daemonize themselves (do not use --daemon)
exec gunicorn ${DJANGO_WSGI_MODULE}:application \
	--name $NAME \
	--workers $NUM_WORKERS \
	--user=$USER \
	--group=$GROUP \
	--bind=unix:$SOCKFILE \
	--log-level=DEBUG \
	--log-file=-








