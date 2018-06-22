# Video Transcoding for Docker

Docker support for [https://github.com/donmelton/video_transcoding](https://github.com/donmelton/video_transcoding) with automatic mounting of a CIFS path

The Docker image is [available on Docker Hub](https://hub.docker.com/r/arikalish/video-transcoding-cifs/).

## Prerequisites

You must be running [Docker for Mac](https://docs.docker.com/engine/installation/mac/), [Docker for Linux](https://docs.docker.com/engine/installation/linux/), or [Docker for Windows](https://docs.docker.com/engine/installation/windows/).

## Usage

To run the video_transcoding gem in Docker, execute the following:

```
docker run --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH -it -e REMOTE_PATH=$REMOTE_CIFS_PATH -e LOCAL_PATH=/$PATH_INSIDE_CONTAINER -e REMOTE_USER=$REMOTE_USERNAME -e REMOTE_PASSWORD=$REMOTE_PASSWORD 
```

This will:

1. Download the `arikalish/video-transcoding-cifs` Docker image (unless already downloaded)
2. Mount $REMOTE_CIFS_PATH inside the container at $LOCAL_PATH, creating the directory if necessary. Stopping if it is not empty.
3. Run an interactive bash shell with access to your current directory and the video_transcoding cli tools

For best results on Docker for Mac or Windows, set your CPU count in preferences to the maximum available for your machine.

To update to the latest version:

```
docker pull arikalish/video-transcoding-cifs:latest
```
