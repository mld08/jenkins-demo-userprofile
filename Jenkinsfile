pipeline {
    agent none // No default agent, we will specify it in each stage

    environment{
        // Define any environment variables here if needed
        DOCKER_CREDENTIALS_ID = 'userprofile-credentials' // Replace with your Docker Hub credentials ID
        DOCKERHUB_USER = 'mldiop08'
    }

    stages {
        stage('Checkout'){
            agent any
            steps {
                echo 'Clonage du dépot...'
                checkout scm
            }
        }

        // TEST STAGE 
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
                    image 'node:23-alpine' // Use a Node.js 23 Docker image
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
                    '''
                }
            }
        }
        // STAGE DE DEPLOIEMENT
        stage('Build Docker image') {
            agent any
            steps {
                echo 'Construction de l\'image Docker Backend...'
                dir('Backend/odc') {
                    script() {
                        echo "🐳 Construction de l'image Docker Backend"
                        sh "docker build -t ${DOCKERHUB_USER}/userprofile_backend:latest -f Dockerfile ."
                            
                        echo "🐳 Construction de l'image Docker Frontend"
                        sh "docker build -t ${DOCKERHUB_USER}/userprofile_frontend:latest ./Frontend"
                    }
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