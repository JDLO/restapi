# Spring Boot 3 REST API: CRUD example

For more detail, please visit:
> [Spring Boot 3 REST API example: CRUD App](https://www.bezkoder.com/spring-boot-3-rest-api/)

In this tutorial, we're gonna build a Spring Boot 3 Rest API example with Maven that implement CRUD operations. You'll know:
- Way to define Spring Rest Controller
- Way to handle HTTP GET, POST, PUT, DELETE requests for CRUD Operations
- How to define Data Model and Service Component

## Run Spring Boot application
```
mvn spring-boot:run
```

# restapi

## Tests to run

Add a Tutorial

``` curl
curl --location 'localhost:8080/api/tutorials' \
--header 'Content-Type: application/json' \
--data '{
    "title":"Esta es mi primer tutorial",
    "description":"Descripcion para mi primer tutorial",
    "published": false
}'
```
List all Tutorial

```
curl --location 'localhost:8080/api/tutorials' \
--data ''
```