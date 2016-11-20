docker-rpi-unifi-5
==================

Docker Image for running Ubiquiti's UniFi Controller (5.x branch) in a Raspberry Pi (2/3) (https://hub.docker.com/reverie/rpi-unifi-5)

Tested with HypriotOS's docker distribution on a Raspberry Pi 3, and an UAP-AC-Lite. 

No warranties whatsoever. Have fun with it, but don't blame if it anything happens, like your house burns down or something.

Running in Docker service mode
------------------------------

I prefer running the service inside a (single-node) docker swarm, since it takes care of service startup and shutdown when needed. Starting and stopping is done by setting the number of desired replicas to 1 or 0, respectively. I REALLY discourage (and didn't test) setting it to anything over 2. Also discouraged is running it in a multi-node swarm, unless you know how to handle volume persistence between nodes.

This mode is useful since the Controller's startup will be handled at the Pi's startup, as soon as the swarm boots. This avoids having to write custom init scripts or systemd units.


0. If you don't have a swarm created, create it:

  ```
  docker swarm create
  ```

1. Create the `unifi` docker service on the swarm:

  ```
  ./create-docker-service.sh
  ```

2. Follow the usual steps to setup your UniFi Controller. 
You mostly want to connect to https://<your.pi.ip.address>:8443/ . Don't forget it's supposed to be https, not http. Keep in mind that running this setup in this mode will NOT allow L2 adoption of UAPs (that is, finding an AP via network broadcasts). You either have to run it in host networking mode (only when running the adoption steps, see below) or setup L3 adoption (by setting DHCP option 43, for example).

3. Stop the docker service if needed:

  ```
  docker service scale unifi=0
  ```

4. Start it again when desired:

  ```
  docker service scale unifi=1
  ```

Keep in mind that the software takes about 2 minutes to startup.

Again, I REALLY REALLY don't recomment you set it to anything higher than 1! This will make it so two containers are writing to the same volumes at the same time!!


Running in Adoption mode (Host networking mode)
-----------------------------------------------

I call it "Adoption Mode" because this is the easiest mode to get a new AP adopted on your network. Host networking mode is used to allow L2 adoption of the UAPs. There is no problem in always running the software in this mode if you wish to, but you'll have to account for starting it on boot and stopping it on shutdown by yourself.

To run it in this mode, follow this steps:

1. If your Docker service is running, stop it:

  ```
  docker service scale unifi=0
  ```

2. Bring up the container in host networking mode, using the provided "docker-compose.yml" file. This will make use of the exact same data volumes.

  ```
  docker-compose up -d unifi
  ```

3. Connect to your controller as normal. It should work to the very same ports. Run your adoption procedure via L2, as if the software was installed in the Raspberry Pi itself.

4. Bring the container down

  ```
  docker-compose down unifi
  ```

5. Start the persistent swarm service once again, if you have it set up.

  ```
  docker service scale unifi=1
  ```
