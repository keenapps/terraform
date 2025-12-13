# ----------------------------
# Configure the GitHub Provider
# ----------------------------
provider "github" {
  owner = "keenapps" #Your profile
}

resource "github_repository" "terraform_repo" {
  name        = "Terraform-Showcase"                 # Repository name
  description = "Repository deployed with Terraform" # Repository description
  auto_init   = true                                 # Initialize with first commit (README + default branch)
  visibility  = "private"                            # Repository visibility
}

resource "github_repository_file" "readme" {
  repository          = github_repository.terraform_repo.name                                      # Target repository
  branch              = "main"                                                                     # Branch to commit to
  file                = "README.md"                                                                # File path
  content             = "# Educational Repository\n\nThis repository is for educational purposes." # File content
  overwrite_on_create = true                                                                       # Overwrite if README already exists
}

resource "github_repository_file" "index" {
  repository          = github_repository.terraform_repo.name                                         # Target repository
  branch              = "main"                                                                        # Branch to commit to
  file                = "index.html"                                                                  # File path
  content             = "Hello Terraform!\n\nThis is the random_id generator ${random_id.random.dec}" # File content with random id generator
  overwrite_on_create = true                                                                          # Overwrite if README already exists
}
