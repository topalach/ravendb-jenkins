pipeline {
  agent any

  environment {
    BRANCH = 'master'
    REPOURL = 'https://github.com/topalach/ravendb.git'
  }

  stages {

    stage('Print env') {
      steps {
        echo env.BRANCH
      }
    }

    stage('Clone and build') {
      when { branch env.BRANCH }

      steps {
        dir('src')
        {
            git url: env.REPOURL, branch: env.BRANCH
            sh 'pwd'
            sh 'ls -al'
            sh 'pwsh ./build.ps1 -LinuxX64'    
        }
      }
    }

  }
}