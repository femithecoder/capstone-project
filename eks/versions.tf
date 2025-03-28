# terraform {
#   required_version = ">= 1.0.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.50"  # ✅ Lock AWS to a compatible version (<4.0.0)
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = "~> 2.9"  # ✅ Lock Helm below v3.0
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "~> 2.9"  # ✅ Lock Kubernetes below v3.0
#     }
#   }
# }
