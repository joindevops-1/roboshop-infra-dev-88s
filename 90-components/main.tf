module "components" {
    for_each = var.components
    source = "git::https://github.com/joindevops-1/terraform-roboshop-component.git?ref=main"
    component = each.key
    rule_priority = each.value.rule_priority
}