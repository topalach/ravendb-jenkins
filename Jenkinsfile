pipeline {
  agent any
  stages {
    stage('Print env') {
      steps {
        echo env.BRANCH
      }
    }
    stage('Clone repository') {
      when {
        branch env.BRANCH
      }
      steps {
        git(url: env.REPOURL, branch: env.BRANCH)
        echo 'Repository cloned successfully'
      }
    }
    stage('Build') {
      steps {
        powershell './build.ps1 -Winx64'
      }
    }
  }
  environment {
    BRANCH = 'master'
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }
}