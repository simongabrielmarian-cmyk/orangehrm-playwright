// configuration add of Jenkins File for CI/CD pipeline to build and run Playwright tests in Docker container
pipeline {
    agent any

    environment {
        // Define Docker image names using the build number for versioning
        DOCKER_IMAGE = "orangehrm-tests:${BUILD_NUMBER}"
        DOCKER_IMAGE_LATEST = "orangehrm-tests:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Checking out code from repository..."
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {

                // Build the Docker image using the Dockerfile in the repository
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    // Tag the image as 'latest' for easier reference in future runs
                    sh "docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE_LATEST}"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    // Run the Docker container, mounting the workspace to access test results
                sh """
                docker run --rm \
                    -v ${WORKSPACE}/playwright-report:/app/playwright-report \
                    -v ${WORKSPACE}/test-results:/app/test-results \
                     ${DOCKER_IMAGE}
                """
                    echo "Test results are available in the 'playwright-report' directory on the Jenkins workspace."

                }
            }
        }

        stage('Archive Results') {
            steps {
                script {
                    echo "Archiving test results..."
                    // Publish JUnit results (VERY IMPORTANT)
                    junit 'test-results/results.xml'
                    // Archive HTML report
                    archiveArtifacts artifacts: 'playwright-report/**', allowEmptyArchive: true
                }
            }
        }
    }

    post {
        always {
            script {
                publishHTML (allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'playwright-report/html/', reportFiles: 'index.html', reportName: "Playwright Test Report - Build #${BUILD_NUMBER}")
                echo "Cleaning up Docker image: ${DOCKER_IMAGE}"
                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }

        success {
            echo "✅ Tests passed successfully!"
        }

        failure {
            echo "❌ Tests failed!"
        }
    }
}
