pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        // if pushing to Docker Hub or registry:
        DOCKER_REGISTRY = "yourdockerhubusername"   // change
        REGISTRY_CREDENTIALS_ID = "docker-registry-credentials"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // use bat if on Windows node; change to sh if Linux
                bat 'npm install'
            }
        }

        stage('Test') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    bat 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                script {
                    // login step depends on your registry
                    bat "docker login -u <username> -p <password> ${DOCKER_REGISTRY}"
                    bat "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${ IMAGE_TAG }"
                }
            }
        }

        stage('Deploy') {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                echo "Deploying the app..."
                // Example: stop old, run new. Change as per your deploy environment
                bat "docker rm -f ${IMAGE_NAME} || echo 'no container to remove'"
                bat "docker run -d --name ${IMAGE_NAME} -p 3000:3000 ${DOCKER_REGISTRY}/${IMAGE_NAME}:${ IMAGE_TAG }"
            }
        }
    }

    post {
        always {
            echo "Finished: ${currentBuild.currentResult}"
        }
        success {
            echo "Pipeline succeeded"
        }
        failure {
            echo "Pipeline FAILED"
        }
    }
}
