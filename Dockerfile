FROM hashicorp/terraform:latest

RUN apk add --no-cache curl

# add kube configs and crts
COPY . /terra-fied

# terraform state directory
# RUN mkdir /terra-fied/.state
# VOLUME .state

WORKDIR /terra-fied