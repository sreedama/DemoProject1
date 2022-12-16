pipeline {
    agent { label 'Built-In Node' }
    stages {
        stage('Build') {
            steps {
                bat label: '', script: 'teamcenter-server\\live-deployment\\awc\\awc_customization\\build.bat'
            }
            post {
                success {
                    script{
						zip archive: true, dir: 'teamcenter-server/live-deployment/awc/awc_customization/', glob: 'deploy/**', zipFile: 'deploy.zip'
					}
                    cleanWs()
					
                }
            }
        }
//        stage('Dont build an initial commit') {
//            when {
//                expression {
//                    return ${currentBuild.number} == 1
//                }
//            }
//            steps {
//                error "This is an initial build of the task. It can't have the Environment specified, but it is required for the next deployments to have it."
//            }
//        }
    }
    post {
        
        success {
            cleanWs()
        }
    }
}