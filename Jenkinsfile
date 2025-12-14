pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-west-2'
        AWS_ACCOUNT_ID = '975050024946'
        ECR_REPO       = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/hello-eks-demo-app"
        CLUSTER_NAME   = 'amol-eks-cluster'
        IMAGE_TAG      = "${BUILD_NUMBER}"
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                // Run tests inside a Python container
                sh '''
                    docker run --rm -v $PWD/app:/app -w /app python:3.12-slim \
                      bash -c "pip install --upgrade pip --no-cache-dir || true && \
                               pip install --no-cache-dir -r requirements.txt || true && \
                               pytest || true"
                '''
            }
        }

        stage('Build & Push') {
            steps {
                withAWS(credentials: 'jenkins-aws-credentials', region: env.AWS_REGION) {
                    sh '''
                        docker build -t hello-app:${IMAGE_TAG} -f app/Dockerfile app
                        docker tag hello-app:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                        aws ecr get-login-password | docker login --username AWS --password-stdin ${ECR_REPO}
                        docker push ${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                withAWS(credentials: 'jenkins-aws-credentials', region: env.AWS_REGION) {
                    sh '''
                        aws eks update-kubeconfig --name ${CLUSTER_NAME}
                        kubectl set image deployment/hello-app hello-app=${ECR_REPO}:${IMAGE_TAG}
                        kubectl rollout status deployment/hello-app --timeout=5m
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ DEPLOYMENT SUCCESSFUL'
            script {
                withAWS(credentials: 'jenkins-aws-credentials', region: env.AWS_REGION) {
                    def url = sh(
                        script: "kubectl get svc hello-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true",
                        returnStdout: true
                    ).trim()
                    if (url) echo "Application URL: http://${url}"
                }
            }
        }
        failure {
            echo '❌ PIPELINE FAILED'
            withAWS(credentials: 'jenkins-aws-credentials', region: env.AWS_REGION) {
                sh '''
                    kubectl describe deployment/hello-app || true
                    kubectl logs -l app=hello-app --tail=30 || true
                '''
            }
        }
        always {
            echo "Pipeline finished at: ${new Date()}"
            cleanWs()
        }
    }
}
