pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-cred'     // ID configurado en Jenkins
        DOCKERHUB_REPO = 'tebancito/php-simple-app'  // Tu repo en DockerHub
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/dogor123/php-simple-app.git'
            }
        }

        stage('Generate Tag') {
            steps {
                script {
                    // Generar tag con fecha + hora + commit corto
                    COMMIT_ID = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    DATE_TAG = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
                    IMAGE_TAG = "${DATE_TAG}-${COMMIT_ID}"
                    echo "Tag generado: ${IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} -t ${DOCKERHUB_REPO}:latest .
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_REPO}:latest
                        docker logout
                        """
                    }
                }
            }
        }

        stage('No Changes Check') {
            when {
                expression {
                    // Aquí podrías comparar hash del commit o usar algún flag
                    // pero para simplicidad, solo muestra el mensaje
                    true
                }
            }
            steps {
                echo "Validando si hay cambios (demo)..."
            }
        }
    }

    post {
        success {
            echo "✅ Imagen subida correctamente con tag ${IMAGE_TAG}"
        }
        failure {
            echo "❌ Error en el pipeline"
        }
    }
}