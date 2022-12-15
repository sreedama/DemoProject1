pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat label: '', script: 'teamcenter-server\\live-deployment\\build.bat'
            }
            post {
                success {
				script{
						zip archive: true, dir: 'teamcenter-server/live-deployment/', glob: 'deploy/**', zipFile: 'deploy.zip'
					}                    
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