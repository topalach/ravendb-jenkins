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
        git 'https://github.com/topalach/ravendb.git'
      }
    }

    stage('Build') {
        steps {
            sh 'pwd'
            sh 'ls -al'
            sh 'pwsh ./build.ps1 -LinuxX64'
        }
    }
  }
  environment {
    BRANCH = 'master'
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }
}