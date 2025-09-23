pipeline {
    agent any

    environment {
        // Replace with your Docker Hub username/repo
        DOCKER_IMAGE = "yourdockerhubusername/your-app"
        // Credentials ID you will set up in Jenkins
        REGISTRY_CREDENTIALS = "dockerhub-creds"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
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
                bat 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', REGISTRY_CREDENTIALS) {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push("${IMAGE_TAG}")
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push("latest")
                    }
                }
            }
        }

        stage('Deploy Locally') {
            steps {
                echo 'Deploying container locally'
                bat "docker rm -f my-app || echo No existing container"
                bat "docker run -d --name my-app -p 3000:3000 ${DOCKER_IMAGE}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
