variable "components" {
    default = {
        catalogue = {
            rule_priority = 10
        }
        user = {
            rule_priority = 20
        }
    }
}