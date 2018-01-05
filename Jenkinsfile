def commentPullRequest(String context, String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      commitShaSource: [$class: "ManuallyEnteredShaSource", sha: env.ghprbActualCommit],
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: env.repoUrl],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "FAILED"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

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

        // step([
        //     $class: "GitHubCommitStatusSetter",
        //     commitShaSource: [$class: "ManuallyEnteredShaSource", sha: env.ghprbActualCommit],
        //     reposSource: [$class: "ManuallyEnteredRepositorySource", url: env.repoUrl],
        //     contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "commit/message/conventions"],
        //     errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "FAILED"]],
        //     statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: "custom message", state: "SUCCESS"]] ]
        // ]);

        commentPullRequest("commit/message/conventions", "custom message", "SUCCESS")

        // sh 'curl -H "Content-Type: application/json" -X POST -d \'{"state":"success","description":"desc","context":"commit/message/conventions"}\' https://api.github.com/repos/topalach/statuses/$ghprbActualCommit'

        // githubNotify status: 'SUCCESS',
        //   description: 'Convention tests passed',
        //   context: 'commit/message/conventions',
        //   repo: env.repoName,
        //   credentialsId: env.jenkinsCredentialsId,
        //   account: env.githubUser,
        //   sha: env.ghprbActualCommit

        echo 'finished testing'
      }
    }

  }
}