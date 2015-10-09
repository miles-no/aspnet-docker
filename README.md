# Deploying DNX/ASPNET5 on Docker without Mono

*NOTE*: Tested on:

* OSX 10.11.0 (El Capitan) 
* DNVM 1.0.0-rc1-15524 
* DNU 1.0.0-rc1-15838 (Darwin x64)
* DNX 1.0.0-rc1-15838 (Darwin x64) 
* DNX 1.0.0-rc1-15838 (Linux x64)
* Docker version 1.8.2, build 0a8c2e3
* docker-machine version 0.4.1 (HEAD)

This is a small WebApi project to test "natively" running an ASP.NET application without requiring Mono. Instead, we are deploying the `coreclr` runtime for Linux as part of the packaging process. 

**Advantages**:

* Smaller images:

  ```
  REPOSITORY                         CREATED             VIRTUAL SIZE 
  jstclair/docker-hellomvc-no-mono   4 minutes ago       334.2 MB 
  debian/jessie-backports            11 weeks ago        125.2 MB
  # note: with Mono 
  jstclair/docker-hellomvc           23 hours ago        741 MB
  microsoft/aspnet                   12 weeks ago        729.1 MB 
  ```
  
* Less installed on our final image (fewer security issues)


1. [Install ASPNET 5](https://github.com/aspnet/home)
2. Update and install latest stable versions of DNVM and runtimes
  ```
  dnvm upgrade-self
  dnvm install latest -u -r coreclr -OS linux -a coreclr-linux-latest
  dnvm upgrade -u -r coreclr -p
  ```
  
  Running `dnvm list` should show something like the following:
  
  ```
  Active Version              Runtime Arch Location             Alias
  ------ -------              ------- ---- --------             -----
    *    1.0.0-rc1-15838      coreclr x64  ~/.dnx/runtimes      default
         1.0.0-rc1-15838      coreclr x64  ~/.dnx/runtimes      coreclr-linux-latest
  ```
2. Publish the project and build a docker image for it:
  ```
  make
  ```
  
  The key here is that when we publish our application, we use the `--no-source` and  `--runtime dnx-coreclr-linux-x64.1.0.0-rc1-15838` flags.
  
3. Run the docker image:
  ```
  make run
  ```
  
  See the `Makefile` for more options, like `make debug` or `make run-d`
4. Hit the Values endpoint
  ```
  IP=$(docker-machine ip MACHINE_NAME)
  curl -L http://${IP}:5004/api/values
  ```
5. Cleanup
  ```
  make clean
  ```
# CREDITS

* Makefile originally inspired by [Ben Hall](http://blog.benhall.me.uk/2015/05/using-make-to-manage-docker-image-creation/)