# CI/CD Platform Comparison: GitHub Actions vs GitLab CI

## 1. Introduction

This document compares GitHub Actions and GitLab CI/CD using the Lab 3 project, which implements a Continuous Integration and Continuous Delivery (CI/CD) pipeline for a Java application.

The project demonstrates how automated pipelines can build and test application code, perform security scanning, and publish Docker images to Docker Hub.

GitHub Actions is the primary implementation that has been executed successfully. A corresponding GitLab CI configuration has also been created to demonstrate how similar automation can be implemented on another CI/CD platform. The GitLab pipeline remains pending execution and validation.

## 2. Project Objectives

The objectives of this comparison are to:

- Understand the similarities and differences between GitHub Actions and GitLab CI/CD.
- Compare their pipeline configuration formats and execution models.
- Examine how both platforms support automated builds, testing, security scanning, and Docker image publishing.
- Understand how credentials and sensitive information are managed.
- Identify the practical considerations involved in migrating a pipeline between platforms.

## 3. Platform Overview

### GitHub Actions

GitHub Actions is an automation platform integrated with GitHub. It uses YAML workflow files to define events, jobs, and steps that execute automated tasks.

In this project, the workflow is defined in:

`.github/workflows/ci.yml`

The workflow runs when code is pushed to the `main` branch or when a pull request targets that branch.

### GitLab CI/CD

GitLab CI/CD is an automation system integrated with GitLab. It uses a YAML configuration file to define pipelines, stages, jobs, and execution instructions.

The equivalent configuration for this project is:

`.gitlab-ci.yml`

The configuration defines build and test, security scanning, and Docker publishing stages. The pipeline must be imported into or otherwise configured within GitLab before it can be executed there.

## 4. Feature Comparison

| Feature | GitHub Actions | GitLab CI/CD |
|---|---|---|
| Configuration file | `.github/workflows/ci.yml` | `.gitlab-ci.yml` |
| Main structure | Workflows, jobs, and steps | Pipelines, stages, and jobs |
| Execution environment | GitHub-hosted or self-hosted runners | GitLab-hosted or self-managed runners |
| Pipeline triggers | Events such as push and pull request | Events and pipeline rules, including branch and merge request conditions |
| Java build and testing | Maven with a Java setup action | Maven container image |
| Security scanning | Trivy through a GitHub Action | Trivy container image and CLI |
| Docker image publishing | Docker login and build/push actions | Docker CLI and Docker-in-Docker in the proposed configuration |
| Secret management | GitHub Actions secrets | GitLab CI/CD variables |
| Build artifact handling | Upload and download artifact actions | Job artifacts |
| Pipeline dependencies | Job dependencies using `needs` | Stage ordering and job dependency mechanisms |
| Configuration validation | Workflow validation and pipeline execution | CI configuration validation and pipeline execution |

Although the platforms use different configuration models, both can automate similar software delivery tasks.

## 5. Pipeline Design Comparison

### 5.1 Build and Test

**GitHub Actions implementation**

The workflow uses a Java 21 environment and Maven to build the application and execute its unit tests.

Command:

`mvn --batch-mode clean package`

The resulting JAR file is uploaded as a workflow artifact for the publishing job.

**GitLab CI implementation**

The proposed GitLab pipeline uses a Maven container image with Java 21. It executes the same Maven command and stores the generated JAR file as a job artifact.

**Comparison**

Both implementations use Maven to perform the build and tests. Their main difference is how the Java environment is provided and how artifacts are transferred between jobs.

### 5.2 Security Scanning

**GitHub Actions implementation**

The workflow uses the Trivy GitHub Action to scan the repository for vulnerabilities and secrets. It targets HIGH and CRITICAL findings, ignores unfixed vulnerabilities, and is configured to return a failure exit code when matching findings are detected.

**GitLab CI implementation**

The proposed configuration runs Trivy from a container image and uses the Trivy command-line interface to perform a filesystem scan.

**Comparison**

Both approaches use Trivy as the scanning engine. GitHub Actions integrates it through an action, while GitLab CI runs it through a containerized command.

A successful scan does not guarantee that an application is completely secure. The result depends on the scan scope, available vulnerability data, configuration, and detected findings.

### 5.3 Docker Image Publishing

**GitHub Actions implementation**

The publishing job uses Docker-related GitHub Actions to build and push these image tags:

- `yacks/devops-lab-app:1.0.0`
- `yacks/devops-lab-app:latest`

The job runs only for a push to the `main` branch and only after the build and security job succeeds.

**GitLab CI implementation**

The proposed publishing job uses the Docker CLI with Docker-in-Docker to build and push the same image tags. It is restricted to the default branch.

The GitLab implementation may require a runner that supports the Docker-in-Docker configuration and its security requirements.

**Comparison**

Both platforms can automate Docker image publishing. The implementation details depend on the runner environment, authentication configuration, and the Docker build approach.

## 6. Secrets and Credential Management

Both platforms provide mechanisms for storing sensitive values outside the source code.

For GitHub Actions, this project uses repository secrets:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

The equivalent GitLab configuration will use CI/CD variables with the same names.

The Docker Hub token should be stored securely and must not be committed to the repository, printed in logs, or shared publicly. Masking should be enabled where supported.

Protected variables should be configured according to the project's protected-branch and deployment requirements.

## 7. Advantages and Considerations

### GitHub Actions

**Advantages**
- Direct integration with GitHub repositories and events.
- Reusable actions from the GitHub Actions ecosystem.
- Convenient handling of workflow artifacts and job dependencies.
- Suitable for automating CI/CD without maintaining a separate GitLab project.

**Considerations**
- Workflow syntax and action versions require maintenance.
- External actions must be selected and maintained carefully.
- Available execution time and runner capabilities depend on the account and runner type.

### GitLab CI/CD

**Advantages**
- Pipeline configuration is integrated into GitLab projects.
- Stage-based pipelines make execution order easy to understand.
- Supports job artifacts, variables, and different runner configurations.
- Can provide an integrated workflow for source code management and CI/CD.

**Considerations**
- A suitable GitLab project and runner environment are required.
- Docker-in-Docker may require specific runner configuration and permissions.
- Credentials and pipeline rules must be configured correctly.
- The pipeline must be tested in GitLab before its behaviour can be considered verified.

## 8. Key Technical Differences

The most important distinction is not the Maven command or the use of Trivy. It is how each platform defines and executes automation.

GitHub Actions organizes automation around workflows triggered by events. Within a workflow, jobs contain ordered steps and can depend on other jobs.

GitLab CI/CD organizes automation around pipelines containing stages and jobs. Stages establish the general execution order, while job dependencies and rules provide additional control.

These differences mean that migrating a pipeline requires more than copying YAML commands. Triggers, artifacts, secrets, runner capabilities, permissions, and failure conditions must also be translated and tested.

## 9. Project Validation Status

| Component | Status |
|---|---|
| Java application build | Verified locally |
| Maven unit test | Verified locally |
| Docker image execution | Verified locally |
| GitHub Actions build and security pipeline | Reported successful |
| Docker Hub publishing through GitHub Actions | Reported successful |
| GitLab CI configuration | Created and pushed to GitHub |
| GitLab pipeline execution | Pending |
| GitLab Docker Hub authentication | Pending |
| End-to-end GitLab pipeline validation | Pending |

This distinction is important because a configuration file can be syntactically correct but still fail during execution due to runner permissions, missing variables, image availability, or other environment-specific conditions.

## 10. Conclusion

GitHub Actions and GitLab CI/CD provide different ways to implement automated software delivery pipelines.

This project demonstrates a working GitHub Actions pipeline for building and testing a Java application, scanning the repository with Trivy, and publishing a Docker image to Docker Hub. A corresponding GitLab CI configuration has been prepared to explore how the same workflow can be implemented on another platform.

The next step is to execute the GitLab pipeline, configure its credentials, resolve any runner-related issues, and compare the actual results with the verified GitHub Actions implementation.

The project reinforces an important DevOps principle: automation should be reproducible, secure, testable, and supported by evidence from successful execution.

---

**Project:** Lab 3 — CI/CD Security Pipeline

**Application:** `devops-lab-app`

**Container image:** `yacks/devops-lab-app`

**Primary technologies:** Java 21, Maven, GitHub Actions, GitLab CI/CD, Trivy, Docker, and Docker Hub.
