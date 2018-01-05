pipeline {
  agent any

  environment {
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }

  stages {

    stage ('Clone') {
        steps {
          git url: env.REPOURL, branch: env.ghprbSourceBranch
        }
    }

    // stage('Build') {
    //   steps {
    //     dir('src/Raven.Server') {
    //       sh 'dotnet build'
    //     }
    //   }
    // }

    stage('commit/message/conventions') {
      steps {
        echo 'started testing'
      }
    }

  }
}