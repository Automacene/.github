#!/bin/bash

# Function to check branch naming convention
check_branch_name() {
    local branch_name="$1"
    local valid_branch_regex="^(feature|bug|enhancement|refactor|chore)/[a-z]+/[a-z0-9-]+$"
    local valid_hotfix_regex="^hotfix/[a-z]+/[a-z0-9-]+$"

    if [[ $branch_name =~ $valid_branch_regex ]] || [[ $branch_name =~ $valid_hotfix_regex ]] || [ "$branch_name" = "main" ]; then
        return 0
    else
        echo "Error: Branch name '$branch_name' does not follow the naming convention."
        echo "Please use one of the following formats:"
        echo "  - feature/author/feature-name"
        echo "  - bug/author/bug-name"
        echo "  - enhancement/author/enhancement-name"
        echo "  - refactor/author/refactor-name"
        echo "  - chore/author/chore-name"
        echo "  - hotfix/author/hotfix-name"
        return 1
    fi
}

# Function to check if develop branch exists
check_develop_branch() {
    if ! git rev-parse --verify develop > /dev/null 2>&1; then
        echo "Error: 'develop' branch does not exist. Please create it."
        return 1
    fi
    return 0
}

# Function to prevent direct commits to develop
prevent_develop_commits() {
    local branch_name="$1"
    if [ "$branch_name" = "develop" ]; then
        echo "Error: Direct commits to 'develop' branch are not allowed. Please create a feature branch and submit a pull request."
        return 1
    fi
    return 0
}

# Function to create the pre-commit hook content
create_hook_content() {
    cat << EOL
#!/bin/bash

local_branch="\$(git rev-parse --abbrev-ref HEAD)"

# Source the functions from the install script
source "\$(dirname "\$0")/pre-commit-functions.sh"

check_develop_branch || exit 1
prevent_develop_commits "\$local_branch" || exit 1
check_branch_name "\$local_branch" || exit 1
EOL
}

# Function to create and install the pre-commit hook
create_pre_commit_hook() {
    local hooks_dir=".git/hooks"
    local pre_commit_file="$hooks_dir/pre-commit"
    local functions_file="$hooks_dir/pre-commit-functions.sh"

    mkdir -p "$hooks_dir"

    # Create the functions file
    cat > "$functions_file" << EOL
$(declare -f check_branch_name)
$(declare -f check_develop_branch)
$(declare -f prevent_develop_commits)
EOL

    # Create the pre-commit hook
    create_hook_content > "$pre_commit_file"

    chmod +x "$pre_commit_file"
    echo "Installed pre-commit hook in the current repository"
}

# Main execution
if [ -d ".git" ]; then
    create_pre_commit_hook
    echo "Hook installation complete."
else
    echo "Error: This script must be run from the root of a Git repository."
    exit 1
fi