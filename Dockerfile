FROM heroku/cedar:14
MAINTAINER hone

RUN apt-get update && apt-get install -y --no-install-recommends \
  # needed for rewrite module
  libpcre3-dev \
  # needed for ngx_mruby
  git \
  ca-certificates \
  gperf

# install ruby for ngx_mruby
RUN mkdir -p /opt/ruby-2.2.2/ && \
  curl -s https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/cedar-14/ruby-2.2.2.tgz | tar xzC /opt/ruby-2.2.2/
ENV PATH /opt/ruby-2.2.2/bin:$PATH

# setup workspace
RUN rm -rf /tmp/workspace
RUN mkdir -p /tmp/workspace

# output dir is mounted
COPY build.sh /tmp/build.sh
CMD ["bash", "/tmp/build.sh", "/tmp/workspace", "/tmp/output", "/tmp/cache"]
