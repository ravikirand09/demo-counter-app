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
        stage('Static code analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-key'){
                    sh 'mvn clean package sonar:sonar'
                   }
                }
            }
        }
        stage('Quality gate'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-key'
                }
            }
        }
        stage('upload jar file to nexus'){
            steps{
                script{
                    nexusArtifactUploader artifacts:
                     [
                        [
                            artifactId: 'springboot',
                            classifier: '',
                            file: 'target/Uber.jar',
                            type: 'jar'
                        ]
                     ], 
                      credentialsId: 'nexus-auth',
                      groupId: 'ccom.example', 
                      nexusUrl: '54.204.188.160:8081', 
                      nexusVersion: 'nexus3', 
                      protocol: 'http', 
                      repository: 'myapp-release', 
                      version: '1.0.0'
                }
            }
        }

    }
}