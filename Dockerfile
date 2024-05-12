FROM openjdk:8u151-jdk-alpine3.7

EXPOSE 8070

ENV APP_HOME /usr/src/app

WORKDIR $APP_HOME

COPY target/shopping-cart-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

ENTRYPOINT ["sh", "-c", "java -jar app.jar"]
