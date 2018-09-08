FROM tomcat:8.5.33-jre10

ENV PATH="/opt/confd/bin:${PATH}" \
# empty password will lead to a random password being generated
    TOMCAT_MANAGER_PASSWORD=""

CMD ["./run.sh"]

RUN set -x \
# download confd
 && curl -sSfL -o confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 \
# validate checksum or fail
 && echo "255d2559f3824dd64df059bdc533fd6b697c070db603c76aaf8d1d5e6b0cc334 confd" | sha256sum -c - || exit 1 \
# install confd
 && mkdir -p /opt/confd/bin \
 && mv confd /opt/confd/bin/confd \
 && chmod +x /opt/confd/bin/confd

HEALTHCHECK CMD curl -u manager:\${TOMCAT_MANAGER_PASSWORD} http://localhost:8080/manager/status/all?XML=true || exit 1

COPY ./confd /etc/confd
COPY run.sh run.sh

RUN chmod +x run.sh
