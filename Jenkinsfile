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
        commentPullRequest("tests", "tests passed", "PENDING")

        // powershell '''
        //   dotnet restore

        //   Copy-Item "test/xunit.runner.CI.json" "test/xunit.runner.json" -Force

        //   Push-Location "test/FastTests"
        //   dotnet xunit -configuration Release
        //   Pop-Location

        //   Push-Location "test/SlowTests"
        //   dotnet xunit -configuration Release
        //   Pop-Location
        // '''


        sh 'dotnet restore'

        sh 'powershell -c "Copy-Item \"test/xunit.runner.CI.json\" \"test/xunit.runner.json\" -Force"'
        echo '[LOG] Copy-Item done'

        sh 'powershell -c "Push-Location \"test/FastTests\""'
        echo '[LOG] Push-Location done'
        sh 'dotnet xunit -configuration Release'
        echo '[LOG] dotnet xunit done'
        sh 'powershell -c "Pop-Location"'
        echo '[LOG] Pop-Location done'

        sh 'powershell -c "Push-Location \"test/SlowTests\""'
        echo '[LOG] Push-Location done'
        sh 'dotnet xunit -configuration Release'
        echo '[LOG] dotnet xunit 2 done'
        sh 'powershell -c "Pop-Location"'
        echo '[LOG] Pop-Location done'

        sh 'powershell -c "Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue"'
        echo '[LOG] Stop-Process done'

        commentPullRequest("tests", "tests passed", "SUCCESS")
      }
    }

  }
}