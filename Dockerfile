FROM registry.jetbrains.team/p/writerside/builder/writerside-builder:241.16003 as build

ARG INSTANCE=docs/otrd

RUN mkdir /opt/sources

WORKDIR /opt/sources

ADD docs docs

RUN export DISPLAY=:99 && \
Xvfb :99 & \
/opt/builder/bin/idea.sh helpbuilderinspect -source-dir /opt/sources --product $INSTANCE --runner other --output-dir /opt/wrs-output/

WORKDIR /opt/wrs-output

RUN unzip webHelpOTRD2-all.zip -d /opt/wrs-output/unzipped-artifact

FROM httpd:2.4 as http-server

COPY --from=build /opt/wrs-output/unzipped-artifact/ /usr/local/apache2/htdocs/
