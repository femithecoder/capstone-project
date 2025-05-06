module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  cluster_security_group_additional_rules = {
    allow_https_ingress = {
      description              = "Allow inbound HTTPS traffic"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      cidr_blocks              = ["10.0.0.0/16"]
    }
  }

enable_cluster_creator_admin_permissions = true
# bootstrap_self_managed_addons = false
cluster_endpoint_public_access = true
# cluster_endpoint_private_access = true
enable_irsa = true
# cluster_encryption_config = []
authentication_mode = "API_AND_CONFIG_MAP"
# cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_addons = {
  coredns = {
    most_recent = true
  }
  eks-pod-identity-agent = {
    most_recent = true
  }
  kube-proxy = {
    most_recent = true
  }
  vpc-cni = {
    most_recent = true
  }
}

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "m5.large" ]
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      AmazonEKSWorkerNodePolicy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    }
  }

  eks_managed_node_groups = {
    node-group = {

      instance_types = ["t3.medium", "m5.large" ]
      capacity_type  = "SPOT"
    

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  access_entries = {
    cluster = {
        principal_arn = "arn:aws:iam::195275640975:role/Test"

        policy_associations = {
            clusters = {
                policy_arn =  "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
                access_scope = {
                    namespaces = []
                    type = "cluster"

                    
        }
    }
  }
}

}
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
# resource "time_sleep" "wait_for_eks" {
#   depends_on = [module.eks]

#   create_duration = "300s" 
# }
# resource "kubernetes_namespace" "frontend" {
#   metadata {
#     annotations = {
#       name = "frontend"
#     }

#     labels = {
#       app = "webapp"
#     }

#     name = "frontend"
#   }
#   depends_on = [ module.eks ]
# #   wait_for_default_service_account = true

# }


# resource "kubernetes_namespace" "backend" {
#   metadata {
#     annotations = {
#       name = "backend"
#     }

#     labels = {
#       app = "webapp"
#     }

#     name = "backend"
#   }
#   depends_on = [ module.eks ]
# #   wait_for_default_service_account = true

# }
# resource "kubernetes_namespace" "monitoring" {
#   metadata {
#     annotations = {
#       name = "monitoring"
#     }

#     labels = {
#       app = "webapp"
#     }

#     name = "monitoring"
#   }
#   depends_on = [ module.eks ]
# #   wait_for_default_service_account = true

# }

# resource "time_sleep" "wait_for_namespace_monitoring" {
#   depends_on = [kubernetes_namespace.monitoring]

#   create_duration = "60s" 
# }
# resource "helm_release" "prometheus" {
#   name = "prometheus-agent"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart = "prometheus"
#   namespace = kubernetes_namespace.monitoring.metadata[0].name
#   depends_on = [ kubernetes_namespace.monitoring ]

#   values = [
#     <<EOF
# alertmanager:
#   enabled: true

# grafana:
#   enabled: false  

# prometheus:
#   service:
#     type: ClusterIP 
# EOF
#   ]
# }
# resource "kubernetes_secret" "grafana_admin_password" {
#   metadata {
#     name      = "grafana-admin-secret"
#     namespace = kubernetes_namespace.monitoring.metadata[0].name
#   }

#   data = {
#     admin-password = var.grafana_admin_password
#   }
# }

# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   namespace  = kubernetes_namespace.monitoring.metadata[0].name
#   depends_on = [ kubernetes_secret.grafana_admin_password ]

#   values = [
#     <<EOF
# admin: 
#  existingSecret: "grafana-admin-secret"
#  adminPasswordKey: "admin-password"
# service:
#   type: ClusterIP  
# EOF
#   ]
# }


