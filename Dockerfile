FROM jboss/wildfly:8.2.1.Final

# Enable the agent by setting environment variables
ENV OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net:4318 \
# OTEL_EXPORTER_OTLP_HEADERS=api-key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNRAL \
OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf \
OTEL_RESOURCE_ATTRIBUTES=service.name=java-spring.otel,service.instance.id=docker \
OTEL_METRICS_EXPORTER=otlp \
OTEL_METRIC_EXPORT_INTERVAL=1000 \
# NEW_RELIC_LICENSE_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNRAL \
NEW_RELIC_APP_NAME=java-spring.docker

# Copy repository to base image and publish your application
WORKDIR /app
COPY --chown=jboss:jboss . .
RUN ./gradlew build

EXPOSE 8080

# ENTRYPOINT ["java", "-jar", "build/libs/java-spring-0.0.1-SNAPSHOT.jar"]
ENTRYPOINT ["java", "-javaagent:newrelic/newrelic.jar", "-jar", "build/libs/java-spring-0.0.1-SNAPSHOT.jar"]