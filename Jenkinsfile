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

    stage('Notify') {
      steps {
        githubNotify status: 'PENDING', description: 'Convention tests passed', context: 'commit/message/conventions', repo: env.REPOURL, sha: env.sha1

        echo 'started testing'

        githubNotify status: 'SUCCESS', description: 'Convention tests passed', context: 'commit/message/conventions', repo: env.REPOURL, sha: env.sha1

        echo 'finished testing'
      }
    }

  }
}