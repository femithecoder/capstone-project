module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = "capstone-project"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    capstone_access = {
        principal_arn = "arn:aws:iam::femi-need-to-create-role"

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
    node_pools = ["capstone-pools"]

    vpc_id = var.vpc_id
    subnet_ids = var.private_subnets

    control_plane_subnet_ids = var.private_subnets

    eks_managed_node_groups_defaults = {
        instance_types = [t3.medium]
        iam_role_additional_policies = {
            amazonEBSCSIDriverPolicy = "arn:aws::policy/service-role/AmazonEBSCSIDriverPolicy"
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

resource "kubernetes_namespace" "backend" {
  metadata {
    
  }
}