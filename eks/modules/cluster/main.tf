module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

enable_cluster_creator_admin_permissions = true
bootstrap_self_managed_addons = false
cluster_endpoint_public_access = true
cluster_endpoint_private_access = true
enable_irsa = true
cluster_enabled_log_types       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "m5.large" ]
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }

  eks_managed_node_groups = {
    node-group = {

      instance_types = ["t3.medium", "m5.large" ]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  access_entries = {
    cluster = {
        principal_arn = "arn:aws:iam::548570664128:role/ec2-connect"

        policy_associations = {
            clusters = {
                policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"   
                access_scope = {
                    # namespaces = ["default", "monitoring", "frontend", "backend"]
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
resource "time_sleep" "wait_for_eks" {
  depends_on = [module.eks]

  create_duration = "60s" 
}
resource "kubernetes_namespace" "frontend" {
  metadata {
    annotations = {
      name = "frontend"
    }

    labels = {
      app = "webapp"
    }

    name = "frontend"
  }
  depends_on = [ module.eks ]

}


resource "kubernetes_namespace" "backend" {
  metadata {
    annotations = {
      name = "backend"
    }

    labels = {
      app = "webapp"
    }

    name = "backend"
  }
  depends_on = [ module.eks ]
}
resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    labels = {
      app = "webapp"
    }

    name = "monitoring"
  }
  depends_on = [ module.eks ]
}

resource "time_sleep" "wait_for_namespace_monitoring" {
  depends_on = [kubernetes_namespace.monitoring]

  create_duration = "60s" 
}
resource "helm_release" "prometheus" {
  name = "prometheus-agent"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "prometheus"
  namespace = kubernetes_namespace.monitoring.metadata[0].name
  depends_on = [ kubernetes_namespace.monitoring ]

  values = [
    <<EOF
alertmanager:
  enabled: true

grafana:
  enabled: false  

prometheus:
  service:
    type: ClusterIP 
EOF
  ]
}
resource "kubernetes_secret" "grafana_admin_password" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    admin-password = var.grafana_admin_password
  }
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  depends_on = [ kubernetes_secret.grafana_admin_password ]

  values = [
    <<EOF
admin: 
 existingSecret: "grafana-admin-secret"
 adminPasswordKey: "admin-password
service:
  type: ClusterIP  
EOF
  ]
}


