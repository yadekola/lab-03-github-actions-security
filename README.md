# Lab 3: CI/CD Security Pipeline

A hands-on DevOps project demonstrating how to build, test, scan, and publish a Java application using GitHub Actions, Maven, Trivy, Docker, and Docker Hub.

This project is part of my practical DevOps learning journey. My goal is to understand how automation and security checks help teams deliver applications more reliably.

## Project Objectives

- Automate Java application builds and tests with Maven.
- Create a CI/CD workflow using GitHub Actions.
- Scan source code and dependencies with Trivy.
- Store credentials securely using GitHub Actions repository secrets.
- Build and publish a Docker image to Docker Hub.
- Create an alternative CI/CD pipeline using GitLab CI.
- Compare GitHub Actions and GitLab CI, including Jenkins as another CI/CD tool.
- Document the architecture and prepare for DevOps interviews.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Java 21 | Application programming language |
| Maven | Build automation and test execution |
| JUnit 5 | Unit testing |
| Git and GitHub | Version control and source code hosting |
| GitHub Actions | CI/CD workflow automation |
| Trivy | Source code, dependency, and secret scanning |
| Docker | Container image creation and execution |
| Docker Hub | Container image registry |
| GitLab CI | Alternative CI/CD implementation |

## Application Overview

The application is a simple Java program that prints the following message:

`DevOps Lab App is running!`

A JUnit test checks that the application produces the expected message.

The project uses a Dockerfile to package and run the compiled Java application in a container.

## GitHub Actions Pipeline

The workflow is defined in:

`.github/workflows/ci.yml`

The pipeline contains two main jobs.

### Job 1: Build, Test, and Security Scan

This job:

1. Checks out the source code.
2. Sets up Java 21 and Maven caching.
3. Builds the application and runs unit tests.
4. Scans the source code and dependencies with Trivy.
5. Uploads the generated JAR as a workflow artifact.

The pipeline is configured to fail when Trivy reports findings that meet its configured HIGH or CRITICAL severity criteria.

### Job 2: Publish Docker Image

This job depends on the successful completion of the first job and runs only for pushes to the `main` branch.

It:

1. Checks out the source code.
2. Downloads the application JAR artifact.
3. Sets up Docker Buildx.
4. Authenticates with Docker Hub using GitHub repository secrets.
5. Builds and publishes the Docker image.

The configured image tags are:

- `yacks/devops-lab-app:1.0.0`
- `yacks/devops-lab-app:latest`

Docker Hub repository: [yacks/devops-lab-app](https://hub.docker.com/r/yacks/devops-lab-app)

## Security Practices

- Docker Hub credentials are stored in GitHub Actions repository secrets.
- Access tokens are not intentionally stored in the source code.
- GitHub Actions permissions are restricted to read repository contents.
- Trivy checks for vulnerabilities and secrets using the configured severity levels.
- The publishing job depends on the build, test, and security job.
- The `.gitignore` file excludes generated build files and common credential files.

**Security note:** The current Trivy configuration uses `ignore-unfixed: true`, which excludes vulnerabilities without an available fix from the scan results. Security findings that are reported must still be reviewed and addressed appropriately. Image vulnerability scanning is a planned improvement.

## Repository Structure

```text
lab-03-github-actions-security/
├── .github/
│   └── workflows/
│       └── ci.yml
├── docs/
│   ├── architecture.md
│   ├── interview-questions.md
│   └── platform-comparison.md
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/yadekola/devopslab/
│   │           └── App.java
│   └── test/
│       └── java/
│           └── com/yadekola/devopslab/
│               └── AppTest.java
├── .gitignore
├── .gitlab-ci.yml
├── Dockerfile
├── pom.xml
└── README.md
```

### Documentation

- `docs/architecture.md` — explains the pipeline architecture and workflow.
- `docs/interview-questions.md` — contains CI/CD interview questions and answers.
- `docs/platform-comparison.md` — compares CI/CD platforms and their implementation approaches.

## Project Progress

- [x] Create an independent GitHub repository.
- [x] Build the Java application.
- [x] Add a JUnit unit test.
- [x] Build and run the application locally.
- [x] Create and run the Docker image locally.
- [x] Push and pull the image from Docker Hub.
- [x] Configure the GitHub Actions workflow.
- [x] Automate Maven build and testing.
- [x] Add Trivy security scanning.
- [x] Configure GitHub repository secrets.
- [x] Publish Docker images through GitHub Actions.
- [x] Document the CI/CD pipeline architecture.
- [x] Prepare DevOps CI/CD interview questions and answers.
- [x] Document the CI/CD platform comparison.
- [x] Create the GitLab CI configuration.
- [ ] Run and validate the pipeline on GitLab CI.
- [ ] Add image vulnerability scanning before publishing.
- [ ] Review and improve pipeline security and reliability.

*Note: The GitHub Actions pipeline and Docker Hub publishing have been reported as successful. The GitLab CI configuration has been created, but its execution still needs to be validated.*

## What I Learned

This project helped me practise CI/CD automation, unit testing, security scanning, Docker image publishing, and secure credential management.

I also learned how to troubleshoot workflow failures by examining GitHub Actions logs, checking workflow configuration, and verifying whether repository secrets were available to the runner.

Working through these issues helped me understand that successful automation requires more than writing a pipeline: each stage must be configured correctly, tested, and monitored.

## Future Improvements

- Pin third-party GitHub Actions to verified commit SHAs.
- Review and update actions for supported Node.js runtimes.
- Add container image vulnerability scanning before publishing.
- Improve dependency and container security checks.
- Run and validate the pipeline in GitLab CI.
- Review least-privilege permissions and pipeline failure handling.
- Continue improving documentation and troubleshooting procedures.

## Author

**Yakub Adekola Ojo**

DevOps Learner | Entrepreneurship Student

- GitHub: [yadekola](https://github.com/yadekola)
- Docker Hub: [yacks/devops-lab-app](https://hub.docker.com/r/yacks/devops-lab-app)
