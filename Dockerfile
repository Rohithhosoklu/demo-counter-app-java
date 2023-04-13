FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install 

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
EXPOSE 9010
ENTRYPOINT [ "java","-jar","Uber.jar","server.port=9010"]
