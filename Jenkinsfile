pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "koronet/webserver"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    sh 'docker run --rm $DOCKER_IMAGE pytest'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/') {
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
