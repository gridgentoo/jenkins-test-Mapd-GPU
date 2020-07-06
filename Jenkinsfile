def precommit_container_image = "sloria/pre-commit"
def precommit_container_name = "pymapd-precommit-$BUILD_NUMBER"
def db_container_image = "omnisci/core-os-cuda-dev:master"
//def db_container_image = "omnisci/core-os-cuda"
def db_container_name = "pymapd-db-$BUILD_NUMBER"
def testscript_container_image = "rapidsai/rapidsai:0.8-cuda10.0-runtime-ubuntu18.04-gcc7-py3.6"
def testscript_container_name = "pymapd-pytest-$BUILD_NUMBER"
def stage_succeeded

void setBuildStatus(String message, String state, String context) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/omnisci/jenkins-test"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
      commitShaSource: [$class: "ManuallyEnteredShaSource", sha: "$GIT_COMMIT" ],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

pipeline {
    agent none
    options { skipDefaultCheckout() }
    stages {
        stage('Set pending status') {
            agent any
            steps {
                // Set pending status manually for all jobs before node is started
                setBuildStatus("Build queued", "PENDING", "Test")
            }
        }
        stage("Linter and Tests") {
            agent { label 'centos7-p4-x86_64 && tools-docker' }
            stages {
                stage('Checkout') {
                    steps {
                        checkout scm
                    }
                }
                stage('Test') {
                    steps {
                        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                            script { stage_succeeded = false }
                            setBuildStatus("Running tests", "PENDING", "$STAGE_NAME");
                            sh """
                                echo test
                            """
                            script { stage_succeeded = true }
                        }
                    }
                    post {
                        always {
                            script {
                                if (stage_succeeded == true) {
                                    setBuildStatus("Build succeeded", "SUCCESS", "$STAGE_NAME");
                                } else {
                                    sh """
                                        echo fail
                                    """
                                    setBuildStatus("Build failed", "FAILURE", "$STAGE_NAME");
                                }
                            }
                        }
                    }
                }
            }
            post {
                always {
                    sh """
                        echo post
                    """
                    cleanWs()
                }
            }
        }
    }
}