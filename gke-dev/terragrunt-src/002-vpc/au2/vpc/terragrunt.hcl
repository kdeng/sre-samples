# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${path_relative_from_include()}/.././/terraform-modules/vpc"
}

dependency "vpc" {
  config_path = "../../au1/vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]

  mock_outputs = {
    vpc_id              = "fake-vpc-id"
    public_subnet       = "10.0.128.0/17"
    private_subnet      = "10.0.0.0/17"
    project_cidr        = "10.0.0.0/16"
    public_subnet_id    = "fake-public-subnet-id"
    private_subnet_id   = "fake-private-subnet-id"
    vpc_zones           = ["fake-vpc-zone1"]
    public_seconday_subnet    = "192.168.0.0/24"
    private_seconday_subnet   = "192.168.1.0/24"
    public_seconday_subnet_name   = "fake-public-subnet-name"
    private_seconday_subnet_name  = "fake-private-subnet-name"
    public_firewall_tag   = "public-server"
    private_firewall_tag  = "private-server"
  }
}

inputs = {
  project_cidr                = "10.1.0.0/16"
  vpc_secondary_ip_cidr_range = "172.17.0.0/16"
  enable_secondary_ip_alias   = true
  peering_network_cidrs       = [dependency.vpc.outputs.project_cidr]
}
