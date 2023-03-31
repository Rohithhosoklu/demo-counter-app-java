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
                    
                    withSonarQubeEnv(credentialsId: 'sonar-auth-key') {
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonar-auth-key' 
                    }
                }
            }
               stage('Upload JAR file to nexus')
            {
                steps{
                        script{
                                def readPomVersion = readMavenPom file: 'pom.xml'
                                def nexusRepo = readMavenPom.version.endsWith("SNAPSHOT") ? "Javaapp-snapshot" : "Javaapp-relase"
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
                                            nexusUrl: '192.168.1.180:8081',  
                                            nexusVersion: 'nexus3', 
                                            protocol: 'http', 
                                            repository: nexusRepo, 
                                            version: "${readPomVersion.version}"
                              }    
                     }
            }
        }
        
}
