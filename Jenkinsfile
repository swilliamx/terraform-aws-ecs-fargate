// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: ocean
  containers:
  - name: ansible
    image: swilliamx/ansible
    command: ['cat']
    tty: true
'''
        }
    }     
    stages {
        stage('TF Plan') {
          steps {
            container('ansible') {
              sh '''   
              aws sts assume-role \
                --role-arn arn:aws:iam::333333333333333333333:role/OCEAN_CRMS_ASSIGN_IAM_Role \
                --role-session-name session \
                > /tmp/assume-role.json
              cat > .aws-creds <<EOF
[default]
aws_access_key_id: $(jq -r .Credentials.AccessKeyId /tmp/assume-role.json)
aws_secret_access_key: $(jq -r .Credentials.SecretAccessKey /tmp/assume-role.json)
aws_session_token: $(jq -r .Credentials.SessionToken /tmp/assume-role.json)
EOF
              mkdir -p $HOME/.aws
              cp -v .aws-creds $HOME/.aws/credentials
              cp -v .aws-creds $HOME/.aws/aws_keys
              sed -i '1d' $HOME/.aws/aws_keys
              unset AWS_WEB_IDENTITY_TOKEN_FILE
              terraform init
              terraform plan  -var-file=environments/dev/dev.tfvars
              '''
            }
          }
        }

        stage('TF Apply') {
          steps {
            container('ansible') {
              sh '''   
              aws sts assume-role \
                --role-arn arn:aws:iam::245877399979:role/OCEAN_CRMS_ASSIGN_IAM_Role \
                --role-session-name session \
                > /tmp/assume-role.json
              cat > .aws-creds <<EOF
[default]
aws_access_key_id: $(jq -r .Credentials.AccessKeyId /tmp/assume-role.json)
aws_secret_access_key: $(jq -r .Credentials.SecretAccessKey /tmp/assume-role.json)
aws_session_token: $(jq -r .Credentials.SessionToken /tmp/assume-role.json)
EOF
              mkdir -p $HOME/.aws
              cp -v .aws-creds $HOME/.aws/credentials
              cp -v .aws-creds $HOME/.aws/aws_keys
              sed -i '1d' $HOME/.aws/aws_keys
              unset AWS_WEB_IDENTITY_TOKEN_FILE
              terraform apply -var-file=environments/dev/dev.tfvars -auto-approve
              '''
            }
          }
        }

        stage('Approval') {
           steps {
             script {
               def userInput = input(id: 'confirm', message: 'Destroy Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Destroy terraform', name: 'confirm'] ])
             }
           }
        }

        stage('TF Destroy') {
          steps {
            container('ansible') {
              sh '''   
              aws sts assume-role \
                --role-arn arn:aws:iam::333333333333333333333:role/OCEAN_CRMS_ASSIGN_IAM_Role \
                --role-session-name session \
                > /tmp/assume-role.json
              cat > .aws-creds <<EOF
[default]
aws_access_key_id: $(jq -r .Credentials.AccessKeyId /tmp/assume-role.json)
aws_secret_access_key: $(jq -r .Credentials.SecretAccessKey /tmp/assume-role.json)
aws_session_token: $(jq -r .Credentials.SessionToken /tmp/assume-role.json)
EOF
              mkdir -p $HOME/.aws
              cp -v .aws-creds $HOME/.aws/credentials
              cp -v .aws-creds $HOME/.aws/aws_keys
              sed -i '1d' $HOME/.aws/aws_keys
              unset AWS_WEB_IDENTITY_TOKEN_FILE
              terraform destroy -var-file=environments/dev/dev.tfvars
              '''
            }
          }
        }  
    }
}
