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

                    def readPomVersion = readMavenPom file: 'pom.xml'
                    def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "myapp-snapshot":"myapp-release"
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
                      groupId: 'com.example', 
                      nexusUrl: '54.204.188.160:8081', 
                      nexusVersion: 'nexus3', 
                      protocol: 'http', 
                      repository: nexusRepo,
                      version:  "${readPomVersion.version}"
                }
            }
        }

    stage('Docker image build'){
        steps{
            script{
                sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                sh 'docker tag $JOB_NAME:v1.$BUILD_ID dockerdemo9/$JOB_NAME:v1.$BUILD_ID'
            }
        }
    }

    stage('Docker image push to docker hub'){
        steps{
            script{
                withCredentials([string(credentialsId: 'Docker_creds', variable: 'docker_creds')]) {
                    
                sh 'docker login -u dockerdemo9 -p ${docker_creds}'
                sh 'docker image push dockerdemo9/$JOB_NAME:v1.$BUILD_ID'
                }
            }
        }
    }

    }
}