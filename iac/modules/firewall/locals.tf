locals {
  fwPIP                                = "${var.name}-pip"
  fwNetworkRuleCollectionName          = "${var.name}-NetRuleCollection"
  fwApplicationRuleCollectionNameAllow = "${var.name}-AppRuleCollectionAllow"
  fwApplicationRuleCollectionNameDeny  = "${var.name}-AppRuleCollectionDeny"
  fwDnatRuleCollectionName             = "${var.name}-dnatRuleCollection"
}
