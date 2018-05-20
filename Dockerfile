FROM dagman62/apache 

# install dependancies for apr, httpd, and php7

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     golang \
     git

# install and configure golang for apache_exporter for premetheous

WORKDIR /root

RUN git init \ 
  && git config --global http.sslVerify false \
  && mkdir go \
  && export GOPATH=/root/go \
  && export PATH=$PATH:$GOPATH/bin \
  && go get github.com/neezgee/apache_exporter \
  && ln -sf /root/go/bin/apache_exporter /usr/bin/apache_exporter 

WORKDIR /

COPY apache-exporter.conf /etc/init/apache-exporter.conf

COPY apache_exporter /etc/init.d/apache_exporter

COPY startup-exporter /usr/local/bin/startup-exporter

# cleanup packages that are not needed anymore

RUN chmod +x /etc/init.d/apache_exporter \
  && chmod +x /usr/local/bin/startup-exporter \
  && rm -rf /var/tmp/* \
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 9117

CMD ["startup-exporter"]

CMD ["start-apache"]

