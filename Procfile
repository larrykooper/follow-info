web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: VVERBOSE=1 QUEUE=pif_updating rake environment resque:work