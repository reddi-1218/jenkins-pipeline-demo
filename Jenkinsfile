pipeline {
  agent any

  environment {
    IMAGE_NAME = "myimage"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Build Docker Image') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Push Image') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        bat "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }

    stage('Deploy') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        bat "docker run -d --name app${IMAGE_TAG} -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
      }
    }
  }

  post {
    always {
      echo "Final status: ${currentBuild.currentResult}"
    }
  }
}
