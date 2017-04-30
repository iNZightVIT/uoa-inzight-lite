# ----------------------------------------
#
# This image inherits uoa-inzight-lite-base image, 
# updates packages from docker.stat.auckland.ac.nz 
# repository and installs the shiny app for Lite
#
# ----------------------------------------
FROM scienceis/uoa-inzight-lite-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

# Edit the following environment variable, commit to Github and it will trigger Docker build
# Since we fetch the latest changes from the associated Application~s master branch
# this helps trigger date based build
# The other option would be to tag git builds and refer to the latest tag
ENV LAST_BUILD_DATE "Sun 30 04 23:55:00 NZDT 2017"

# Install (via R) all of the necessary packages (R will automatially install dependencies):
RUN apt-get update \
  && apt-get install -y -q \
                     libxml2-dev \
  && R -e "update.packages(oldPkgs = 'shiny', repos = 'https://cran.r-project.org', ask = FALSE); install.packages('hextri', repos = 'https://cran.r-project.org', type = 'source'); install.packages('colorspace', repos = 'https://cran.r-project.org', type = 'source', dependencies = TRUE); install.packages('RColorBrewer', repos = 'https://cran.r-project.org', type = 'source', dependencies = TRUE); install.packages('viridis', repos = 'https://cran.r-project.org', type = 'source', dependencies = TRUE); install.packages('gridSVG', repos = 'https://cran.r-project.org', type = 'source', dependencies = TRUE);  install.packages('RgoogleMaps', repos = 'https://cran.r-project.org', dependencies = TRUE); install.packages('countrycode', repos = 'https://cran.r-project.org'); update.packages(repos = 'http://r.docker.stat.auckland.ac.nz/R/', ask = FALSE); install.packages('iNZightMaps', repos = 'http://r.docker.stat.auckland.ac.nz/R/')" \
  && rm -rf /srv/shiny-server/* \
  && wget --no-verbose -O Lite.zip https://github.com/iNZightVIT/Lite/archive/master.zip \
  && unzip Lite.zip \
  && cp -R Lite-master/* /srv/shiny-server \
  && echo $LAST_BUILD_DATE > /srv/shiny-server/build.txt \
  && rm -rf Lite.zip Lite-master/ \
  && rm -rf /tmp/* /var/tmp/*

# start shiny server process - it listens to port 3838
CMD ["/opt/shiny-server.sh"]
