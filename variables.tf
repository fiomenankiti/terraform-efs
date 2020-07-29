#------------------------------------------------------------------------------

# Variables for EFS 

#------------------------------------------------------------------------------


variable "security_group_ingress" {
  description = "Can be specified multiple times for each ingress rule. "
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
    cidr_blocks = []
  }]
}


variable "security_group_egress" {
  description = "Can be specified multiple times for each egress rule. "
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }]
}


variable "name" {
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation."
  type        = string
}


variable "vpc_id" {
  description = "The name of the VPC that EFS will be deployed to"
  type        = string
}


variable "subnet_ids" {
  description = "Subnet IDs for Mount Targets"
  type        = list(string)
  default     = ["", "", ""] 
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "encrypted" {
  description = "If true, the file system will be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "If set, use a specific KMS key"
  type        = string
  default     = null
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  type        = string
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
  default     = 0
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  type        = string
  default     = "bursting"
}
