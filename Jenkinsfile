pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_REPO = 'demco001/ekart'
        DOCKER_IMAGE = 'shopping-cart'
        DOCKER_TAG = 'latest'
    }
 
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Demco001/Ekart.git'
            }
        }
        
        stage('COMPILE') {
            steps {
                sh "mvn clean compile -DskipTests=true"
            }
        }
        
        stage('OWASP Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan .', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Sonarqube') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Ekart -Dsonar.java.binaries=. -Dsonar.projectKey=Ekart"
                }
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn clean package -DskipTests=true"
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: '5c68a638-f0a6-4d2b-b70b-05dbab7f5259', toolName: 'docker') {
                        // Build the Docker image
                        docker.build("${DOCKER_REGISTRY}/${DOCKER_REPO}:${DOCKER_TAG}")
                
                        // Tag the Docker image with the repository and tag
                        docker.image("${DOCKER_REGISTRY}/${DOCKER_REPO}:${DOCKER_TAG}")
                
                        // Push the Docker image to the repository
                        docker.image("${DOCKER_REGISTRY}/${DOCKER_REPO}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }
}
