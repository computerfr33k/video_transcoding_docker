FROM computerfr33k/video-transcoding:latest
LABEL maintainer="Eric Pfeiffer <computerfreak@computerfr33k.com>"

ENV NODE_VERSION=10.x
ENV BATCH_TRANSCODE_VIDEO_VERSION=1.2.0

# install build dependencies to compile ffmpeg from master
RUN set -ex \
    && apt-get update -yq \
    && apt-get install -yq curl gnupg build-essential \
    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash - \
    && apt-get install -y nodejs

RUN set -ex \
    # Install application dependencies
    && npm install batch-transcode-video@$BATCH_TRANSCODE_VIDEO_VERSION -g \
    && apt-get purge -y --auto-remove build-essential \
    && rm -rf /var/lib/apt/lists/* \
