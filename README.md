# Standards and Conventions

This is a list of standards and conventions that we follow in the different codebases we work on. These standards are designed to ensure consistency, readability, and maintainability of the codebase. The codebases will be converted to the standards and conventions listed below. These are not meant to be exhaustive, but rather a simple enough set of rules that can be easily followed by all team members and contributors without much overhead. The goal is predictability, consistency, and maintainability but not rigidigty that discourages creativity, innovation, or participation.

## Table of Contents
**Features, Commits, and Pull Requests**
- [Commit Messages](#commit-messages)
- [Branching Strategy](#branching-strategy)
- [Hotfix Branches](#hotfix-branches)
- [Merge Conflict Resolution](#merge-conflict-resolution)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Continuous Integration and Deployment](#continuous-integration-and-deployment)

## Commit Messages
1. Keep titles short and describe the core change.
2. Use the commit message body for additional "what" and "why" details.

## Branching Strategy
1. Use `main` as the stable, production-ready branch and `develop` for integrating feature branches and testing.
2. Create branches from `develop` with the naming convention `author/feature-issue-name`.
3. Make regular commits with descriptive messages on the feature branch.
4. Create a pull request from the feature branch to `develop` for tracking changes and code review.
5. Merge the feature branch into `develop` after approval.
6. Regularly merge `develop` into `main` for stable production changes.
7. Delete feature branches after merging `develop` into `main`.
8. Keep your local `develop` branch updated with the remote.

## Hotfix Branches
1. Create a `hotfix` branch from `main` for critical bugs in production in the format `hotfix/author/issue-name`.
2. Make fixes in the `hotfix` branch and create a pull request to merge changes into `main` and `develop`.
3. After approval and passing tests, merge the `hotfix` branch into `main` and `develop`, then delete the branch.

## Merge Conflict Resolution
1. Review conflicting changes carefully.
2. Communicate with developers for clarity.
3. Select appropriate changes and ensure correctness.
4. Thoroughly test merged code.
5. Commit resolved merge and complete pull request.

## Pull Request Guidelines
1. Provide a clear, concise title.
2. Include a description of the branch's purpose.
3. Link to related issues or tickets so issues can be closed and users/clients can be notified.
4. Ensure all CI/CD checks pass.
5. Keep PRs small and focused for easier merging.

## Continuous Integration and Deployment
1. For new projects, set up a CI/CD pipeline that automatically builds, tests, and deploys the code from the `main` branch.
2. Configure the pipeline to run tests and security scans on pull requests targeting the `develop` branch to catch issues early.
