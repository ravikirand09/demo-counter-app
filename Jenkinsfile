pipeline{
    agent any
    stages{
        stage('Git checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/ravikirand09/demo-counter-app.git'
            }
        }
        stage('unit test'){
            steps{
                sh 'mvn test'
            }
        }
        stage('integration test'){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Static code analysis'){
            steps{
                withSonarQubeEnv(credentialsId: 'sonar-key'){
                    sh 'mvn clean package sonar:sonar'
             }
            }
        }

    }
}