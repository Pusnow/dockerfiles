FROM ghcr.io/pusnow/debian-base:bullseye


RUN \
  apt-get update && \
  apt-get -y install \
    python3 \
    python3-pip \
    python3-jinja2 \
    python3-bsddb3 \
    python3-pytest \
    perl \
    git \
    apache2 \
    libapache2-mod-wsgi-py3 \
    libjansson4 \
    libyaml-0-2 \
    wget \
    autoconf \
    automake \
    pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN \
  pip3 install falcon

RUN \
  ln -s /usr/bin/pytest-3 /usr/bin/pytest


ARG CTAG_URL=https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220703.0.tar.gz
ARG PYGMENTS_FNAME=Pygments-2.6.1.elixir-py3-none-any.whl
ARG PYGMENTS_URL=https://bootlin.com/pub/elixir/${PYGMENTS_FNAME}


RUN \
  cd /tmp && \
  wget -O /tmp/ctag.tar.gz ${CTAG_URL} && \ 
  tar --strip-components=1 -xzf /tmp/ctag.tar.gz && \
  ./autogen.sh && \
  ./configure && \
  make -j && \
  make install


RUN \
  wget -O ${PYGMENTS_FNAME} ${PYGMENTS_URL}

RUN \
  pip3 install ${PYGMENTS_FNAME}

RUN \
  git config --global user.email 'elixir@dummy.com' && \
  git config --global user.name 'elixir'

RUN \
  git clone https://github.com/bootlin/elixir.git /usr/local/elixir/

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod cgi rewrite


COPY update.sh /update.sh
COPY project-name.py /project-name.py

# ENV LXR_REPO_DIR /srv/elixir-data/$PROJECT/repo
# ENV LXR_DATA_DIR /srv/elixir-data/$PROJECT/data

# RUN \
#   cd /usr/local/elixir/ && \
#   ./script.sh list-tags && \
#   python3 -u ./update.py

# apache elixir config, see elixir README
# make apache less stricter about cgitb spam headers

EXPOSE 80

VOLUME [ "/data" ]
ENTRYPOINT ["/update.sh"]