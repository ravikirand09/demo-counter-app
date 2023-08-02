FROM maven as BUILD 
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
COPY --from=BUILD  /app/target/Uber.jar .
EXPOSE 9099
ENTRYPOINT ['java', '-jar', 'Uber.jar']