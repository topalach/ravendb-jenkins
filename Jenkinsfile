pipeline {
  agent any
  stages {

    stage('Print env') {
      steps {
        echo env.BRANCH
      }
    }

    stage('Clone repository') {
      when { branch env.BRANCH }

      steps {
          dir('src') {
            git url: env.REPOURL, branch: env.BRANCH
            echo 'Repository cloned successfully'
          }
      }
    }

    stage('Build') {
        steps {
            dir('src') {
                sh 'ls -al'
                sh 'pwsh ./build.ps1 -LinuxX64'
            }
        }
    }
  }
  environment {
    BRANCH = 'master'
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }
}