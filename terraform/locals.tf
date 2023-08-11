locals {
  is_using_template = [
    for name in data.github_repositories.repositories.names : name
    if length(data.github_repository.repository["${var.owner}/${name}"].template) != 0
  ]
  is_using_greeter_template = [
    for name in local.is_using_template : name
    if data.github_repository.repository["${var.owner}/${name}"].template[0].repository == "greeter"
  ]
  has_branch_protection_rules = [
    for repository in data.github_branch_protection_rules.branch_protection_rules : repository
    if length(repository.rules) != 0
  ]
  has_branch_protection_complete = [
    for repository in local.has_branch_protection_rules : repository
    if contains([for rule in repository.rules : rule.pattern], "main")
    && contains([for rule in repository.rules : rule.pattern], "release/*")
  ]
  is_missing_branch_protection = setsubtract(local.is_using_greeter_template, [
    for repository in local.has_branch_protection_complete : "${var.owner}/${repository.repository}"
  ])
}
