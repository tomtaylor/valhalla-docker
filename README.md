# Dockerfile for Valhalla

This Dockerfile provides an easy way to build and deploy Mapzen's Valhalla,
without configuring a full Chef install.

It defaults to using an OSM extract of London, UK, but you can change this if
you like, in the Dockerfile.

Run `fetch-repos.sh` to pull down each Valhalla component into its own
subdirectory. You can run this again any time to pull master and any
submodules.

To build and run the Docker image:

```sh
docker build -t valhalla .
docker run -it -p 8002:8002 valhalla:latest
```
