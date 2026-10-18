# DevOps Interview Preparation: CI/CD Security Pipeline

## Project Overview

**Project:** Lab 3 — CI/CD Security Pipeline

**Application:** `devops-lab-app`

**Technologies:** Java 21, Maven, GitHub Actions, GitLab CI/CD, Trivy, Docker, and Docker Hub.

**Project objective:** Build an automated pipeline that tests application code, scans the repository for security issues, and publishes a Docker image after the required checks succeed.

**Implementation status:** The GitHub Actions pipeline has been executed successfully. The GitLab CI configuration has been created, but its execution and end-to-end validation remain pending.

---

## Section 1: CI/CD Fundamentals

### Question 1: What is CI/CD?

**Answer:**

CI/CD stands for Continuous Integration and Continuous Delivery or Continuous Deployment.

- **Continuous Integration (CI):** Automatically builds and tests code changes so that problems can be identified early.
- **Continuous Delivery:** Keeps software in a deployable state, with production releases typically requiring approval.
- **Continuous Deployment:** Automatically releases changes to production after the required checks pass.

In my project, GitHub Actions automates the Maven build, unit tests, Trivy security scan, and Docker image publishing.

### Question 2: Why did you implement a CI/CD pipeline?

**Answer:**

I implemented the pipeline to reduce repetitive manual work, identify problems earlier, and make the software delivery process more consistent.

Instead of manually building the Java application, running tests, scanning for security issues, and publishing the Docker image every time, the pipeline automates these tasks.

The pipeline also ensures that Docker publishing depends on the successful completion of the build and security job.

### Question 3: What is the difference between a job and a step in GitHub Actions?

**Answer:**

A **step** is an individual task inside a job. For example, checking out the repository or running Maven tests.

A **job** is a group of steps executed in a runner environment.

In my workflow, `build-test-scan` and `publish-docker` are jobs. Checking out the source code, setting up Java, running Maven, and scanning with Trivy are steps within the first job.

Jobs can run in parallel by default unless dependencies or other conditions determine their execution order.

### Question 4: What happens when you push code to the `main` branch?

**Answer:**

The workflow is triggered by the push event.

The build and security job checks out the source code, configures Java 21, runs the Maven build and tests, and scans the repository using Trivy.

If this job succeeds, the Docker publishing job downloads the JAR artifact, builds the Docker image, authenticates with Docker Hub, and pushes the configured image tags.

If the required job fails, the dependent publishing job does not proceed.

---

## Section 2: Build and Testing

### Question 5: Why did you use Maven?

**Answer:**

Maven is a Java build automation and dependency management tool.

I used Maven to compile the application, resolve dependencies, run unit tests, and package the application into a JAR file.

The command used in the pipeline is:

`mvn --batch-mode clean package`

- `clean` removes previous build output.
- `package` compiles the code, runs the tests during the normal lifecycle, and packages the application.
- `--batch-mode` reduces interactive output and is suitable for automated environments.

This command helps ensure that the pipeline builds the application from a clean state.

### Question 6: Why did you use Java 21?

**Answer:**

Java 21 is the Java version selected for this project. I configured the GitHub Actions workflow to use Java 21 and used a Maven environment based on Java 21 in the proposed GitLab pipeline.

Keeping the build and runtime versions compatible helps prevent problems caused by differences between development and execution environments.

### Question 7: What is a unit test, and what did you test?

**Answer:**

A unit test checks a small, individual part of an application to confirm that it behaves as expected.

In this project, I wrote a JUnit test for the `getMessage()` method in the `App` class.

The test checks whether the method returns:

`DevOps Lab App is running!`

I ran `mvn clean package` locally and confirmed that the test passed. The same build and test command is used in the GitHub Actions pipeline.

---

## Section 3: Security and Docker

### Question 8: What is Trivy, and why did you use it?

**Answer:**

Trivy is a security scanner that can identify issues such as software vulnerabilities and exposed secrets.

I added Trivy to the pipeline to help identify security problems before publishing the Docker image.

The configured scan targets HIGH and CRITICAL findings and uses the `ignore-unfixed` option.

The pipeline is configured to fail when matching findings are detected. This makes security scanning part of the delivery decision rather than an optional manual check.

However, a successful scan does not prove that the application is completely secure. Scan scope, available vulnerability data, and configuration all affect the results.

### Question 9: What is the purpose of a Dockerfile?

**Answer:**

A Dockerfile defines the instructions used to build a Docker image.

In my project, the Dockerfile uses a Java 21 runtime image, creates `/app` as the working directory, copies the packaged JAR into the image, and defines the command that starts the Java application.

This allows the application to run in a container without requiring the full Maven build environment inside the final runtime image.

### Question 10: Why did you use Docker Hub?

**Answer:**

Docker Hub is a container image registry where Docker images can be stored and distributed.

I used Docker Hub to publish my application image so that it can be pulled and run from another environment.

The pipeline publishes two tags:

- `yacks/devops-lab-app:1.0.0`
- `yacks/devops-lab-app:latest`

The version-specific tag identifies a particular release, while `latest` is a conventional tag that can be updated to point to a newer image.

For reproducible deployments, an immutable version or image digest is preferable to relying on `latest` alone.

### Question 11: Why do you need Docker Hub credentials in GitHub Actions?

**Answer:**

The workflow needs to authenticate with Docker Hub before it can push images to my repository.

I configured repository secrets named `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`.

The workflow reads these secrets during execution rather than storing credentials directly in the YAML file.

During troubleshooting, the Docker login job reported that the username and password were missing. Debugging showed that the secrets were resolving as unavailable. I rechecked and saved the repository secrets, then triggered a fresh run that completed successfully.

This taught me to verify secret names, repository scope, and whether the workflow has access to the required credentials—without exposing the actual token.

---

## Section 4: Pipeline Troubleshooting

### Question 12: What would you do if the pipeline failed?

**Answer:**

I would first identify the failed job and inspect the logs around the first meaningful error.

My troubleshooting process would be:

1. Identify the failed job and step.
2. Read the error message and surrounding logs.
3. Determine whether the issue comes from the source code, dependencies, configuration, credentials, or runner environment.
4. Reproduce the issue locally when possible.
5. Make one targeted change at a time.
6. Rerun the pipeline and verify the result.

I would avoid changing multiple unrelated settings at once because that makes the root cause harder to identify.

### Question 13: Why use artifacts between pipeline jobs?

**Answer:**

Artifacts allow one job to preserve files for use by another job.

In my GitHub Actions pipeline, the build job uploads the generated JAR file. The Docker publishing job downloads that artifact before building the image.

This separates application building from image publishing and avoids depending on a file that exists only in another job's temporary workspace.

### Question 14: Why does the Docker publishing job depend on the build and security job?

**Answer:**

The `needs: build-test-scan` setting establishes a dependency between the jobs.

It ensures that the Docker publishing job waits for the required build and security job to succeed.

This reduces the risk of publishing an image when the required checks have failed.

The publishing job also contains a condition restricting publication to pushes to the `main` branch.

### Question 15: What would you check if Docker image publishing failed?

**Answer:**

I would inspect the publishing job logs and check:

- Whether the build and security job succeeded.
- Whether the JAR artifact was downloaded into the expected location.
- Whether the Dockerfile and build context are correct.
- Whether Docker Hub credentials are available and valid.
- Whether the target repository exists and the token has permission to push.
- Whether the runner can access Docker and the Docker registry.

I would fix the earliest relevant failure and rerun the pipeline.

---

## Section 5: GitHub Actions vs GitLab CI/CD

### Question 16: What is the difference between GitHub Actions and GitLab CI/CD?

**Answer:**

Both platforms automate software development and delivery tasks, but their configuration models differ.

GitHub Actions uses workflow files containing events, jobs, and steps. GitLab CI/CD uses a `.gitlab-ci.yml` file containing pipelines, stages, and jobs.

Both can run Maven builds, perform security scans, and publish Docker images.

In this project, I created an implementation for GitHub Actions and a corresponding GitLab CI configuration. The GitHub Actions pipeline has been verified, while the GitLab pipeline still needs to be executed and tested.

### Question 17: Why create a GitLab CI configuration if GitHub Actions already works?

**Answer:**

I created the equivalent GitLab CI configuration as a learning exercise to understand how CI/CD concepts transfer between platforms.

The objective is to learn how to translate build commands, job dependencies, artifact handling, security scanning, credentials, and image publishing from one CI/CD system to another.

Creating the file is only the first step. I still need to run it in GitLab, configure the required variables and runner, and validate the complete pipeline.

---

## Section 6: Reflection and Further Improvements

### Question 18: What did you learn from this project?

**Answer:**

This project helped me understand how different DevOps tools work together in a delivery pipeline.

I practised building and testing a Java application with Maven, scanning source code and dependencies with Trivy, packaging an application in Docker, and automating image publishing through GitHub Actions.

I also learned that pipeline failures require systematic troubleshooting. In particular, the Docker Hub authentication issue taught me to check whether credentials are actually available to a workflow instead of assuming that creating a secret is sufficient.

### Question 19: What would you improve in this pipeline?

**Answer:**

Possible improvements include:

- Pinning third-party actions to verified commit SHAs where appropriate.
- Adding stronger dependency and container image scanning.
- Generating and retaining software bill of materials (SBOM) reports.
- Using immutable image digests for deployment references.
- Adding integration tests and deployment stages.
- Improving least-privilege permissions and secret handling.
- Testing the GitLab CI implementation and comparing its results with GitHub Actions.

I would introduce these changes incrementally and verify that each improvement works before expanding the pipeline.

### Question 20: How would you explain this project in an interview?

**Answer:**

I built a small Java application and created a CI/CD pipeline using GitHub Actions. The pipeline builds and tests the application with Maven, scans the repository using Trivy, and publishes a Docker image to Docker Hub after the required checks pass.

I also prepared an equivalent GitLab CI configuration to learn how similar automation can be implemented on another platform. The GitHub Actions pipeline has been executed successfully, and I plan to validate the GitLab implementation next.

The project gave me practical experience with build automation, testing, security scanning, containerization, registry authentication, artifact handling, and pipeline troubleshooting.

---

## Final Preparation Checklist

- [ ] Explain the purpose of every job and step in the GitHub Actions workflow.
- [ ] Explain the Maven build lifecycle used in the project.
- [ ] Describe how Trivy findings affect the pipeline.
- [ ] Explain Docker image tags and registry authentication.
- [ ] Demonstrate how artifacts move between jobs.
- [ ] Explain the Docker Hub secret troubleshooting process.
- [ ] Distinguish verified GitHub Actions results from pending GitLab validation.
- [ ] Complete and test the GitLab CI pipeline.
- [ ] Practise explaining the project without reading the answers verbatim.
