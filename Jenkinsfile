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
                    kubeconfig(
                    caCertificate: """
                    -----BEGIN CERTIFICATE-----
                    MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
                    a3ViZUNBMB4XDTI0MTExNjE4MTEyNVoXDTM0MTExNTE4MTEyNVowFTETMBEGA1UE
                    AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJny
                    Pzn2BHxfrE7c4f/RO+S7qAtkVAxgdi5WuqjyuL5QHOhujh7JXwl1RQlaTarQ+hSw
                    K+8PKUg+Wlt8HWUWAku/rb8Nc/jEVmYEMifgd3slAZWIdz7EYbKJJpKbc7lcJIdW
                    v4AWHGd0WW1aG3/MBdKuWpjT88OiZ7xkeL6KrEzfmSLPCPT3/jsbJo4bwi+mNbZL
                    NAI2U6dWhu3e7ojIuCAVQ1vT7SlP9yj4NMATRNkbb5gWQohCpRn/ZZI90O/EbV3J
                    47HHopiQwdt9/I9MfZTvWQvxjr2zvojknVD4PteSpje2F7HwHjHV2Mzi6DtsolWW
                    xMy/emPnsG3ZMm8nY8cCAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
                    MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
                    BBS2k2Lmj+/7CvCBzKLNffR0r9Nj3DANBgkqhkiG9w0BAQsFAAOCAQEAJFH4pot4
                    7rTrjI52HQlg5JbmYAe+StduPVtP2qzhkyckQ4jTVMzJ9qYnTu/44mD3NQoTJ3LE
                    H5IfEFYmQGCsa/l4PYXXP5tjNVDOfeKY/F1zEK3tGsS5lH0r0kzT1wEJYk8XlHBZ
                    cgX7eq5ChEGT7OqeWGTWRqSlfU3nvVLk7h79+Mc4Kf8B58OMjGsTT+bNWsJ3sI7w
                    s+h2vIUbV1dLxmwSSbcsYq4p9qbqeKOfkkWhTJ8+XmH16EkDh2aQ4cmld4hnbIor
                    Runw8h12/dmNKlUnpe5/oXHA7U9WrPFzmIc00LwvD2QksoG9czmr5CatUp2ThBdd
                    CrOGb6WwnuyKaA==
                    -----END CERTIFICATE-----
                    """,
                    credentialsId: 'minikube-config-cacert',
                    serverUrl: 'http://127.0.0.1:38327')
                    {
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