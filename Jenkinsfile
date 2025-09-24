pipeline {
    agent any

    environment {
        IMAGE_NAME = "myimage"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        DOCKERHUB_USERNAME = "chanikya1218"
        DOCKERHUB_CREDENTIALS_ID = "dockerhub_creds"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Test') {
            steps {
                script {
                    def status = bat returnStatus: true, script: 'npm test'
                    echo "Test exit status: ${status}"
                    if (status != 0) {
                        echo "Tests failed (UNSTABLE), but continuing"
                        currentBuild.result = 'UNSTABLE'
                    } else {
                        echo "Tests passed"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                bat "docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID,
                                                      usernameVariable: 'DOCKER_USER',
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                    }
                }
                bat "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${ IMAGE_TAG}"
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                bat "docker rm -f app${IMAGE_TAG} || echo \"No existing container\""
                bat "docker run -d --name app${IMAGE_TAG} -p 3000:3000 ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
            echo "Final status: ${currentBuild.currentResult}"
        }
    }
}
