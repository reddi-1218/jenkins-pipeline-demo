pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        bat 'git checkout .' 
        // actually Jenkins automatically checks out when you use `checkout scm`
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
        bat 'docker build -t myimage:${BUILD_NUMBER} .'
      }
    }

    stage('Push Image') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        bat 'docker push ...'
      }
    }

    stage('Deploy') {
      when {
        expression { currentBuild.currentResult == 'SUCCESS' }
      }
      steps {
        bat 'docker run ...'
      }
    }
  }

  post {
    always {
      echo "Done. Final status: ${currentBuild.currentResult}"
    }
  }
}
