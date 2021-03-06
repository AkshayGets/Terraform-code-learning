terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.9.0"
    }
  }
}

provider "docker" {
  # Configuration options
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red-docker:v8"
}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_contianer" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}


output "IP-Address1" {
  value       = join(":", [docker_container.nodered_contianer[0].ip_address, docker_container.nodered_contianer[0].ports[0].external])
  description = "The private IP address and external port of the nodered container."
}

output "container-name1" {
  value       = docker_container.nodered_contianer[0].name
  description = "The name of the nodered container."
}

output "IP-Address2" {
  value       = join(":", [docker_container.nodered_contianer[1].ip_address, docker_container.nodered_contianer[0].ports[0].external])
  description = "The private IP address and external port of the second nodered container."
}

output "container-name2" {
  value       = docker_container.nodered_contianer[1].name
  description = "The name of the second nodered container."
}