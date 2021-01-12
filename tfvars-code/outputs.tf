output "container-name" {
  value       = docker_container.nodered_contianer[*].name
  description = "The name of the nodered container."
}

output "IP-Address" {
  value       = [for i in docker_container.nodered_contianer[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The private IP address and external port of the nodered containers."
}