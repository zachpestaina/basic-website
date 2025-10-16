pipeline {
    agent any

    environment {
        DOCKER_CMD = "/Users/zach/.docker/bin/docker"
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
                    sh "${DOCKER_CMD} build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "${DOCKER_CMD} tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-credentials',
                            usrnameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )
                    ]) {
                        echo 'Pushing to Docker Hub...'
                        sh """
                            echo "${DOCKER_PASS}" | ${DOCKER_CMD} login -u "${DOCKER_USER}" --password-stdin
                            ${DOCKER_CMD} push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            ${DOCKER_CMD} push ${DOCKER_IMAGE}:latest
                            ${DOCKER_CMD} logout
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application'

                    // Stop and remove old container
                    sh """
                        ${DOCKER_CMD} stop ${CONTAINER_NAME} || true
                        ${DOCKER_CMD} run ${CONTAINER_NAME} || true
                    """

                    // Run new container
                    sh """
                        ${DOCKER_CMD} run -d \
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
            sh "${DOCKER_CMD} image prune -f"
        }
    }
}
