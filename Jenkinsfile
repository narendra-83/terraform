pipeline {
    agent any

    // NO 'tools' BLOCK HERE

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-terraform-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-terraform-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1' // Match your Terraform provider region
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/narendra-83/terraform.git'
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
