FROM python:3.13-alpine

LABEL "com.github.actions.name"="S3 Sync"
LABEL "com.github.actions.description"="This uploads the html/css website files to the S3 bucket"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL repository="https://github.com/marcbacchi/cloud-resume-challenge"
LABEL homepage="https://marcbacchi.dev"

ENV AWSCLI_VERSION='1.22.63'

# RUN python -m pip install --upgrade pip
# RUN pip install --quiet --no-cache-dir

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
