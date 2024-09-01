# Standards and Conventions

This is a list of standards and conventions that we follow in the different codebases we work on. These standards are designed to ensure consistency, readability, and maintainability of the codebase. The codebases will be converted to the standards and conventions listed below. These are not meant to be exhaustive, but rather a simple enough set of rules that can be easily followed by all team members and contributors without much overhead. The goal is predictability, consistency, and maintainability but not rigidigty that discourages creativity, innovation, or participation.

## Table of Contents
**Features, Commits, and Pull Requests**
- [Branching Strategy](#branching-strategy)
- [Hotfix Branches](#hotfix-branches)
- [Merge Conflict Resolution](#merge-conflict-resolution)
- [Continuous Integration and Deployment](#continuous-integration-and-deployment)

## Branching Strategy
1. Use two primary branches:
   - `main`: The stable, production-ready branch. All code in `main` should be thoroughly tested and ready for deployment.
   - `develop`: The branch for integrating feature branches and performing testing before merging into `main`.
2. For each new feature, bug fix, or task, create a new branch from `develop` using the naming convention: `author/feature-issue-name`.
3. Work on the feature branch, making regular commits with descriptive messages.
4. When the feature is complete, create a pull request from the feature branch to `develop`. This allows for tracking changes and facilitates code review if needed in the future.
5. Once the pull request is approved (manually or through automated checks), merge the feature branch into `develop`.
6. Regularly merge `develop` into `main` when the changes in `develop` are stable and ready for production. This can be done manually or through a scheduled job in your CI/CD pipeline.

## Hotfix Branches
1. For critical bugs in production, create a new `hotfix` branch directly from `main` using the naming convention: `hotfix/issue-name`.
2. Make the necessary fixes in the `hotfix` branch and create a pull request to merge the changes back into both `main` and `develop`.
3. Once the pull request is approved and passes all tests, merge the `hotfix` branch into both `main` and `develop`, and delete the `hotfix` branch.

## Merge Conflict Resolution
1. When encountering merge conflicts, the person responsible for the merge (you or your brother) should carefully review the conflicting changes.
2. Communicate with the other developer if needed to understand the intent behind the conflicting changes.
3. Resolve the conflicts by selecting the appropriate changes and ensuring the resulting code is correct and functional.
4. Test the merged code thoroughly to ensure no regressions or unintended side effects.
5. Commit the resolved merge and complete the pull request.

## Continuous Integration and Deployment
1. Set up a CI/CD pipeline that automatically builds, tests, and deploys the code from the `main` branch to your production environment.
2. Configure the pipeline to run tests and security scans on pull requests targeting the `develop` branch to catch issues early.
3. As your team grows and your project matures, consider adding automated code quality checks and AI-assisted code reviews to your pipeline.