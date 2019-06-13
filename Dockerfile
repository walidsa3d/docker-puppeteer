# A minimal Docker image with Node and Puppeteer
#
# Based upon:
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

FROM node:10.16.0-slim@sha256:9afe43a8f8944377272e5f000695cc350db8e723639a4a44cf6e5c96c8a0ac9f
    
RUN  apt-get update \
     # Install latest chrome dev package, which installs the necessary libs to
     # make the bundled version of Chromium that Puppeteer installs work.
     && apt-get install -y wget --no-install-recommends \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-unstable --no-install-recommends \
     && rm -rf /var/lib/apt/lists/* \
     && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
     && chmod +x /usr/sbin/wait-for-it.sh \
     && wget https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb \
     && dpkg -i dumb-init_*.deb && rm -f dumb-init_*.deb \
     && apt-get install -y nano
     && apt-get install -y git
     && apt-get install -y supervisor 

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json package-lock.json /
ENTRYPOINT ["dumb-init", "--"]
RUN npm install
