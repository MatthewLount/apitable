FROM liquibase/liquibase:4.21.1

RUN lpm add mysql --global
ADD src/main/resources /liquibase/changelog

ARG SEMVER_FULL
ENV SEMVER_FULL=${SEMVER_FULL}

CMD ["sh", "-c", "echo \"clearChecksums\"; \
docker-entrypoint.sh \
    --classpath=/liquibase/changelog \
    --changelog-file=${CHANGELOG_FILE:=db/changelog/db.changelog-master.xml} \
    --log-level=warning \
    --username=${DB_USERNAME} \
    --password=${DB_PASSWORD} \
    --driver=\"com.mysql.cj.jdbc.Driver\" \
    --database-changelog-table-name=\"${DATABASE_TABLE_PREFIX:=apitable_}db_changelog\" \
    --database-changelog-lock-table-name=\"${DATABASE_TABLE_PREFIX:=apitable_}db_changelog_lock\" \
    --url=\"jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?characterEncoding=utf8&autoReconnect=true&useSSL=true\" \
     clearChecksums; \
echo ACTION=${ACTION}; docker-entrypoint.sh \
    --classpath=/liquibase/changelog \
    --changelog-file=${CHANGELOG_FILE:=db/changelog/db.changelog-master.xml} \
    --log-level=warning \
    --username=${DB_USERNAME} \
    --password=${DB_PASSWORD} \
    --driver=\"com.mysql.cj.jdbc.Driver\" \
    --database-changelog-table-name=\"${DATABASE_TABLE_PREFIX:=apitable_}db_changelog\" \
    --database-changelog-lock-table-name=\"${DATABASE_TABLE_PREFIX:=apitable_}db_changelog_lock\" \
    --url=\"jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?characterEncoding=utf8&autoReconnect=true&useSSL=true\" \
     ${ACTION:=update} \
    -Dtable.prefix=${DATABASE_TABLE_PREFIX:=apitable_} \
    -DDB_ENGINE=${DB_ENGINE:=mysql}"]