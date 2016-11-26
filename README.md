# docker-bigdata [![Build Status](https://travis-ci.org/tataopop/docker-bigdata.svg?branch=master)](https://travis-ci.org/tataopop/docker-bigdata)
docker-bigdata is aimed to create a mini cluster for hadoop ecosystem.



## Components
| Component | Version |
| ------------- | ------------- | ------------- |
| hadoop | 2.7.3 |
| spark | to be added |
| hbase | to be added |
| kafak | to be added |
| hive | 2.1.0 |
| oozie | to be added |

## Build the image
You can build the image yourself. By editing `Dockerfile` and `start.sh`, you can choose which components to be added in your image.
```
docker build -t docker-bigdata .
```

## Pull the image
```
docker pull tataopop/docker-bigdata
```

## Run a container
```
docker run -it docker-bigdata
```

## Dockerhub
https://hub.docker.com/r/tataopop/docker-bigdata/
