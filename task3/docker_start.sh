#!/bin/bash

# Ensure uploads dir writable by apache
chown www-data:www-data /app/uploads

# Restore files we need to keep
mv /keep/var_log/* /var/log
mv /keep/run/* /run

# Run
/usr/bin/supervisord