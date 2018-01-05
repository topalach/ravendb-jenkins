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

    stage('Build') {
      steps {
        dir('src/Raven.Server') {
          sh 'dotnet build'
        }
      }
    }

    stage('Test') {
      steps {
        setGitHubPullRequestStatus context: 'commit/message/conventions', state: 'PENDING'
        echo 'started testing'
        setGitHubPullRequestStatus context: 'commit/message/conventions', state: 'SUCCESS'
      }
    }

  }
}