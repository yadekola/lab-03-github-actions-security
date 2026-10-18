
# Lab 3: CI/CD Security Pipeline

A hands-on DevOps project demonstrating how to build, test, scan, and publish a Java application using GitHub Actions, Maven, Trivy, Docker, and Docker Hub.

This project is part of my practical DevOps learning journey. My goal is to understand how automation and security checks help teams deliver applications more reliably.

## Project Objectives

- Automate Java application builds and tests with Maven.
- Create a CI/CD workflow using GitHub Actions.
- Scan source code and dependencies with Trivy.
- Store credentials securely using GitHub Actions repository secrets.
- Build and publish a Docker image to Docker Hub.
- Reproduce the pipeline with GitLab CI.
- Compare Jenkins, GitHub Actions, and GitLab CI.
- Document the architecture and prepare for DevOps interviews.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Java 21 | Application programming language |
| Maven | Build automation and test execution |
| JUnit 5 | Unit testing |
| Git and GitHub | Version control and source code hosting |
| GitHub Actions | CI/CD workflow automation |
| Trivy | Source and dependency security scanning |
| Docker | Container image creation |
| Docker Hub | Container image registry |
| GitLab CI | Planned alternative CI/CD implementation |

## Application Overview

The application is a simple Java program that returns:

`DevOps Lab App is running!`

A JUnit test checks that the application returns the expected message.

The project uses a Dockerfile to package the compiled Java application into a container image.

## GitHub Actions Pipeline

The workflow is defined in:

`.github/workflows/ci.yml`

### Job 1: Build, Test and Security Scan

1. Check out the source code.
2. Set up Java 21 and Maven caching.
3. Build the application and run unit tests.
4. Scan the source code and dependencies with Trivy.
5. Upload the generated JAR as a workflow artifact.

### Job 2: Publish Docker Image

This job depends on the successful completion of the first job and runs only for pushes to the `main` branch.

1. Check out the source code.
2. Download the application JAR.
3. Set up Docker Buildx.
4. Authenticate with Docker Hub using GitHub repository secrets.
5. Build and publish the Docker image.

The configured image tags are:

- `yacks/devops-lab-app:1.0.0`
- `yacks/devops-lab-app:latest`

Docker Hub repository:

https://hub.docker.com/r/yacks/devops-lab-app

## Security Practices

- Docker Hub credentials are stored in GitHub Actions repository secrets.
- Access tokens are not stored in the source code.
- GitHub Actions permissions are restricted to read repository contents.
- Trivy is configured to check for HIGH and CRITICAL vulnerabilities and secrets.
- The publishing job depends on the build, test, and security job.

Note: The current Trivy configuration uses `ignore-unfixed: true`. Security findings must still be reviewed when they occur.

## Repository Structure

```text
lab-03-github-actions-security/
├── .github/
│   └── workflows/
│       └── ci.yml
├── architecture/
├── scripts/
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
├── Dockerfile
├── pom.xml
├── README.md
├── answers.md
├── comparison.md
└── .gitlab-ci.yml
```

Some listed files and directories are planned deliverables and may not be present yet.

## Project Progress

- [x] Create an independent GitHub repository.
- [x] Build the Java application.
- [x] Add a JUnit unit test.
- [x] Build and run the application locally.
- [x] Create the Docker image locally.
- [x] Push and pull the image from Docker Hub.
- [x] Configure the GitHub Actions workflow.
- [x] Automate Maven build and testing.
- [x] Add Trivy security scanning.
- [x] Configure GitHub repository secrets.
- [x] Publish Docker images through GitHub Actions.
- [ ] Reproduce the pipeline using GitLab CI.
- [ ] Complete the Jenkins, GitHub Actions, and GitLab CI comparison.
- [ ] Complete the DevOps interview answers.
- [ ] Create the CI/CD architecture diagram.

## What I Learned

This project helped me practise CI/CD automation, unit testing, security scanning, Docker image publishing, and secure credential management.

I also learned how to troubleshoot workflow failures by examining GitHub Actions logs, checking action references, and verifying whether repository secrets were available to the runner.

## Future Improvements

- Pin third-party GitHub Actions to verified commit SHAs.
- Review and update actions for supported Node.js runtimes.
- Add image vulnerability scanning before publishing.
- Improve dependency and container security checks.
- Reproduce the pipeline in GitLab CI.
- Add an architecture diagram and detailed troubleshooting notes.

## Author

Yakub Adekola Ojo

DevOps Learner | Entrepreneurship Student

GitHub: https://github.com/yadekola

Docker Hub: https://hub.docker.com/r/yacks/devops-lab-app

