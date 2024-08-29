pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'cd SampleWeb mvn test'
            }
        }
        stage('Build') {
            steps {
                sh 'cd SampleWeb && mvn clean package'
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat_ID', path: '', url: 'http://52.204.181.202:8080/')], contextPath: 'webapp', war: '**/*.war'
            }
        }
    }
}
