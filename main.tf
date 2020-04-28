# Create Google Cloud VMs

# Create web server template
resource "google_compute_instance_template" "frontend_server" {
  name                 = "${var.app_name}-web-server-template"
  description          = "This template is used to create web server instances running Apache"
  instance_description = "Web Server running ...."
  can_ip_forward       = false
  machine_type         = "f1-micro"
  tags                 = ["ssh", "http"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "golden-nodejs"
    auto_delete  = true
    boot         = true
  }

  metadata_startup_script = "cd /home/peekaboo/apps && nohup node index.js > nohup.out 2>&1"

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }

  lifecycle {
    create_before_destroy = true
  }

}
