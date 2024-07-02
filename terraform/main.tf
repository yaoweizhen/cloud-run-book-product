# Create service account
resource "google_service_account" "sa-build-cloud-run-book" {
  account_id   = "cloud-run-book"
  display_name = "Cloud Run Book"
}

# service account bindings
resource "google_project_iam_member" "artifiactregistry-admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = google_service_account.sa-build-cloud-run-book.member
}
resource "google_project_iam_member" "storage-user" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = google_service_account.sa-build-cloud-run-book.member
}
# resource "google_artifact_registry_repository_iam_member" "sa-cloud-run-book-member" {
#   project    = google_artifact_registry_repository.my-cloud-run-book.project
#   location   = google_artifact_registry_repository.my-cloud-run-book.location
#   repository = google_artifact_registry_repository.my-cloud-run-book.name
#   role       = "roles/artifactregistry.admin"
#   member     = google_service_account.sa-cloud-run-book.member
# }

# Create artifact repository
resource "google_artifact_registry_repository" "my-cloud-run-book" {
  location      = var.region
  repository_id = "my-cloud-run-book"
  description   = "Build my own container image from cloud run book code for practice"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}
resource "google_storage_bucket" "tf-state" {
  name     = "${var.project_id}-tf-state"
  location = var.region
}
# create storge for store terraform plan intermedia file 
resource "google_storage_bucket" "tf-plan" {
  #provider = google-beta
  name     = "${var.project_id}-tf-plan"
  location = var.region
  #force_destroy = true

  # lifecycle_rule {
  #   action {
  #     type = "Delete"
  #   }
  #   condition {
  #     days_since_noncurrent_time = 3
  #     no_age                     = true
  #   }
  # }
}
