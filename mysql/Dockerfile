FROM mysql:8.0.33-debian

RUN rm -f /etc/apt/sources.list.d/mysql.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends cron curl python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["/backup.sh"]
