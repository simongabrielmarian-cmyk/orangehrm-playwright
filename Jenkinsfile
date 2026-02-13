pipeline {
    agent any
    stages {
        stage('Docker Test') {
            steps {
                sh 'whoami'
                sh 'docker version'
                sh 'docker ps'
            }
        }
    }
}
