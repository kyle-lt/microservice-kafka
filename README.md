# Microservice-Kafka

## Overview
This repo contains a Spring Boot Java microservices application that uses Kafka
(and Zookeeper) as the messaging framework between tiers, and a PostgreSQL backend.

Each Java runtime is instrumented with the AppDynamics Java Agent.

It's not necessary to build this project.  All images can be pulled from Docker Hub when you run with [Docker Compose](#quick-start-with-docker-compose).

Once up and running, assuming you are running on your local machine, access the Home Page at `http://localhost:8080`.

## Quick Start with Docker Compose
### Prerequisites
In order to run this project, you'll need:
- Docker
- Docker Compose  
  <br />  
  
   > __Note:__  The Docker versions must support Docker Compose File version 3.0+

### Steps to Run
1. Clone this repository to your local machine, and change into the root directory (`microservice-kafka`)
2. Change into the `docker` directory, and copy the `.env_public` file to a file named `.env`, and configure appropriately.

   > __IMPORTANT:__ Detailed information regarding `.env` file can be found [below](#env-file).  This __MUST__ be done for this project to work!
3. Use Docker Compose to start
```bash
$ docker-compose up -d
```
4. Access front-end UI on `http://$DOCKER_HOSTNAME:8080`.

   > __Note:__  Default configuration assumes localhost/127.0.0.1, so navigate to `http://127.0.0.1:8080`.

## Build
> __Note:__ the build process requires internet access.
### Prerequisites
If you'd like to build the project locally, you'll need:
- Java 1.8+
- Maven 3.x (or you can use the provided `mvnw` binary)
- Docker
- Docker Compose

### Steps to Build
1. Clone this repository to your local machine, and change into the root directory (`microservice-kafka`).
2. Change into the *second* `microservice-kafka` directory, e.g., `~/Projects/microservice-kafka/microservice-kafka`
3. Using the provided `mvnw` binary, build the project (and skip the tests :) )
```bash
$ ./mvnw clean package -DskipTests
```
4. Change into the `docker` directory (which is located in the root project directory), and copy the `.env_public` file to a file named `.env`, and configure appropriately.

   > __IMPORTANT:__ Detailed information regarding `.env` file can be found [below](###-.env-File).  This __MUST__ be done for this project to work!
4. Uncomment the build directives for the `apache`, `postgres`, `order`, `shipping`, and `invoicing` services in `docker-compose.yml`.
5. Build the containers
```bash
$ docker-compose build 
```
5. Use Docker Compose to start
```bash
$ docker-compose up -d
```

## Docker Compose Services
### zookeeper
Zookeeper Image, altered by adding the AppD Java Agent.  

### kafka
Kafka Image, altered by adding the AppD Java Agent.  

### apache
Apache Web Server Image.  

By default, accessible on `http://$DOCKER_HOSTNAME:8080`.

### postgres
PostgreSQL Image, used for microservices backend.

### order
Spring Boot microservice, also the Kafka Producer.

### shipping
Spring Boot microservice, also a Kafka Consumer.

### invoicing
Spring Boot microservice, also a Kafka Consumer.


### Application Code
The app code is housed in the *second* `microservice-kafka` directory, and then each microservice has its own subdirectory.  Each directory contains source code and a `Dockerfile`.  There is also a script called `downloadAgent.sh` which is a helper to download and place the AppD Java agent bits in each container.

### docker-compose.yml
This file is located in the project root and manages building and running the Docker containers. It uses the `.env` file to populate environment variables for the project to work properly.

### .env File
This file contains all of the environment variables that need to be populated in order for the project to run, and for the performance tools to operate.  Items that *must* be tailored to your environment are:

#### AppDynamics Controller Configuration
```bash
# AppD Java Agent
APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=<Access_Key>
APPDYNAMICS_AGENT_ACCOUNT_NAME=<Account_Name>
APPDYNAMICS_CONTROLLER_HOST_NAME=<Controller_Host>
APPDYNAMICS_CONTROLLER_PORT=<Controller_Port>
APPDYNAMICS_CONTROLLER_SSL_ENABLED=<true_or_false>
```
> __Tip:__  Documentation on these configuration properties can be found in the [AppDynamics Java Agent Configuration Documentation](https://docs.appdynamics.com/display/PRO45/Java+Agent+Configuration+Properties)

**If applicable, the rest of the environment variables in the `.env` file can be left with default values.**

## Development/Testing
This repo contains some artifacts to ease re-builds for testing.
- `createOrders.sh`
   - This script creates 4 orders, and a decent way to drive some basic load is to use `watch`
   ```bash
   $ watch -n 30 ./createOrder.sh
   ```


### Reference

I used [this repo](https://github.com/ewolff/microservice-kafka) as a starting point.

The original Repo's README below.

Microservice Kafka Sample
==================

[Deutsche Anleitung zum Starten des Beispiels](WIE-LAUFEN.md)

This is a sample to show how Kafka can be used for the communication
between microservices.

The project creates Docker containers.

It uses three microservices:
- Order to create orders. This services sends messages to Kafka. It
  uses the `KafkaTemplate`.
- Shipment receives the orders and extract the
  information needed to ship the items.
- Invoicing receives the messages, too. It extracts all information to send
out an invoice. It uses `@KafkaListener` just like Shipment.

This is done using a topic order. It has five partitions. Shipment and
invoicing each have a separate consumer group. So multiple instances
of shipment and invoicing can be run. Each instance would get specific
events.

Technologies
------------

- Spring Boot
- Spring Kafka
- Apache httpd
- Kafka
- Zookeeper
- Postgres
- Docker Compose to link the containers.

How To Run
----------

See [How to run](HOW-TO-RUN.md) for details.

Once you create an order in the order application, after a while the
invoice and the shipment should be shown in the other applications.

Remarks on the Code
-------------------

The microservices are: 
- [microservice-kafka-order](microservice-kafka/microservice-kafka-order) to create the orders
- [microserivce-kafka-shipping](microservice-kafka/microservice-kafka-shipping) for the shipping
- [microservice-kafka-invoicing](microservice-kafka/microservice-kafka-invoicing) for the invoices

The data of an order is copied - including the data of the customer
and the items. So if a customer or item changes in the order system
this does not influence existing shipments and invoices. It would be
odd if a change to a price would also change existing invoices. Also
only the information needed for the shipment and the invoice are
copied over to the other systems.

The Order microservice uses Spring's `KafkaTemplate` to send message
while the other two microservices use the annotation `@KafkaListener`
on the methods that should be called if a new record comes in. All
records are put in the `order` topic. It has five partitions to allow
for scalability.

For tests an embedded Kafka server is used. A `@ClassRule` starts
it. And a method annotated with `@BeforeClass` configures Spring Kafka
to use the embedded Kafka server.

The orders are serialized as JSON.
So the `Order` object of the order microservice is serialized as a JSON data structure.
The other two microservices just
read the data they need for shipping and invoicing. So the invoicing microservices reads the `Invoice`object and the 
delivery microservice the `Delivery`object.
This avoids code dependencies between the
microservices. `Order` contains all the data for `Invoice` as well as `Delivery`.
JSON serialization is flexible. So when an `Order` is deserialized into `Invoice` and `Delivery` just the needed data is read.
The additional data is just ignored.

There are three Docker container for the microservices. The other
Docker containers are for Apache httpd, Kafka, Zookeeper and Postgres.

Incoming http request are handled by the Apache httpd server. It is
available at port 8080 of the Docker host
e.g. <http://localhost:8080>.  HTTP requests are forwarded to the
microservices. Kafka is used for the communication between the
microservices. Kafka needs Zookeeper to coordinate instances. Postgres
is used by all microservices to store data. Each microservices uses
its own database in the Postgres instance so they are decoupled in
that regard.

You can scale the listener with e.g. `docker-compose scale
shipping=2`. The logs (`docker logs
mskafka_shipping_1`) will show which partitions the instances listen
to and which records they handle.

You can also start a shell on the Kafka server `docker exec -it
mskafka_kafka_1 /bin/sh` and then take a look at the records in the
topic using `kafka-console-consumer.sh --bootstrap-server kafka:9092
--topic order --from-beginning`.
