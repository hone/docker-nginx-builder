FROM heroku/cedar:14
MAINTAINER hone

# needed for rewrite module
RUN apt-get install libpcre3-dev

# setup workspace
RUN rm -rf /tmp/workspace
RUN mkdir -p /tmp/workspace

# output dir is mounted
COPY build.sh /tmp/build.sh
CMD ["sh", "/tmp/build.sh", "/tmp/workspace", "/tmp/output", "/tmp/cache"]
