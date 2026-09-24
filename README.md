# 15-441/641 Project 2: TCP in the Wild

Welcome to Project 2! Please read the handout and starter code thoroughly before you begin. This README contains a quick summary to get your testing environment set up.

## Setting up the development environment

You can use Vagrant and Docker to automatically setup the development environment. This should work both on Linux as well as on macOS (including Apple Silicon macs). However, you should not use Docker for the experimental component of CP2. Those experiments should be run on AWS using separate instances for sending and receiving.

Start by downloading and installing [Vagrant](https://www.vagrantup.com/downloads) and [Docker](https://docs.docker.com/desktop/). For macOS, you may use homebrew to install Vagrant but **do not** use homebrew to install Docker. Instead, download Docker Desktop from the link above.

Once you have both Vagrant and Docker Desktop installed, navigate inside this repo and run:

```bash
vagrant up --provider=docker  # builds the server and client containers using Docker.
vagrant ssh {client | server}   # connects to either the client or server using SSH.
```

Vagrant keeps all files synchronized between your host machine and the two containers. In other words, the code will update automatically on the containers as you edit it on your computer. Similarly, debugging files and other files generated on the containers will automatically appear on your host machine.

## Files
The following files have been provided for you:

* `backend.c`: This file contains the backend code that will run in a separate thread from the application. This is where most of your logic should go. The backend should deal with most of the TCP functionality, including the state machine, timeouts, retransmissions, buffering, congestion control, etc.

* `cmu_tcp.c`: This contains the main socket functions required of your TCP socket including reading, writing, opening and closing. Since TCP needs to works asynchronously with the application, these functions are relatively simple and interact with the backend running in a separate thread.

* `Vagrantfile`: Defines the structure, IP addresses, and dependencies in the containers. Feel free to modify this file to add any additional testing tools as you see fit. Remember to document your changes in `tests.txt`!

* `tests.txt`: A brief writeup describing your testing strategy, and any tools you used in the process of testing.

* `capture_packets.sh`: Captures packets from the server and client containers and saves them to a PCAP file.

* `tcp.lua`: A Lua plugin that allows Wireshark to decode CMU-TCP headers. Copy the file to the directory described in <https://www.wireshark.org/docs/wsug_html_chunked/ChPluginFolders.html> to use the plugin.

* `test_cp1.py`: Test script for CP1 that is executed with `make test`. You should add your own tests to this file.

* `grading.h`: These are variables that we will use to test your implementation. We will be replacing this file when running tests, and hence you should test your implementation with different values.

* `server.c`: An application using the server side of your transport protocol. We will test your code using a different server program, so do not keep any variables or functions here that your protocol uses.

* `client.c`: An application using the client side of your transport protocol. We will test your code using a different client application, so do not keep any variables or functions here that your protocol uses.

* `cmu_packet.h`: This file describes the basic packet format and header and provides helper functions that will help you handle packets. You are not allowed to modify this file! The packet-analysis tools rely on this file being unchanged. All the communication between your server and client will use UDP as the underlying protocol. All packets will begin with the common header described as follows:

    * Course Number 		    [4 bytes]
    * Source Port 			    [2 bytes]
    * Destination Port 		    [2 bytes]
    * Sequence Number 		    [4 bytes]
    * Acknowledgement Number 	[4 bytes]
    * Header Length		        [2 bytes]
    * Packet Length			    [2 bytes]
    * Flags				        [1 byte]
    * Advertised Window		    [2 bytes]
    * Extension length		    [2 bytes]
    * Extension Data		    [You may use it when designing your own congestion control algorithm in the lab]

## Manual test
You can manually test your code by running the server and client applications in the containers while also capturing packets using `capture_packets.sh`. You can then use the same script or [Wireshark](https://www.wireshark.org/#download) to view the packets.

Open two terminals. One will be used to access the server container and the other will be used to access the client container.

On the **server** terminal:
```bash
# Access the server container and navigate to the project directory.
vagrant ssh server
cd /vagrant/project-2_15-441/

# Compile.
make

# Start packet capture.
./utils/capture_packets.sh start cap.pcap

# Start the server.
./server
```

On the **client** terminal:
```bash
# Access the client container and navigate to the project directory.
vagrant ssh client
cd /vagrant/project-2_15-441/

# Note that you don't need to recompile the code here as we already did it on the server and the code is synchronized between the two containers.

# Start the client.
./client
```

Once the server is done. Stop the packet capture and analyze the packets. In the **server** terminal:
```bash
# Stop the packet capture.
./utils/capture_packets.sh stop cap.pcap

# Analyze the packets.
./utils/capture_packets.sh analyze cap.pcap
```

You can also access the capture file (`cap.pcap` in this example) from your host machine and open it with Wireshark. You should use the `utils/tcp.lua` plugin to decode CMU-TCP headers. To do so, copy the file to the directory described in <https://www.wireshark.org/docs/wsug_html_chunked/ChPluginFolders.html>.

For CP2, instrument your sender to log timestamps, congestion-window size (`cwnd`),
slow-start threshold (`ssthresh`), and congestion-control stage whenever they change.
Plot `cwnd` over time from these logs and label slow start, congestion avoidance,
fast recovery, triple-duplicate-ACK events, and timeouts.

## Automatic tests

You should also run automatic tests. On either the client or server container, navigate to `/vagrant/project-2_15-441/` and run:
```bash
make test
```

Note that the test files are _incomplete_! You are expected to build upon them and write more extensive tests (doing so will help you write better code and save you grief during debugging)!

## Submission

To submit your code to Gradescope, make sure that all the files that should be included are committed and then run:
```bash
./utils/prepare_submission.sh
```

This will generate a file called `handin.tar.gz` at the repository's root directory. Upload this file to Gradescope.

## [Optional] Automatic code formatting and analysis
We provided a [pre-commit](https://pre-commit.com/) configuration file that you can use to automatically format and statically check your code whenever you commit. Either use the pre-commit already installed in one of the containers or install it in your local machine:
```bash
pip3 install pre-commit
```

And then run the following command in the root directory of this repo to install the pre-commit hook:
```bash
pre-commit install
```

Now, pre-commit will automatically run whenever you commit. If you want to run it manually, you can run:
```bash
make format
```
