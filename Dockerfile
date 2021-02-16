# Filename: Dockerfile
FROM camptocamp/mapfish_print:3.27
ADD ./apps ${CATALINA_HOME}/webapps/ROOT/print-apps

# CORS HEADERS
# RUN /etc/init.d/apache2 reload
