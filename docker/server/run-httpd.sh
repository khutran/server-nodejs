#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/nginx*

exec nginx &
exec forever start /var/www/web/ecosystem/remote_forever.json