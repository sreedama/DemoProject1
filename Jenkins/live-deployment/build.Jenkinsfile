pipeline {
    agent { label 'master' }
    stages {
        stage('Build') {
            steps {
                bat label: '', script: 'live-deployment\\build.bat'
            }
            post {
                success {
                    zip archive: true, dir: 'live-deployment/', glob: 'deploy/**', zipFile: 'deploy.zip'                  
                    cleanWs()
                }
            }
        }
    }
    post {        
        success {
            cleanWs()
        }
    }
}