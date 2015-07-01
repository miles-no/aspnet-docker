# ASPNET Docker example

NOTE: Tested on OSX / Mono 4.0.1 (locally installed)

This is a small project to test "natively" running an ASP.NET application without requiring mono. Instead, we are deploying the `coreclr` runtime for Linux as part of the packaging process.

Advantages:

* Smaller images:

```
REPOSITORY                         TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
jstclair/docker-hellomvc-no-mono   latest              f7bd951cea84        4 minutes ago       398.4 MB
jstclair/docker-hellomvc           latest              716e57ec001f        23 hours ago        741 MB
```

* Less installed on our final image; fewer security issues


1. [Install ASPNET 5](https://github.com/aspnet/home)

Right now, we still need to install the full Mono-based .NET stack locally; latest `coreclr` still has issues with `dnu restore`

1.a. Download and install the [dnx-coreclr-linux-x64](https://www.myget.org/gallery/aspnetvnext)  

```
# after downloaded the above to ~/Downloads
dnvm install ~/Downloads/dnx-coreclr-linux-x64.1.0.0-beta6-12120.nupkg --alias dnx-core-linux
# now switch back to our original beta6 for mono
dnvm use 1.0.0-beta6-12120 -r mono -p
```

2. Upgrade to latest beta of DNX (1.0.0-beta6-12120 at time of writing):

```
dnvm upgrade-self
dnvm upgrade -u
dnvm list 
```

2. Publish the project and build a docker image for it:

```
make
```

_NOTE: I have found that you need to run the app at least once to get the wwwroot folder created._

```
dnu restore -s https://www.myget.org/F/aspnetvnext/api/v2 .
dnx . kestrel
make
```

The key here is that when we publish our application, we use the `--no-source` and  `--runtime dnx-coreclr-linux-x64.1.0.0-beta6-12120` flags.

3. Run the docker image:

```
make run
```

See the `Makefile` for more options, like `make debug` or `make run-d`

4. Cleanup

```
make clean
```