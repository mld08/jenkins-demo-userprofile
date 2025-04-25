pipeline {
    agent any

    environment{

    }

    stages {
        stage('Checkout'){
            steps {
                echo 'Clonage du dépot...'
                checkout scm
            }
        }
        stage('Build & Test Django app') {
            steps {
                dir('Backend/odc') {
                    echo "Création de l'environnement virtuel et test de Django"
                    sh '''
                        apt install python3 
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install requirements.txt
                        python3 manage.py test
                    '''
                }
            }
        }
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