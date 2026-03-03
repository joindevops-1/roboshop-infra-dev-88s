module "vpc" {
    source = "../../terraform-aws-vpc"
    project = var.project_name
    environment = var.environment
    is_peering_required = true
}