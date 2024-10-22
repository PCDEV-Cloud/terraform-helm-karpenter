variable "karpenter" {
  description = "Settings of 'karpenter' helm release"
  type = object({
    repository = optional(string, "oci://public.ecr.aws/karpenter")
    chart      = optional(string, "karpenter")
    version    = optional(string, "1.0.4")
  })
  default = {}
}

variable "karpenter_crd" {
  description = "Settings of 'karpenter-crd' helm release"
  type = object({
    repository = optional(string, "oci://public.ecr.aws/karpenter")
    chart      = optional(string, "karpenter-crd")
    version    = optional(string, "1.0.4")
  })
  default = {}
}

variable "karpenter_nodes" {
  description = "Settings of 'karpenter-nodes' helm release"
  type = object({
    repository = optional(string, "")
    chart      = optional(string, "karpenter-nodes")
    version    = optional(string, "")
  })
  default = {}
}

variable "namespace" {
  description = "Namespace to install all releases into"
  type        = string
  default     = "karpenter"
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist"
  type        = bool
  default     = true
}

variable "create_crd" {
  description = "Create Custom Resource Definitions (CRDs) with 'karpenter-crd' helm chart"
  type        = bool
  default     = true
}

variable "create_karpenter_nodes" {
  description = "Whether to install 'karpenter-nodes' helm chart"
  type        = bool
  default     = true
}

variable "verify" {
  description = "Verify the package before installing it"
  type        = bool
  default     = false
}

variable "recreate_pods" {
  description = "Perform pods restart during upgrade/rollback"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
  default     = 600
}

variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
  default     = false
}

variable "lint" {
  description = "Run helm lint when planning"
  type        = bool
  default     = true
}

variable "values" {
  description = "List of additional values in raw yaml format to pass to helm. Values should be in 'karpenter', 'karpenter-crd' or 'karpenter-nodes' map"
  type        = list(string)
  default     = []
}

variable "replicas" {
  description = "Number of karpenter replicas"
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint of the EKS Kubernetes API server"
  type        = string
  default     = ""
}

variable "service_account_role_arn" {
  description = "The ARN of the Controller IAM Role"
  type        = string
}

variable "dns_policy" {
  description = "Karpenter pods DNS Policy configuration. Set 'Default' if Karpenter is deployed on fargate"
  type        = string
  default     = "Default"
}

variable "node_classes" {
  description = "A map of Karpenter EC2 Node Classes"
  default     = {}
}

variable "node_pools" {
  description = "A map of Karpenter Node Pools"
  default     = {}
}
