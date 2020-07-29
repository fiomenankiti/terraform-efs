# -----------------------------------------------------------------------------------

# EFS File System

# -----------------------------------------------------------------------------------

resource "aws_efs_file_system" "efs-fs" {
  creation_token                  = var.name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  tags                            = merge({"Name" = var.name }, var.tags)
}


# -------------------------------------------------------------------------------------

# EFS Mount Target

# -------------------------------------------------------------------------------------

resource "aws_efs_mount_target" "efs-mnt" {
  count           = length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0
  file_system_id  = aws_efs_file_system.efs-fs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs-sg.id]
}

# -------------------------------------------------------------------------------------

# EFS Security Groups

# ------------------------------------------------------------------------------------

resource "aws_security_group" "efs-sg" {
  name        = var.name
  description = "Allows for NFS traffic for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each      = var.security_group_ingress
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      self        = lookup(ingress.value, "self", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      to_port     = lookup(egress.value, "to_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      self        = lookup(egress.value, "self", null)
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
    }
  }

  tags            = merge(
    {
      "Name"      = var.name
    },
    var.tags
  )
}
