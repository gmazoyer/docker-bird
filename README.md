# BIRD Docker Image

Yet another [BIRD](https://bird.network.cz/) Docker image.

This image is built on the latest Debian stable (slim version). It is built in
two stages. The first stage runs a classic Debian stable image to compile BIRD
while the second stage will copy only the relevant files.

It can be run quite simply with:

```
docker run -it --rm -v $(pwd)/bird.conf:/etc/bird/bird.conf bird:2.0.8
```

This command will use a `bird.conf` file located in the current directory as
BIRD configuration file. On exit, the container will be removed (`--rm`).
