FROM python:3.8-alpine

LABEL "com.github.actions.name"="S3 Sync"
LABEL "com.github.actions.description"="This uploads the html/css website files to the S3 bucket"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL repository="https://github.com/marcbacchi/cloud-resume-challenge"
LABEL homepage="https://marcbacchi.dev"

ENV AWSCLI_VERSION='1.22.63'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
