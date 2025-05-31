pipeline {
    agent none // No default agent, we will specify it in each stage

    environment{
        // Define any environment variables here if needed
        DOCKER_CREDENTIALS_ID = 'userprofile-credentials' // Replace with your Docker Hub credentials ID
        DOCKERHUB_USER = 'mldiop08' // Replace with your Docker Hub username
        DOCKER_CREDENTIALS = credentials('userprofile-credentials')  // Replace with your Docker Hub credentials ID
        //SONARQUBE_URL = 'https://95f4-41-214-74-161.ngrok-free.app' // Replace with your SonarQube URL
        //SONARQUBE_TOKEN = credentials('SONAR_TOKEN') // Replace with your SonarQube token ID
    }

    stages {
        stage('Checkout'){
            agent any
            steps {
                echo 'Clonage du dépot...'
                checkout scm
            }
        }

        stage('Scan avec trivy du code source') {
            agent any
            steps {
                echo 'Scan du code source avec Trivy...'
                script {
                    echo "🔍 Scan du code source avec Trivy"
                    sh '''
                        trivy fs --scanners secret,misconfig,vuln --severity HIGH,CRITICAL . -o ~/code_scan.txt
                        echo "✅ Scan terminé. Résultats enregistrés dans code_scan.txt"
                        echo "📂 Résultats du scan :"
                        cat ~/code_scan.txt
                    '''
                }
            }
        }

        /*stage('SonarQube Analysis for Backend') {
            agent any
            steps {
                dir('Backend/odc') {
                    echo 'Analyse SonarQube du Backend...'
                    withSonarQubeEnv('SonarQube') {
                        sh "${tool 'SonarScanner'}/bin/sonar-scanner -Dsonar.token=$SONARQUBE_TOKEN -Dsonar.host.url=$SONARQUBE_URL"
                        
                    }
                }
            }
        }

        stage('Sonarqube Analysis for Frontend') {
            agent any
            steps {
                dir('Frontend') {
                    echo 'Analyse SonarQube du Frontend...'
                    withSonarQubeEnv('SonarQube') {
                        sh "${tool 'SonarScanner'}/bin/sonar-scanner -Dsonar.token=$SONARQUBE_TOKEN -Dsonar.host.url=$SONARQUBE_URL"
                    }
                }
            }
        }*/

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
                            
                        //echo "🐳 Construction de l'image Docker Frontend"
                        //sh "docker build -t ${DOCKERHUB_USER}/userprofile_frontend:latest ."
                    }
                }
                dir('Frontend') {
                    script() {
                        echo "🐳 Construction de l'image Docker Frontend"
                        sh "docker build -t ${DOCKERHUB_USER}/userprofile_frontend:latest ."
                    }
                }
            }
        }

        stage('Push docker images') {
            agent any
            steps {
                echo "🚀 Envoi des images Docker sur Docker Hub"
                withCredentials([usernamePassword(credentialsId: 'userprofile-credentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push $DOCKERHUB_USER/userprofile_backend:latest
                        docker push $DOCKERHUB_USER/userprofile_frontend:latest
                    '''
                }
                echo "✅ Images Docker envoyées avec succès"
            }
        }

        // STAGE DE SCAN DES IMAGES DOCKER AVEC TRIVY
        stage('Scan Docker images') {
            agent any
            steps {
                echo 'Scan des images Docker...'
                script() {
                    echo "🔍 Scan des images Docker"
                    sh '''
                        trivy image --severity HIGH,CRITICAL $DOCKERHUB_USER/userprofile_backend:latest -o ~/backend_scan.txt
                        trivy image --severity HIGH,CRITICAL $DOCKERHUB_USER/userprofile_frontend:latest -o ~/frontend_scan.txt

                        echo "✅ Scan terminé. Résultats enregistrés dans backend_scan.txt et frontend_scan.txt"
                        echo "📂 Résultats du scan :"
                        echo "📄 Backend Scan Results:"
                        cat ~/backend_scan.txt
                        echo "📄 Frontend Scan Results:"
                        cat ~/frontend_scan.txt
                    '''
                }
            }
        }

        // STAGE DE VÉRIFICATION DES VULNÉRABILITÉS
        /*stage('Vérification des vulnérabilités') {
            agent any
            steps {
                echo 'Vérification des vulnérabilités critiques...'
                script() {
                    echo "🚨 Vérification des vulnérabilités critiques..."
                    sh '''
                        if grep -q 'CRITICAL' ~/backend_scan.txt || grep -q 'CRITICAL' ~/frontend_scan.txt; then
                            echo "❌ Des vulnérabilités critiques ont été détectées. Échec du pipeline."
                            exit 1
                        else
                            echo "✅ Aucune vulnérabilité critique détectée."
                        fi
                    '''
                }
            }
        }*/

        // STAGE DE DÉPLOIEMENT AVEC TERRAFORM ET ANSIBLE
        stage('Deploy with Terraform and Ansible') {
            agent any
            steps {
                echo 'Déploiement avec Terraform et Ansible...'
                withEnv(["KUBECONFIG=/home/mld/.kube/config"]) {
                    echo "🚀 Déploiement avec Terraform et Ansible"
                    sh '''
                        # Initialize Terraform
                        cd deployment/terraform-ansible
                        terraform init

                        # Apply Terraform configuration
                        terraform apply -auto-approve

                        # Run Ansible playbook for deployment
                        # ansible-playbook -i inventory.ini deploy.yml
                    '''
                }
                /*script() {
                    echo "🚀 Déploiement avec Terraform et Ansible"
                    sh '''
                        # Initialize Terraform
                        cd deployment/terraform-ansible
                        terraform init

                        # Apply Terraform configuration
                        terraform apply -auto-approve

                        # Run Ansible playbook for deployment
                        # ansible-playbook -i inventory.ini deploy.yml
                    '''
                }*/
            }
        }


        /*stage('RUN THE APP') {
            agent any
            steps {
                echo 'Lancement de l\'application...'
                script() {
                    echo "🚀 Lancement de l'application"
                    sh '''
                        docker compose down || true # Stop and remove any existing containers
                        docker compose up --build -d # Build and run the containers in detached mode
                    '''
                }
            }
        }*/
    }

    post {
        always {
            echo 'Cleaning up...'
            echo '✅ CI/CD terminé avec succès'
            // Add cleanup commands here
        }
    }
}