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
  count   = 1
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_contianer" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}

resource "docker_container" "nodered_contianer2" {
  name  = "nodered-ucvp"
  image = docker_image.nodered_image.latest
  }

# output "IP-Address1" {
#   value       = join(":", [docker_container.nodered_contianer[0].ip_address, docker_container.nodered_contianer[0].ports[0].external])
#   description = "The private IP address and external port of the nodered container."
# }

output "container-name" {
  value       = docker_container.nodered_contianer[*].name
  description = "The name of the nodered container."
}

output "IP-Address" {
  value       = [for i in docker_container.nodered_contianer[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The private IP address and external port of the nodered containers."
}
