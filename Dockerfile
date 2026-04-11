FROM amazon/aws-cli

LABEL "com.github.actions.name"="S3 Sync"
LABEL "com.github.actions.description"="Uploads website files to an S3 bucket"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"
LABEL repository="https://github.com/marcbacchi/cloud-resume-challenge"
LABEL homepage="https://marcbacchi.dev"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]