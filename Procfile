web: bundle exec rails server thin -p $PORT -e $RACK_ENV
worker: VVERBOSE=1 QUEUE=pif_updating rake environment resque:work