pipeline {
  agent any

  environment {
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }

  stages {

    stage('Print env') {
      steps {
      }
    }

    stage ('Clone') {
        steps {
          echo 'Cloning PR source branch: ${env.ghprbSourceBranch}'
          git url: env.REPOURL, branch: env.ghprbSourceBranch
        }
    }

    // stage('Build') {
    //     steps {
    //         dir('src/Raven.Server') {
    //             sh 'dotnet build'
    //         }
    //   }
    // }



  }
}