FROM python:3-alpine

# Instalación de dependencias necesarias
RUN apk update && apk add tk && apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra

WORKDIR /app

ENV DISPLAY=:0

COPY *.py /app

CMD ["python", "/app/calculadoraGrafica.py"]