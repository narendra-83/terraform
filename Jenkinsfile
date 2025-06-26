pipeline {
    agent any

    tools {
        terraform 'Default Terraform'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-terraform-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-terraform-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/your-username/terraform-aws-vpc-ec2.git' // REPLACE WITH YOUR ACTUAL GIT REPO URL
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            deleteDir()
        }
        success {
            echo 'Terraform deployment successful!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}
