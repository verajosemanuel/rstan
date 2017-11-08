FROM rocker/ropensci:latest

LABEL maintainer "vera.josemanuel@gmail.com"

# Install rstan
 RUN install2.r --error --deps TRUE \
    rstan \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Global site-wide config -- neeeded for building packages
RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs \n" >> $HOME/.R/Makevars

# Config for rstudio user
RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs -Wno-ignored-attributes -Wno-deprecated-declarations\n" >> $HOME/.R/Makevars \
    && echo "rstan::rstan_options(auto_write = TRUE)\n" >> /home/rstudio/.Rprofile \
    && echo "options(mc.cores = parallel::detectCores())\n" >> /home/rstudio/.Rprofile

# Install rstan again
RUN install2.r --error --deps TRUE \
    rstan \
	loo \
	bayesplot \
    rstanarm \
    rstantools \
	shiny \
    shinystan \
    ggmcmc \
	brms \
	shinyBS \
	shinydashboard \
	shinyFiles \
	shinyjs \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
	
	
RUN install2.r --error --deps TRUE Amelia \
&& Rscript -e 'extrafont::font_import(prompt = FALSE)' \
&& echo "install.packages('rJava', repos='http://www.rforge.net/', configure.args='--disable-Xrs')" | R --no-save \
&& R CMD javareconf \
&& Rscript /tmp/github_installs.R \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/ \
&& rm -rf /tmp/downloaded_packages/  /tmp/*.rds

