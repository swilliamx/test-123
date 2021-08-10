Project Humpback - Tableau Server in a container

Contains the dockerfile and instructions to produce a docker image containing installed and set up tableau server packages, dependencies, and users and groups. The image will have TS in a pre-initialized state, but ready to be initialized and run.

This project requires docker  (and optionally docker-compose) to be installed on the machine

Building the Tableau Server Base Image:

Using an rpm on the machine:
./build-image -i <path-to-installer>

Example: ./build-image -i ../build/linux/installers/tableau-server.rpm

**Running the image:**

