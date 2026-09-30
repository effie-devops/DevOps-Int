variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "AWS CLI profile used for authentication"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Project name used for tagging and resource naming"
  type        = string
  default     = "section-2"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "section-2"
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# A second private subnet is required by RDS DB subnet groups, which must
# span at least two Availability Zones.
variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet (needed for the RDS subnet group)"
  type        = string
  default     = "10.0.3.0/24"
}

# ---------------------------------------------------------------------------
# EC2
# ---------------------------------------------------------------------------
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access (optional)"
  type        = string
  default     = null
}

variable "ssh_ingress_cidr" {
  description = "CIDR allowed to SSH into the public EC2 instance"
  type        = string
  default     = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------
# RDS
# ---------------------------------------------------------------------------
variable "db_engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "15"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port the database listens on"
  type        = number
  default     = 5432
}
