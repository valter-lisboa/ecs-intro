data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "bastion_firewall" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "ec2-${local.bastion}"
  description         = "Security group for bastion"
  vpc_id              = module.vpc.vpc_id
  ingress_rules       = []
  ingress_cidr_blocks = [local.vpc_cidr]
}

module "bastion_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"

  create_role             = true
  role_name               = "ec2-${local.bastion}"
  create_instance_profile = true
  custom_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  tags                    = local.common_tags

  trusted_role_services = [
    "ec2.amazonaws.com",
    "ssm.amazonaws.com",
  ]
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t3.nano"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.bastion_firewall.this_security_group_id]
  iam_instance_profile   = module.bastion_role.this_iam_instance_profile_name

  tags = merge(
    local.common_tags,
    { Name = local.bastion }
  )
}
