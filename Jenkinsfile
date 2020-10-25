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
    	    }
    	}
    
        stage('Lint Cast Repo') {
            steps {
    	    	sh """
    	    	. .cast/bin/activate
    	    	pylint --disable=R,C,W1203 ./app.py
    	    	"""
    	    	sh 'echo "Linting finished"'
		sh 'hadolint Dockerfile'
		sh 'echo "Dockerfile ok"'
            }
        }        
        
        stage('Build Docker Image') {
	    steps {
		sh 'echo "Build Docker Image"'
		sh 'docker build --tag=lorberta/cast:v2 .'
	    }
	}
        
        stage('Push Docker Image') {
            steps {
                  withDockerRegistry([url: "", credentialsId: "lorberta"]) {
                      sh 'docker push lorberta/cast:v2'
                  }
            }
        }
        
	stage('Deploy App') {
	    steps {
        	script {
          	    sh 'kubectl apply -f kubernetes.yml'
          	    sh 'kubectl rollout status deployment cast'
        	}
	    }
	}        

    }
}
