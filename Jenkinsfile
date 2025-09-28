pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-creds2') // ID de credenciales en Jenkins
        IMAGE_NAME = "tebancito/php-simple-app"
        BUILD_VERSION = "1.0.${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dogor123/php-simple-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build --build-arg BUILD_VERSION=$BUILD_VERSION -t $IMAGE_NAME:$BUILD_VERSION .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'docker push $IMAGE_NAME:$BUILD_VERSION'
                sh 'docker tag $IMAGE_NAME:$BUILD_VERSION $IMAGE_NAME:latest'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }
    }

    post {
        always {
            echo "=== Limpieza final ==="
            sh 'docker system prune -f || true'
        }
        success {
            echo "✅ Pipeline completado con éxito"
        }
        failure {
            echo "❌ Pipeline falló"
        }
    }
}