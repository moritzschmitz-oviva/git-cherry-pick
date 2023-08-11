data "github_repositories" "repositories" {
  query = "org:${var.owner}"
}

data "github_repository" "repository" {
  for_each  = toset(data.github_repositories.repositories.full_names)
  full_name = each.key
}

data "github_branch_protection_rules" "branch_protection_rules" {
  for_each   = toset(local.is_using_greeter_template)
  repository = each.key
}

