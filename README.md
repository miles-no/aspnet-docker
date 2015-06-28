# ASPNET Docker example

NOTE: Tested on OSX / Mono 4.0.1

1. [Install ASPNET 5](https://github.com/aspnet/home)

2. Upgrade to latest beta of DNX (1.0.0-beta6-12120 at time of writing)

```
dnvm upgrade-self
dnvm upgrade -u
dnvm list 
```

2. Publish the project and build a docker image for it

```
make build
```

3. Run the docker image

```
make run
```

_NOTE: I had issues with the container not stopping