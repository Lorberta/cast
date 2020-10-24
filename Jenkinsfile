pipeline {
    agent any
    stages {
        stage('Lint Cast Repo') {
            steps {
		sh "echo 'Lint check Dockerfile'"
		sh 'hadolint Dockerfile'
		sh "echo 'Performing Python Lint on web.py'"
		sh 'pylint --disable=R,C,W1203 ./web.py'
		sh 'echo "Linting finished"'
            }
        }
        
        stage ('Cloning Cast Repo') {
            steps {
		git 'https://github.com/lorberta/cast.git'
		sh "echo 'Cloning complete'"
            }
        }
        
        stage('Build Docker Image') {
	    steps {
		sh "echo 'Build Docker Image'"
		sh 'docker build --tag=lorberta/cast .'
	    }
	}
	
#	stage('Security Scan Image') {
#	    steps {
#		sh "echo 'Security Scan with Aqua MicroScanner'"
#		aquaMicroscanner(imageName: "alpine:latest", notCompliesCmd: "exit 1", onDisallowed: "fail", outputFormat: "html")
#	    }
#	}

	stage('Push Image') {
            steps {
                script {
                    with dockerpath=lorberta/cast {
                    	sh 'echo "Docker ID and Image: $dockerpath"'
                    	sh 'docker login --username=lorberta'
                    	sh 'docker tag $dockerpath lorberta/cast:v1'
                    	sh 'docker push lorberta/cast:v1'
                    }
                }
            }
        }
        
        stage('Deployment') {
            steps{
		echo 'Start Deployment to AWS'
		withAWS(region:'us-west-2', credentials:'cast') {
		    sh 'echo "AWS credentials are working"'
		    sh "kubectl apply -f deployment.yml"
		    sh "sleep 2m"
		    sh "kubectl rollout status deployment.apps/cast"
		    sh "kubectl get deployment"
		    sh "kubectl get pods"
                  }
              }
        }

        stage('Upload to AWS rolling') {
            steps {
		withAWS(region:'us-west-2', credentials:'cast') {
		sh 'echo "AWS credentials are working"'
		sh 'kubectl set image deployments/cast-deployment cast=lorberta/cast:latest"
		sh 'echo "Done"'
		}
            }
        }
    }
}
