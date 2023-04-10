pipeline{
    
    agent any 
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/Rohithhosoklu/demo-counter-app-java.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'SonarQube_Token') {
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube_Token' 
                    }
                }
            }
               stage('Upload JAR file to nexus')
            {
                steps{
                        script{
                                def readPomVersion = readMavenPom file: 'pom.xml'
                                def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "Javaapp-snapshot" : "Javaapp-relase"
                                nexusArtifactUploader artifacts: 
                                    [
                                        [
                                            artifactId: 'springboot', 
                                            classifier: '', file: 'target/Uber.jar', 
                                            type: 'jar'
                                        ]
                                    ], 
                                    credentialsId: 'netus-auth', 
                                            groupId: 'com.example', 
                                            nexusUrl: '192.168.1.249:8081',  
                                            nexusVersion: 'nexus3', 
                                            protocol: 'http', 
                                            repository: nexusRepo, 
                                            version: "${readPomVersion.version}"
                              }    
                     }
            }
            stage('Docker Image Build')
            {
                steps
                {
                    script
                    {
                        sh 'docker image build -t $JOB_NAME:$BUILD_ID .'
                        sh 'docker run -d -p 80:80 --name javaapp $JOB_NAME:$BUILD_ID'
                    }
                }
            }
        }
        
}
