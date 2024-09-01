#!/bin/bash

detailed_instructions_url="https://github.com/Automacene/.github"
branching_strategy_url="$detailed_instructions_url?tab=readme-ov-file#branching-strategy"
hotfix_branches_url="$detailed_instructions_url?tab=readme-ov-file#hotfix-branches"

# Function to check branch naming convention
check_branch_name() {
    local branch_name="$1"
    local valid_branch_regex="^(feature|bug|enhancement|refactor|chore)/[a-z]+/[a-z0-9-]+$"
    local valid_hotfix_regex="^hotfix/[a-z]+/[a-z0-9-]+$"

    if [[ $branch_name =~ $valid_branch_regex ]] || [[ $branch_name =~ $valid_hotfix_regex ]]; then
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
        echo "For more details, refer to the detailed instructions at: $branching_strategy_url"
        return 1
    fi
}

# Function to check if develop branch exists
check_develop_branch() {
    if ! git rev-parse --verify develop > /dev/null 2>&1; then
        echo "Error: 'develop' branch does not exist. Please create it."
        echo "For example, in command line, you can do the following:"
        echo "  git checkout -b develop"
        echo "For example, in Github Desktop, you can do the following:"
        echo "  1. Click on the 'Current Branch' dropdown and select 'New Branch'"
        echo "  2. Enter the branch name 'develop' and click 'Create Branch'"
        echo "For more details, refer to the detailed instructions at: $branching_strategy_url"
        return 1
    fi
    return 0
}

# Function to prevent direct commits to develop
prevent_develop_commits() {
    local branch_name="$1"
    if [ "$branch_name" = "develop" ]; then
        echo "Error: Direct commits to 'develop' branch are not allowed."
        echo "Please create a feature branch and submit a pull request."
        echo "For example, in command line, you can do the following:"
        echo "  git checkout -b feature/author/feature-name"
        echo "For example, in Github Desktop, you can do the following:"
        echo "  1. Click on the 'Current Branch' dropdown and select 'New Branch'"
        echo "  2. Enter the branch name in the format 'feature/author/feature-name' and click 'Create Branch'"
        echo "For more details, refer to the detailed instructions at: $branching_strategy_url"
        return 1
    fi
    return 0
}

prevent_main_commits() {
    local branch_name="$1"
    if [ "$branch_name" = "main" ]; then
        echo "Error: Direct commits to 'main' branch are not allowed."
        echo "Please checkout the 'develop' branch and make a new feature branch from there."
        echo "For example, in command line, you can do the following:"
        echo "  git checkout develop"
        echo "  git checkout -b feature/author/feature-name"
        echo "For example, in Github Desktop, you can do the following:"
        echo "  1. Click on the 'Current Branch' dropdown and select 'develop'"
        echo "  2. Click on the 'Current Branch' dropdown again and select 'New Branch'"
        echo "  3. Enter the branch name in the format 'feature/author/feature-name' and click 'Create Branch'"
        echo "If you need to fix a critical issue, stay on the 'main' branch and create a hotfix branch."
        echo "For example, in command line, you can do the following:"
        echo "  git checkout -b hotfix/author/hotfix-name"
        echo "For example, in Github Desktop, you can do the following:"
        echo "  1. Click on the 'Current Branch' dropdown and select 'main'"
        echo "  2. Click on the 'Current Branch' dropdown again and select 'New Branch'"
        echo "  3. Enter the branch name in the format 'hotfix/author/hotfix-name' and click 'Create Branch'"
        echo "For more details, refer to the detailed instructions at: $hotfix_branches_url"
        return 1
    fi
    return 0
}

# Function to create the pre-commit hook content
create_hook_content() {
    cat << EOL
#!/bin/bash

local_branch="\$(git rev-parse --abbrev-ref HEAD)"

detailed_instructions_url="$detailed_instructions_url"
branching_strategy_url="$branching_strategy_url"
hotfix_branches_url="$hotfix_branches_url"

# Source the functions from the install script
source "\$(dirname "\$0")/pre-commit-functions.sh"

check_develop_branch || exit 1
prevent_develop_commits "\$local_branch" || exit 1
prevent_main_commits "\$local_branch" || exit 1
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
$(declare -f prevent_main_commits)
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

read -p "Press Enter to continue..."