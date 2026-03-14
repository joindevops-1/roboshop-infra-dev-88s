module "components" {
    for_each = var.components
    source = "../../terraform-roboshop-component"
    component = each.key
    rule_priority = each.value.rule_priority
}