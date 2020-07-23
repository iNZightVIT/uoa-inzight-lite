# ----------------------------------------
#
# This image inherits uoa-inzight-lite-base image, 
# updates packages from docker.stat.auckland.ac.nz 
# repository and installs the shiny app for Lite
#
# ----------------------------------------
FROM scienceis/uoa-inzight-lite-base:shengwei20181220

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Edit the following environment variable, commit to Github and it will trigger Docker build
# Since we fetch the latest changes from the associated Application~s master branch
# this helps trigger date based build
# The other option would be to tag git builds and refer to the latest tag
ENV LAST_BUILD_DATE "Thu 30 04 21:45:00 NZDT 2020"

COPY shiny-server.sh /usr/bin/shiny-server.sh
# Install (via R) all of the necessary packages (R will automatially install dependencies):
RUN wget --no-verbose -O shiny-server.deb https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.13.944-amd64.deb \
  && dpkg -i shiny-server.deb \
  && chmod +x /usr/bin/shiny-server.sh \
  && rm -f shiny-server.deb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -rf /srv/shiny-server/* \
  && wget --no-verbose -O Lite.zip https://github.com/iNZightVIT/Lite/archive/bugfix/R4.zip \
  && unzip Lite.zip \
  && cp -R Lite-bugfix-R4/* /srv/shiny-server \
  && echo $LAST_BUILD_DATE > /srv/shiny-server/build.txt \
  && rm -rf Lite.zip Lite-bugfix-R4/ \
  && rm -rf /tmp/* /var/tmp/*

RUN chown shiny:shiny /var/lib/shiny-server

EXPOSE 3838



CMD ["/usr/bin/shiny-server.sh"]
