pipeline {
    agent any
    stages {
    
    	stage('Preparing Venv') {
    	    steps {
    	    	sh """
    	    	python3 -m venv .cast
    	    	. .cast/bin/activate
    	    	pip install -r requirements.txt
    	    	"""
    	    	sh "echo 'Lint check Dockerfile'"
		sh 'hadolint Dockerfile'
		sh "echo 'Performing Python Lint on app.py'"
		sh 'pylint --disable=R,C,W1203 ./app.py'
		sh 'echo "Linting finished"'
		sh '. .cast/bin/activate'
    	    }
    	}
    
        stage('Lint Cast Repo') {
            steps {
		sh "echo 'Lint check Dockerfile'"
		sh 'hadolint Dockerfile'
		sh "echo 'Performing Python Lint on app.py'"
		sh 'pylint --disable=R,C,W1203 ./app.py'
		sh 'echo "Linting finished"'
		sh '. .cast/bin/activate'
            }
        }        
        
        stage('Build Docker Image') {
	    steps {
		sh "echo 'Build Docker Image'"
		sh 'docker build --tag=lorberta/cast .'
	    }
	}
        
        stage('Push Docker Image') {
            steps {
                  withDockerRegistry([url: "", credentialsId: "lorberta"]) {
                      sh 'docker push lorberta/cast'
                  }
            }
        }
        
	stage('Deploy App') {
	    steps {
        	script {
          	    kubernetesDeploy(configs: "deployment.yml", kubeconfigId: "MINIKUBECONFIG")
        	}
	    }
	}        

    }
}
