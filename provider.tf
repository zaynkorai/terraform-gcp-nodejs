provider "google" {
  project     = var.project_name
  credentials = file(var.gcp_credentials)
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "google-beta" {
  project     = var.project_name
  credentials = file(var.gcp_credentials)
  region      = var.gcp_region
  zone        = var.gcp_zone
}
