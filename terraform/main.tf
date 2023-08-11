resource "github_branch_protection" "main" {
  for_each      = toset(local.is_missing_branch_protection)
  pattern       = "main"
  repository_id = each.key
}

resource "github_branch_protection" "release" {
  for_each      = toset(local.is_missing_branch_protection)
  pattern       = "release/*"
  repository_id = each.key
}
