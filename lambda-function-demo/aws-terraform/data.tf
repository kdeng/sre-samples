# Fetch all available zones of a given region
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name = "region-name"
    values = [var.project_region]
  }
}
