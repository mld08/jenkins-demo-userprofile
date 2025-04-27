pipeline {
    agent {
        docker {
            image 'python:3.12-slim' // Use a Python 3.9 Docker image
            args '-u root:root' // Run as root user to avoid permission issues
        }
    }

    /*environment{

    }*/

    stages {
        stage('Checkout'){
            steps {
                echo 'Clonage du dépot...'
                checkout scm
            }
        }
        stage('Run Python Command') {
            steps {
                sh 'python3 --version'
                sh 'python3 -c "print(\'Hello depuis un agent Docker Python !\')"'
            }
        }
        /*stage('Build & Test Django app') {
            steps {
                dir('Backend/odc') {
                    echo "Création de l'environnement virtuel et test de Django"
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install requirements.txt
                        python3 manage.py test
                    '''
                }
            }
        }*/
        /*stage('Test') {
            steps {
                echo 'Testing...'
                // Add your test commands here
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Add your deployment commands here
            }
        }*/
    }

    post {
        always {
            echo 'Cleaning up...'
            // Add cleanup commands here
        }
    }
}