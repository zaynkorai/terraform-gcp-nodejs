##########################################################################
# Google Cloud connection & authentication and Application configuration
##########################################################################

# GCP authentication file
variable "gcp_credentials" {
  description = "GCP authentication file"
  default     = "auth/service-account.json"
}

# define GCP project name
variable "project_name" {
  description = "GCP project name"
}

# define application name
variable "app_name" {
  description = "Application name"
}

#####################################
#         network varibles
#####################################
# define GCP region
variable "gcp_region" {
  description = "GCP region"
}

# define GCP zone
variable "gcp_zone" {
  description = "GCP zone"
}

# define private subnet
variable "private_subnet_cidr" {
  description = "private subnet CIDR 1"
}

#####################################
#     Load balancer variables
#####################################

# maximum number of VMs for load balancer autoscale
variable "lb_max_replicas" {
  description = "Maximum number of VMs for autoscale"
  default     = "4"
}

# minimum number of VMs for load balancer autoscale
variable "lb_min_replicas" {
  description = "Minimum number of VMs for autoscale"
  default     = "1"
}

# number of seconds that the autoscaler should wait before it starts collecting information
variable "lb_cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance"
  default     = "60"
}
