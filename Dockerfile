FROM dart:3.1.0 AS build

WORKDIR /app

# Copy the necessary files
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub global activate webdev
RUN dart run build_runner build
RUN dart pub global run webdev build --output=web:build

FROM nginx:latest

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
