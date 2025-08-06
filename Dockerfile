FROM python:3.13-slim

LABEL "com.github.actions.name"="S3 Sync"
LABEL "com.github.actions.description"="Uploads website files to an S3 bucket"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"
LABEL repository="https://github.com/marcbacchi/cloud-resume-challenge"
LABEL homepage="https://marcbacchi.dev"

# Install curl, unzip, and AWS CLI v2
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    apt-get clean

# Add your entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
