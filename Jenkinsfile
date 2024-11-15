pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "romilbhai/spring-boot-app"
        K8S_NAMESPACE = "spring-boot-demo--namespace"
        DOCKER_CREDENTIALS_ID = 'docker-hub-cred-id' // Created in the Jenkins Credentials Security
        KUBECONFIG_CREDENTIALS_ID = 'kube-config-cred-id' // Created in the Jenkins Credentials Security
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
                    sh "docker build -t romilbhai/spring-boot-app:${env.BUILD_ID} ."
                    sh "docker tag romilbhai/spring-boot-app:${env.BUILD_ID} romilbhai/spring-boot-app:latest"
                }
            }
        }

        stage('Push to dockerhub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'docker-hub-cred-id', variable: 'DOCKER_PASSWORD')]) {
                    sh
                        """
                        echo \$DOCKER_PASSWORD | docker login -u huntercodexs --password-stdin
                        """
                    sh "docker push huntercodexs/spring-boot-demo:${env.BUILD_ID}"
                    sh "docker push huntercodexs/spring-boot-demo:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                     kubeconfig(credentialsId: 'kube-config-cred-id') {
                        sh 'kubectl apply -f deployment.yaml -n ${env.K8S_NAMESPACE}'
                        sh 'kubectl apply -f service.yaml -n ${env.K8S_NAMESPACE}'
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