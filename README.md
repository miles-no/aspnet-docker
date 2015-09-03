# ASPNET Docker example

NOTE: Tested on OSX with DNVM 1.0.0-beta8-15502 / DNX 1.0.0-beta7.coreclr.x64.darwin / 1.0.0-beta7.coreclr.x64.linux

This is a small WebApi project to test "natively" running an ASP.NET application without requiring Mono. Instead, we are deploying the `coreclr` runtime for Linux as part of the packaging process.

Advantages:

* Smaller images:

```
REPOSITORY                         TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
jstclair/docker-hellomvc-no-mono   latest              f7bd951cea84        4 minutes ago       398.4 MB
jstclair/docker-hellomvc           latest              716e57ec001f        23 hours ago        741 MB
```

* Less installed on our final image; fewer security issues


1. [Install ASPNET 5](https://github.com/aspnet/home)

2. Update and install latest stable versions of DNVM and runtimes

```
dnvm upgrade-self
dnvm install latest -r coreclr -OS linux -a coreclr-linux-latest
dnvm upgrade -r coreclr -p
```

Running `dnvm list` should show something like the following:

\\ insert image here


2. Publish the project and build a docker image for it:

```
make
```

The key here is that when we publish our application, we use the `--no-source` and  `--runtime dnx-coreclr-linux-x64.1.0.0-beta7` flags.

3. Run the docker image:

```
make run
```

See the `Makefile` for more options, like `make debug` or `make run-d`

4. Hit the Values endpoint

```
IP=$(docker-machine ip MACHINE_NAME)
open http://${IP}:5004/api/values
```

5. Cleanup

```
make clean
```