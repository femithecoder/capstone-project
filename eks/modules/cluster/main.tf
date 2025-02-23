module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  cluster_endpoint_public_access = true

  create_kms_key              = false
  create_cloudwatch_log_group = false
  cluster_encryption_config   = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }

  eks_managed_node_groups = {
    node-group-01 = {
      min_size     = 1
      max_size     = 10
      desired_size = 2
  
      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true
  #create_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::548570664128:role/ec2-connect"
      username = "femithecoder"
      groups   = ["system:masters"]
    },
  ]

  tags = {
    env       = "dev"
    terraform = "true"
  }
}
resource "kubernetes_namespace" "capstone_frontend" {
  metadata {
    annotations = {
      name = "capstone_frontend"
    }
    
    labels = {
      app = "webapp"
    }
    name = "capstone_frontend"
  }
}

resource "kubernetes_namespace" "capstone_backend" {
  metadata {
    annotations = {
      name = "capstone_backend"
    }

    labels = {
      app = "webapp"
    }
    name = "capstone_backend"
  }
}

resource "kubernetes_namespace" "capstone_monitoring" {
  metadata {
    annotations = {
      name = "capstone_monitoring"
    }

    labels = {
      app = "webapp"
    }
    name = "capstone_monitoring"
  }
}
