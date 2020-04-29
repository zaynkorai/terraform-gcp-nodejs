# used to forward traffic to the correct load balancer for HTTP load balancing 
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "${var.app_name}-global-forwarding-rule"
  project    = var.project_name
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "${var.app_name}-proxy"
  project = var.project_name
  url_map = google_compute_url_map.url_map.self_link
}

# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.app_name}-backend-service"
  project               = "${var.project_name}"
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = "${google_compute_instance_group_manager.frontend_private_group.instance_group}"
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

# creates a group of virtual machine instances
resource "google_compute_instance_group_manager" "frontend_private_group" {
  name               = "${var.app_name}-vm-group"
  project            = "${var.project_name}"
  base_instance_name = "${var.app_name}-web"
  zone               = var.gcp_zone
  version {
    instance_template = "${google_compute_instance_template.frontend_server.self_link}"
  }
  named_port {
    name = "http"
    port = 80
  }
}

# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name               = "${var.app_name}-healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name            = "${var.app_name}-load-balancer"
  project         = var.project_name
  default_service = google_compute_backend_service.backend_service.self_link
}

# automatically scale virtual machine instances in managed instance groups according to an autoscaling policy
resource "google_compute_autoscaler" "autoscaler" {
  name    = "${var.app_name}-autoscaler"
  project = var.project_name
  zone    = var.gcp_zone
  target  = "${google_compute_instance_group_manager.frontend_private_group.self_link}"

  autoscaling_policy {
    max_replicas    = var.lb_max_replicas
    min_replicas    = var.lb_min_replicas
    cooldown_period = var.lb_cooldown_period

    cpu_utilization {
      target = 0.8
    }
  }
}

# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}