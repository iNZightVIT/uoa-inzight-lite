FROM scienceis/uoa-inzight-base:latest

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

## Install (via R) all of the necessary packages (R will automatially install dependencies):
RUN R -e "install.packages(c('iNZightMR', 'iNZightTS', 'iNZightRegression', 'iNZightPlots'), \
                           repos = c('http://docker.stat.auckland.ac.nz/R', 'http://cran.stat.auckland.ac.nz'))"

## startup the shiny-server:
CMD ["sudo", "-u", "shiny", "/usr/bin/shiny-server"]
