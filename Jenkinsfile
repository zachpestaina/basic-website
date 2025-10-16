pipeline {
    agent any

    stages {
        stage('Checkout') {
            step {
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
    }
}
