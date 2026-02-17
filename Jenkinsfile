pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "orangehrm-tests:${BUILD_NUMBER}"
        DOCKER_IMAGE_LATEST = 'orangehrm-tests:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo 'Checking out code from repository...'
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
                    echo 'Running tests in Docker container...'
                    sh """
                        rm -rf ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results
                        mkdir -p ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results
                    """
                    // Run WITHOUT --rm so container persists for docker cp
                    sh """
                        docker run \
                        --user root \
                        --name test-runner-${BUILD_NUMBER} \
                        -e CI=true \
                        -w /app \
                        ${DOCKER_IMAGE} \
                        npx playwright test || true
                    """
                    // Copy results directly from container filesystem - no volume mounts needed
                    sh "docker cp test-runner-${BUILD_NUMBER}:/app/playwright-report/. ${WORKSPACE}/playwright-report/"
                    sh "docker cp test-runner-${BUILD_NUMBER}:/app/test-results/. ${WORKSPACE}/test-results/"
                    sh "docker rm test-runner-${BUILD_NUMBER}"

                    // Verify files arrived
                    sh "ls -la ${WORKSPACE}/playwright-report/"
                    sh "ls -la ${WORKSPACE}/test-results/"
                }
            }
        }
    }

    post {
        always {
            script {
                sh "mkdir -p ${WORKSPACE}/playwright-report/html ${WORKSPACE}/test-results"

                publishHTML(
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    icon: '',
                    keepAll: true,
                    reportDir: 'playwright-report/html',
                    reportFiles: 'index.html',
                    reportName: "Playwright Test Report - Build ${BUILD_NUMBER}",
                    reportTitles: ''
                )
                junit allowEmptyResults: false,
                      stdioRetention: 'ALL',
                      testResults: 'test-results/results.xml'

                sh "docker rmi ${DOCKER_IMAGE} || true"
            }
        }
        success {
            echo '✅ Tests passed successfully!'
        }
        failure {
            echo '❌ Tests failed!'
        }
    }
}