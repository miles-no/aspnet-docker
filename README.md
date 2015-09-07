# Deploying DNX/ASPNET5 on Docker without Mono

*NOTE*: Tested on:

* OSX 10.10.5 
* DNVM 1.0.0-beta8-15502 
* DNX 1.0.0-beta7.coreclr.x64.darwin 
* DNX 1.0.0-beta7.coreclr.x64.linux
* Docker version 1.8.1, build d12ea79
* docker-machine version 0.4.1 (HEAD)

This is a small WebApi project to test "natively" running an ASP.NET application without requiring Mono. Instead, we are deploying the `coreclr` runtime for Linux as part of the packaging process. 

**Advantages**:

* Smaller images:

  ```
  REPOSITORY                         CREATED             VIRTUAL SIZE 
  jstclair/docker-hellomvc-no-mono   4 minutes ago       238.4 MB 
  jstclair/docker-hellomvc           23 hours ago        741 MB 
  jstclair/jessie-libuv              9 weeks ago         175.4 MB 
  debian/jessie                      11 weeks ago        125.2 MB 
  microsoft/aspnet                   12 weeks ago        729.1 MB 
  ```
  
* Less installed on our final image (fewer security issues)


1. [Install ASPNET 5](https://github.com/aspnet/home)
2. Update and install latest stable versions of DNVM and runtimes
  ```
  dnvm upgrade-self
  dnvm install latest -r coreclr -OS linux -a coreclr-linux-latest
  dnvm upgrade -r coreclr -p
  ```
  
  Running `dnvm list` should show something like the following:
  
  ```
  Active Version              Runtime Arch Location             Alias
  ------ -------              ------- ---- --------             -----
    *    1.0.0-beta7          coreclr x64  ~/.dnx/runtimes      default
         1.0.0-beta7          coreclr x64  ~/.dnx/runtimes      coreclr-linux-latest
  ```
2. Publish the project and build a docker image for it:
  ```
  make
  ```
  
  The key here is that when we publish our application, we use the `--no-source` and  `--runtime dnx-coreclr-linux-x64.1.0.0-beta7` flags.
  
  > NOTE: This is based on my custom `jstclair/jessie-libuv` image; you can find the Dockerfile (including the reasons for a custom version, rather than building on the Microsoft ASPNET image) 
  on [Dockerhub](https://hub.docker.com/r/jstclair/jessie-libuv/).
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
# CREDITS

* Makefile originally inspired by [Ben Hall](http://blog.benhall.me.uk/2015/05/using-make-to-manage-docker-image-creation/)