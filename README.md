# Lab 3: CI/CD with GitHub Actions, Security Scanning and Secrets

## Objective

Build an independent CI/CD lab that uses GitHub Actions and GitLab CI
to build, test, scan, and package a Java application in Docker.

The lab also compares Jenkins, GitHub Actions, and GitLab CI.

## Learning objectives

- Understand CI/CD workflows, jobs, steps, and dependencies.
- Run a Maven build and automated tests.
- Run security scanning and fail the pipeline when required checks fail.
- Store registry credentials securely.
- Build and publish a Docker image to Docker Hub.
- Restrict image publishing to the main branch.
- Recreate the core pipeline in GitLab CI.
- Compare three CI/CD tools using practical experience.

## Planned pipeline

1. Build the Java application.
2. Run automated tests.
3. Scan application dependencies for vulnerabilities.
4. Build and publish a Docker image when the required checks pass
   and the workflow runs on main.

## Repository structure

- `.github/workflows/` - GitHub Actions workflows.
- `architecture/` - Pipeline architecture diagram.
- `scripts/` - Helper scripts used by the lab.
- `comparison.md` - Jenkins vs GitHub Actions vs GitLab CI.
- `answers.md` - Lab interview questions.

## Security principles

- Never commit passwords, access keys, or tokens.
- Store registry credentials in GitHub Actions secrets and GitLab CI variables.
- Use least-privilege permissions.
- Do not publish images from untrusted pull requests.
- Pin third-party workflow actions to reviewed versions or commit SHAs.

## Progress

- [x] Create an independent lab repository.
- [ ] Create the Java/Maven application.
- [ ] Configure GitHub Actions build and test jobs.
- [ ] Add security scanning.
- [ ] Build and publish the Docker image.
- [ ] Reproduce the core pipeline in GitLab CI.
- [ ] Complete the architecture diagram and tool comparison.
- [ ] Answer the interview questions.
