ARG DOCKER_PLATFORM

FROM --platform=${DOCKER_PLATFORM} node:23

# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker

RUN apt-get update \
        && apt-get install -y wget gnupg \
        && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
        && apt-get update \
        && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
        --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/opt/google/chrome-unstable/chrome

RUN mkdir /var/app && chown -R root /var/app/ \
    && npm install -g critical

WORKDIR /var/app/

ENTRYPOINT ["critical"]
