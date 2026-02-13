pipeline {
    agent any
    stages {
        stage('Run Tests in Docker') {
            agent {
                docker {
                    image 'docker:24.0.5' // Linux image with Docker CLI
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh 'docker version'
                sh 'docker ps'
                sh 'docker build -t orangehrm-tests:latest .'
                sh 'docker run --rm orangehrm-tests:latest'
            }
        }
    }
}