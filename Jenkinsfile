pipeline {
  agent any

  environment {
    repoUrl = 'https://github.com/topalach/ravendb.git'
    githubUser = 'topalach'
    repoName = 'ravendb'
    // jenkinsCredentialsId = '2c3cb5b0-2e01-4746-a8f9-0cc51f8777eb'
    jenkinsCredentialsId = 'github-ravendb'
  }

  stages {

    stage ('Clone') {
        steps {
          git url: env.repoUrl, branch: env.ghprbSourceBranch
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
        echo 'started testing'

        step([
            $class: "GitHubCommitStatusSetter",
            reposSource: [$class: "ManuallyEnteredRepositorySource", url: env.repoUrl],
            contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "commit/message/conventions"],
            errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
            statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: "custom message", state: "SUCESS"]] ]
        ]);

        // githubNotify status: 'SUCCESS',
        //   description: 'Convention tests passed',
        //   context: 'commit/message/conventions',
        //   repo: env.repoName,
        //   credentialsId: env.jenkinsCredentialsId,
        //   account: env.githubUser,
        //   sha: env.sha1

        echo 'finished testing'
      }
    }

  }
}