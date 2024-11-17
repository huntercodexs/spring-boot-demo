pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME'
        jdk 'java17-default'
    }

    environment {
        DOCKER_USERNAME = "huntercodexs"
        DOCKER_IMAGE = "huntercodexs/spring-boot-demo"
        DOCKER_CREDENTIALS_ID = credentials("docker-hub-cred-id")
        K8S_NAMESPACE = "spring-boot-demo--namespace"
        KUBECONFIG_CREDENTIALS_ID = credentials("kube-config-cred-id")
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    sh "mvn clean package"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${env.DOCKER_IMAGE}:latest ."
                    sh "docker tag ${env.DOCKER_IMAGE}:latest ${env.DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Push to dockerhub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'docker-hub-cred-id', variable: 'DOCKER_PASSWORD')]) {
                        sh """echo \$DOCKER_PASSWORD | docker login -u ${env.DOCKER_USERNAME} --password-stdin"""
                        sh "docker push ${env.DOCKER_IMAGE}:latest"
                        sh "docker push ${env.DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                     kubeconfig(credentialsId: 'kube-config-cred-id', serverUrl: 'https://127.0.0.1:37525') {
                        sh "kubectl apply -f deployment.yaml -n ${env.K8S_NAMESPACE}"
                        sh "kubectl apply -f service.yaml -n ${env.K8S_NAMESPACE}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}