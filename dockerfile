FROM python:3-alpine

RUN apk update && apk add tk

WORKDIR /app

ENV DISPLAY=:0

COPY *.py /app

CMD ["python", "/app/calculadoraGrafica.py"]