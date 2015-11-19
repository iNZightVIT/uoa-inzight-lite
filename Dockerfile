FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# install R packages specific to iNZight Lite
RUN R -e "update.packages(repos = 'http://docker.stat.auckland.ac.nz/R')" \
  && rm -rf /srv/shiny-server/* \
  && wget -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite/* /srv/shiny-server \
  && rm -rf Lite/

# copy shiny-server startup script
COPY shiny-server.sh /usr/bin/shiny-server.sh

# make it executable
RUN chmod +x /usr/bin/shiny-server.sh

# startup process
CMD ["/usr/bin/shiny-server.sh"]
