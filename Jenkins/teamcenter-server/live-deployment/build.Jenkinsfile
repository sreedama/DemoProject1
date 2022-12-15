pipeline {
    agent { label 'master' }
    stages {
        stage('Build') {
            steps {
                bat label: '', script: 'teamcenter-server\\live-deployment\\build.bat'
            }
            
        }
    }
    post {        
        success {
            cleanWs()
        }
    }
}