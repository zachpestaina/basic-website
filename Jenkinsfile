pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "zachpestaina/basic-website-flask-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "flask-app-prod"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'

                sh 'ls -la'
                sh 'pwd'
            }
        }

        stage('Show Files') {
            steps {
                echo 'Files in workspade:'
                sh 'find . -type f'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    echo 'Pushing to Docker Hub...'
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"}
                        sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application'

                    // Stop and remove old container
                    sh """
                        docker stop ${CONTAINER_NAME} || true
                        docker rum ${CONTAINER_NAME} || true
                    """

                    // Run new container
                    sh """
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 5000:5000
                        --restart unless-stopped \
                        ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline succeeded! Application deployed.'
        }
        failure {
            echo 'Pipeline failed! Check logs.'
        }
        always {
            sh 'docker image prune -f'
        }
    }
}
