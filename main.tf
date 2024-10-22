resource "helm_release" "karpenter" {
  repository       = var.karpenter.repository
  chart            = var.karpenter.chart
  version          = var.karpenter.version
  name             = "karpenter"
  namespace        = var.create_crd ? helm_release.karpenter_crd[0].namespace : var.namespace
  create_namespace = var.create_namespace && !var.create_crd
  force_update     = true
  verify           = var.verify
  recreate_pods    = var.recreate_pods
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  lint             = var.lint

  dynamic "set" {
    for_each = toset(compact([var.cluster_name]))
    content {
      name  = "settings.clusterName"
      value = set.key
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = toset(compact([var.cluster_endpoint]))
    content {
      name  = "settings.clusterEndpoint"
      value = set.key
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = toset(compact([var.service_account_role_arn]))
    content {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = set.key
    }
  }

  set {
    name  = "dnsPolicy"
    value = var.dns_policy
  }

  values = try([for values in var.values : yamlencode(yamldecode(values).karpenter)], [])
}

resource "helm_release" "karpenter_crd" {
  count = var.create_crd ? 1 : 0

  repository       = var.karpenter_crd.repository
  chart            = var.karpenter_crd.chart
  version          = var.karpenter_crd.version
  name             = "karpenter-crd"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  force_update     = true
  verify           = var.verify
  recreate_pods    = var.recreate_pods
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  lint             = var.lint

  values = try([for values in var.values : yamlencode(yamldecode(values).karpenter-crd)], [])
}

resource "helm_release" "karpenter_nodes" {
  count = var.create_karpenter_nodes ? 1 : 0

  repository       = var.karpenter_nodes.repository
  chart            = var.karpenter_nodes.chart
  version          = var.karpenter_nodes.version
  name             = "karpenter-nodes"
  namespace        = helm_release.karpenter.namespace
  create_namespace = false
  force_update     = true
  verify           = var.verify
  recreate_pods    = var.recreate_pods
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  lint             = var.lint

  values = try([for values in var.values : yamlencode(yamldecode(values).karpenter-nodes)], [])
}