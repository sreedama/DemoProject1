pipeline {
    agent { label 'master' }
    parameters {
        choice(name: 'Environment', choices: ['', 'Dev 605', 'Dev 609', 'Quality App03', 'Quality App04', 'Quality', 'Integration', 'Production', 'Training'], description: 'Deploy to chosen environment')
    }
    stages {
        stage('Update job properties') {
            steps {
                script {
                    properties([[$class: 'BuildNowTextProperty', alternateBuildNow: 'Deploy']])
                }
            }
        }
        stage('Deploy Single Node') {
            when {
                expression {
                    return "$params.Environment" == ''
                }
            }
            steps {
                error "This is an initial build of the task. It can't have the Environment specified, but it is required for the next deployments to have it."
            }
        }
        stage('Deploy') {
            matrix {
                axes {
                    axis {
                       name 'NODE_TO_DEPLOY'
                       values 'ch00sa605', // Dev
							  'ch00sa504', // Integration App
                              'ch00sa449', // Quality App
							  'ch00sa100', // Quality App
                              'ch00sa527', // Production App
                              'ch00sa99'  // Training App
                   }
                }
                stages {
                    stage('Deploy Single Node') {
                        when {
                            beforeAgent true
                            expression {
                                return "$params.Environment".size() > 0 && Jenkins.get().getLabel("$NODE_TO_DEPLOY").getNodes().size() == 1 && Jenkins.get().getLabel("$params.Environment").getNodes().containsAll(Jenkins.get().getLabel("$NODE_TO_DEPLOY").getNodes())
                            }
                        }
                        options {
                            skipDefaultCheckout true
                        }
                        agent {
                            label "${NODE_TO_DEPLOY}"
                        }
                        steps {
                            fileOperations([fileDeleteOperation(excludes: '', includes: 'deploy.zip'), folderDeleteOperation('deploy')])
                            echo "Deploying in ${MT4_ENVIRONMENT}/${NODE_TO_DEPLOY} from ${scm.branches[0]} as ${"${scm.branches[0]}".replaceFirst(~/origin\//, "")}"
                            copyArtifacts filter: "deploy.zip", fingerprintArtifacts: true, projectName: "Subtasks/AWC/TC12-awc-customization-build/${"${scm.branches[0]}".replaceFirst(~/origin\//, "").replaceFirst(~/\//, "%2F")}"
                            unzip dir: '', glob: '', quiet: true, zipFile: 'deploy.zip'
                            bat label: '', script: '''call deploy\\deploy.bat
                                @echo errorlevel: %errorlevel%
                                if errorlevel 1 (
                                exit /B 1 
                                ) else ( exit /B 0
                                )'''
                        }
                        post {
                            always {
                                jiraSendDeploymentInfo site: 'citplm.atlassian.net', environmentId: "$params.Environment", environmentName: "$params.Environment", environmentType: "$params.Environment" == "Production" || "$params.Environment" == "Training" ? 'production' : "$params.Environment" == "Quality" ? 'staging' : "$params.Environment" == "Integration" ? 'testing' : 'development'
                                archiveArtifacts 'deploy-*.log'
                            }
                            success {
                                cleanWs()
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            emailext body: "<p>Jenkins deploy of ${params.Branch} to ${params.Environment} has finished with status: ${currentBuild.currentResult}</p><p>Check console output at <a href=\"${currentBuild.absoluteUrl}\">${currentBuild.absoluteUrl}</a> to view the results.</p>", mimeType: 'text/html', recipientProviders: [buildUser(), culprits(), developers(), requestor(), brokenBuildSuspects(), brokenTestsSuspects(), upstreamDevelopers()], replyTo: 'no-reply-jenkins@mt.com', subject: "Jenkins build #${currentBuild.number} of ${currentBuild.fullProjectName}: ${currentBuild.currentResult}"
        }
    }
}