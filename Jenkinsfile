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
  agent {
    node { label 'windows' }
  }

  environment {
    repoUrl = 'https://github.com/topalach/ravendb.git'
    githubUser = 'topalach'
    repoName = 'ravendb'
    jenkinsCredentialsId = 'github-ravendb'
  }

  stages {

    stage ('Clone') {
      steps {
        git url: env.repoUrl, branch: env.ghprbSourceBranch
      }
    }

    stage ('Tests') {
      steps {
        sh 'dotnet restore'

        powershell 'Copy-Item "test\xunit.runner.CI.json" "test\xunit.runner.json" -Force'

        powershell 'Push-Location "test\FastTests"'
        sh 'dotnet xunit -configuration Release'
        powershell 'Pop-Location'

        powershell 'Push-Location "test\SlowTests"'
        sh 'dotnet xunit -configuration Release'
        powershell 'Pop-Location'

        commentPullRequest("tests", "tests passed", "SUCCESS")
      }
    }

  }
}