pipeline {
    agent any

    environment {
        // Define Docker image names using the build number for versioning
        DOCKER_IMAGE = "orangehrm-tests:${BUILD_NUMBER}"
        DOCKER_IMAGE_LATEST = 'orangehrm-tests:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo 'Checking out code from repository...'
                    checkout scm
                    echo 'Creating folders in Jenkins workspace...'
                    sh "mkdir -p ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results"
                    sh "ls -la ${WORKSPACE}"  // check if folders exist
                }
            }
        }

        // stage('Prepare Folders') {
        //     steps {
        //         echo "Create folders for test reports and results if they don't exist..."
        //         sh "mkdir -p ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results"
        //     }
        // }

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
                    echo 'Running tests in Docker container...'
                    sh "rm -rf ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results"
                    sh "mkdir -p ${WORKSPACE}/playwright-report ${WORKSPACE}/test-results"
                    sh """
                        docker run --rm \
                        -v ${WORKSPACE}/playwright-report:/app/playwright-report \
                        -v ${WORKSPACE}/test-results:/app/test-results \
                        ${DOCKER_IMAGE} \
                        npx playwright test
                    """
                    echo "Test results are available in the 'playwright-report' directory on the Jenkins workspace."
                }
            }
        }
    }

    post {
        always {
            script {
                publishHTML(
                    allowMissing: false, 
                    alwaysLinkToLastBuild: true,
                    icon:'', 
                    keepAll: true, 
                    reportDir: 'playwright-report/',
                    reportFiles: 'index.html', 
                    reportName: "Playwright Test Report - Build ${BUILD_NUMBER}", 
                    reportTitles:''
                )
                junit stdioRetention: 'ALL', testResults: 'test-results/results.xml'
                echo "Cleaning up Docker image: ${DOCKER_IMAGE}"
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