FROM dart:stable

WORKDIR /app
COPY . .
RUN dart pub get

EXPOSE 8080
CMD ["dart", "bin/server.dart"]
