variable "project_name" {
  description   = "The name of current infrastructure"
  type          = string
  default       = "kefeng-QA"
}

variable "project_region" {
  description   = "The default region to setup jenkins cluster"
  type          = string
  default       = "ap-southeast-2"
}

variable "project_cidr" {
  description   = "The default region to setup jenkins cluster"
  type          = string
  default       = "10.0.0.0/16"
}

variable "environment" {
  description   = "Environment of this cluster"
  type          = string
  default       = "QA"
}

variable "instance_type" {
  default       = "t2.micro"
}

variable "instance_subnet" {
  default       = ""
}

variable "instance_key_name" {
  default       = "instance_key"
}

variable "instance_disable_api_termination" {
  default       = false
}

variable "instance_monitoring" {
  default       = true
}

variable "instance_root_volume_type" {
  default       = "standard" 
}

variable "instance_root_volume_size" {
  default       = "10"
}
