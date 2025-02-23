resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::548570664128:user/femithecoder"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
  role       = aws_iam_role.eks_admin_role.name
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = "capstone-project"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnets
  control_plane_subnet_ids = var.private_subnets


  access_entries = {
    capstone_access = {
        principal_arn = aws_iam_role.eks_admin_role.arn

        policy_associations = {
            capstone_asso = {
                policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"
                access_scope = {
                    namespaces = ["default"]
                    type = "namespace"
                }
            }
        }
    }
  }


  cluster_addons = {
    coredns = {
        most_recent = true
    }
    vpc-cni = {
        most_recent = true
    }
    kube-proxy = {
        most_recent = true
    }
    aws-ebs-csi-driver = {
        most_recent = true
    }
  }

  cluster_compute_config = {
    enabled  = true
    # node_pools = ["capstone-pools"]

  eks_managed_node_groups_defaults = {
        instance_types = ["t2.medium"]
        iam_role_additional_policies = {
            amazonEBSCSIDriverPolicy = "arn:aws:iam::policy/service-role/AmazonEBSCSIDriverPolicy"
        }
  }
    eks_managed_node_groups = {
        capstone = {
            min_size = 1
            max_size = 2
            desired_size = 1
            instance_types = ["t3.medium"]
            capacity_type = "SPOT"
        }
    }
  }
  depends_on = [aws_iam_role.eks_admin_role]
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
  depends_on = [ module.eks ]
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
  depends_on = [ module.eks ]
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
  depends_on = [ module.eks ]
}
