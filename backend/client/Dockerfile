FROM openjdk:17-alpine // 사용할 버전
RUN apk add --no-cache tzdata // 한국 시간 설정
ARG JAR_FILE=/build/libs/client-0.0.1-SNAPSHOT.jar // build된 jar 파일로 이동
COPY ${JAR_FILE} app.jar //jar 파일을 app.jar 파일로 복사
ENTRYPOINT ["java","-jar","/app.jar"] // java -jar app.jar로 실행