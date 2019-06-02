
FROM alpine:edge
MAINTAINER lignumaqua "mike@mikewoodconsulting.com"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh


ENV MYSQLDUMP_OPTIONS --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384
ENV MYSQL_HOST ""
ENV MYSQL_PORT 3306
ENV MYSQL_USER ""
ENV MYSQL_PASSWORD ""
ENV DROPBOX_PREFIX ""
ENV DROPBOX_ACCESS_TOKEN ""
ENV SCHEDULE ""
ENV TZ=America/Chicago

RUN apk add --no-cache tzdata
ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]
