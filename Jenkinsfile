// configuration add of Jenkins File for CI/CD pipeline to build and run Playwright tests in Docker container
pipeline {
    agent any

    environment {
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
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    sh "docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE_LATEST}"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests in Docker container..."
                    sh "docker run --rm -v ${WORKSPACE}/playwright-report:/app/playwright-report ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Archive Results') {
            steps {
                script {
                    echo "Archiving test results..."
                    archiveArtifacts artifacts: 'test-results/**', allowEmptyArchive: true
                    archiveArtifacts artifacts: 'playwright-report/**', allowEmptyArchive: true
                }
            }
        }
    }

    post {
        always {
            script {
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
