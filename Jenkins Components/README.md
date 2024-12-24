# Jenkins Pipeline for Gradle Project 🛠️

This Jenkins pipeline automates the build, test, and deployment process for a Gradle project. The pipeline includes stages for Git checkout, setting permissions, running unit tests, building a JAR, performing SonarQube analysis, building and pushing a Docker image, and deploying to a Kind cluster.

## Prerequisites 📋

Ensure you have the following installed and configured:

- Jenkins
- Docker
- SonarQube
- Kind (Kubernetes in Docker)

## Pipeline Overview 🚀

The pipeline consists of the following stages:

1. **Git Checkout** 📝

   - Checks out the source code from the SCM (Source Code Management) repository.

2. **Set Permissions** 🔒

   - Sets executable permissions for the Gradle wrapper script.

3. **Unit Test** 🧪

   - Runs unit tests using the Gradle wrapper.

4. **Build JAR** 📦

   - Builds the JAR file using the Gradle wrapper.

5. **SonarQube Test** 🔍

   - Performs code analysis using SonarQube.

6. **Build Image** 🏗️

   - Builds a Docker image for the application.

7. **Push Image to DockerHub** 📤

   - Pushes the Docker image to DockerHub.

8. **Deploy to Kind Cluster** 🚢
   - Deploys the application to a Kind (Kubernetes in Docker) cluster.

## Environment Variables 🌐

The following environment variables are used in the pipeline:

- `DOCKER_IMAGE_NAME`: The name of the Docker image.
- `DOCKER_IMAGE_VERSION`: The version of the Docker image, based on the Jenkins build number.
- `SONAR_PROJECT_KEY`: The SonarQube project key.
- `SONAR_PROJECT_NAME`: The SonarQube project name.
- `SONAR_HOST_URL`: The URL of the SonarQube server.
- `DEPLOYMENT_NAME`: The name of the Kubernetes deployment.
- `CONTAINER_NAME`: The name of the container within the deployment.

## Jenkinsfile 🏗️

```groovy
@Library('my-jenkins-shared-lib@main') _
pipeline {
    agent {
        label 'aws-ec2-agent'
    }

    environment {
        DOCKER_IMAGE_NAME = "mujimmy/openjdk"
        DOCKER_IMAGE_VERSION = "${BUILD_NUMBER}"
        SONAR_PROJECT_KEY = "my-gradle-project-key"
        SONAR_PROJECT_NAME = "My Gradle Project"
        SONAR_HOST_URL = "http://54.221.92.185:9000"
        DEPLOYMENT_NAME = "my-deployment"
        CONTAINER_NAME = "my-container"
    }

    stages {
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Permissions') {
            steps {
                sh 'chmod +x gradlew'
            }
        }

        stage('Unit Test') {
            steps {
                sh './gradlew test'
            }
        }

        stage('Build JAR') {
            steps {
                sh './gradlew assemble'
            }
        }

        stage('SonarQube Test') {
            steps {
                script {
                    sonarScan(
                        projectKey: "${SONAR_PROJECT_KEY}",
                        projectName: "${SONAR_PROJECT_NAME}",
                        sonarHostUrl: "${SONAR_HOST_URL}"
                    )
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    dockerBuild(
                        imageName: "${DOCKER_IMAGE_NAME}",
                        version: "${DOCKER_IMAGE_VERSION}"
                    )
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    dockerPush(
                        imageName: "${DOCKER_IMAGE_NAME}",
                        version: "${DOCKER_IMAGE_VERSION}"
                    )
                }
            }
        }

        stage('Deploy to Kind Cluster') {
            steps {
                script {
                    try {
                        echo "Starting deployment to Kind cluster..."
                        deployToKindStage(
                            DOCKER_IMAGE_NAME: "${DOCKER_IMAGE_NAME}",
                            DOCKER_IMAGE_VERSION: "${DOCKER_IMAGE_VERSION}",
                            DEPLOYMENT_NAME: "${DEPLOYMENT_NAME}",
                            CONTAINER_NAME: "${CONTAINER_NAME}"
                        )
                        echo "Deployment completed successfully"
                    } catch (Exception e) {
                        echo "Deployment failed with error: ${e.getMessage()}"
                        error "Failed to deploy to Kind cluster"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed! Check the logs for details."
        }
        always {
            cleanWs()
        }
    }
}
```

## Post-Build Actions 📋

- Success: Logs successful pipeline execution

- Failure: Logs pipeline failure details

- Always: Cleans workspace after execution

## Shared Library Dependencies 📚

This pipeline uses custom shared library functions:

- sonarScan

- dockerBuild

- dockerPush

- deployToKindStage

## Error Handling ⚠️

- Includes try-catch block for deployment stage

- Proper error logging and pipeline failure handling
