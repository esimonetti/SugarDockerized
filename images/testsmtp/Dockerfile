FROM debian:10.3
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update \
    && apt-get install -y \
    python3 \
    --no-install-recommends

RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 25
ENV PYTHONUNBUFFERED 1
COPY smtp.py smtp.py
CMD ["python3", "smtp.py"]
