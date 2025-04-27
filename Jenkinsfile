pipeline {
    agent none // No default agent, we will specify it in each stage

    /*environment{

    }*/

    stages {
        stage('Checkout'){
            steps {
                echo 'Clonage du dépot...'
                checkout scm
            }
        }
        stage('Build & Test Django app') {
            agent{
                docker {
                    image 'python:3.12-slim' // Use a Python 3.11 Docker image
                    args '-u root:root' // Run as root user to avoid permission issues
                }
            }
            steps {
                dir('Backend/odc') {
                    echo "Création de l'environnement virtuel et test de Django"
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                        python3 manage.py test
                    '''
                }
            }
        }
        stage('Build & Test React app') {
            agent{
                docker {
                    image 'node:18-alpine' // Use a Node.js 18 Docker image
                    args '-u root:root' // Run as root user to avoid permission issues
                }
            }
            steps {
                dir('Frontend') {
                    echo "Installation des dépendances et test de React"
                    sh '''
                        export PATH=$PATH:/var/lib/jenkins/.nvm/versions/node/v22.15.0/bin/
                        npm install
                        npm run build
                        npm test -- --watchAll=false
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Add cleanup commands here
        }
    }
}