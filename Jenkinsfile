pipeline {
  agent any

  environment {
    BRANCH = 'v4.0'
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }

  stages {

    stage('Print env') {
      steps {
        echo env.BRANCH
        echo env.ghprbSourceBranch
      }
    }

    stage ('Clone') {
        steps {
            git url: env.REPOURL, branch: env.BRANCH
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