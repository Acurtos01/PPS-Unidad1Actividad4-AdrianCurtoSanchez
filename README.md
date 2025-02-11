# Unidad 1 - Actividad 4.RA1. Prueba de aplicaciones en entorno controlado: Sandbox

## Diferentes Sandboxes

Podemos encontrar multitud de herramientas que nos ofrecen crear "sandboxes" en los cuales poder probar software de forma aislada. A continuación encontrás tres de estas herramientas:

- <a href="https://learn.microsoft.com/es-es/windows/security/application-security/application-isolation/windows-sandbox/" target="_blank">Espacio aislado de Windows</a>
- <a href="https://blog.cloudflare.com/sandboxing-in-linux-with-zero-lines-of-code/" target="_blank">Linux seccomp</a>
- <a href="https://medium.com/@alwinraju/how-to-use-docker-to-sandbox-a-python-script-5fba21df481f" target="_blank">Contenedor Docker</a>


## Ejecución de código sobre un sandbox creado con Docker

### Creación del dockerfile

``` dockerfile
FROM python:3-alpine

# Instalación de dependencias necesarias
RUN apk update && apk add tk && apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra

WORKDIR /app

ENV DISPLAY=:0

COPY *.py /app

CMD ["python", "/app/calculadoraGrafica.py"]
```
[Fichero dockerfile](dockerfile)


### Convertir dockefile en una imagen

Una vez tenemos nuestro dockerfile creado deberemos crear la imagen con el siguiente comando `docker build -t my-python-sandbox .` con el parámetro `-t` indicamos a continuación el nombre de la imagen(tag) y con `.` especicamos el contexto de la construcción de la imagen se encuentra en el directorio actual.

![Docker build](images/docker-build.png)


### Ejecución del contenedor
Es posible que necesitemos instalar las siguientes dependencias:
`sudo apt install x11-xserver-utils`

Primero debemos dar permisos a docker para que pueda usar el servicio de entorno gráfico de la máquina anfitrión:
`xhost +local:docker`

Y ejecutamos el contenedor de con el parámetro `--rm` de tal forma que al finalizar la ejecución del programa el contenedor se borra  `docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY my-python-sandbox`

## Monitorear la ejecución de Docker con Prometheus

Podemos encontrar la documentación para implementar Prometheus con una configuración custom en los <a heref="https://docs.docker.com/engine/daemon/prometheus/" target="_blank">manuales de Docker</a>.

Para linux deberemos modificar el fichero /etc/docker/daemon.json y añadir la siguiente línea:
```
{
  "metrics-addr": "127.0.0.1:9323"
}
```

En este caso por simplificar implementaremos el contenedor por defecto ejecutando: `docker run --name prometheus -d -p 127.0.0.1:9090:9090 prom/prometheus
`

![Docker run prometheus](images/docker-run-prometheus.png)

Si nos dirigimos al nevegador e introducimos la url `http://localhost:9090` accederemos a la interfaz de Prometheus.

![Prometheus](images/prometheus.png)

Si pinchamos en los tres puntos del filtro de querys y seleccionamos "Explore metrics" encontramos un listado de metricas listas para usar.

![Prometheus query](images/prometheus-query.png)

Podemos buscar por ejemplo `process_resident_memory_bytes` cuya query nos dará información del uso de memoria en bytes o `process_cpu_seconds_total` para conocer el uso de CPU.

![Prometheus explore metrics](images/prometheus-explore-metrics.png)

Ejecutamos la quey y obtenemos el resultado.

![Prometheus query memory](images/prometheus-query-memory.png)

Y nos da la posibilidad de mostrar el resultado en una gráfica.

![Prometheus graph](images/prometheus-graph.png)


> **Nota**: 
Para tener un entorno de monitoreo más profesional lo suyo sería implementar en este stack <a href="https://grafana.com/" target="_blank">Grafana</a>, una herramienta que nos permitirá mostrar los datos en gráficas de una forma más amigable.

