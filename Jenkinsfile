pipeline {
    agent any

    tools {
        // Correct way to specify a configured Terraform tool named "Default Terraform"
        // This 'terraform' refers to the tool type, and 'Default Terraform' refers to the name of the configuration.
        // It's usually just:
        // terraform 'Default Terraform' // if Terraform is directly recognized as a tool type and you're referencing an instance
        // But the error suggests the outer 'terraform' is the type.
        // So, the most common correct way for a *single* Terraform installation, assuming its name is "Default Terraform" is:

        // Option A: Simplest if "Default Terraform" is the ONLY Terraform tool configured
        terraform 'Default Terraform' // This should work if "Default Terraform" is truly the name
                                    // and 'terraform' is the recognized tool type.

        // If the above still fails, try this (less common for terraform directly):
        // tool name: 'Default Terraform', type: 'terraform'
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
                    // Make sure this URL is correct and matches your repo
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
