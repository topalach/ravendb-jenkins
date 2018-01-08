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

    COMPlus_ReadyToRunExcludeList = 'System.Security.Cryptography.X509Certificates'
    Raven_Enable_Per_Test_Logging = 'true'
  }

  stages {

    stage ('Clone') {
      steps {
        git url: env.repoUrl, branch: env.ghprbSourceBranch
      }
    }

    stage ('Tests') {
      steps {
        sh '''powershell -c "
          dotnet restore
          Copy-Item \"test/xunit.runner.CI.json\" \"test/xunit.runner.json\" -Force
        "'''

        commentPullRequest("tests", "Fast tests started", "PENDING")

        sh '''powershell -c "
          Push-Location \"test/FastTests\"

          Try {
            dotnet xunit -configuration Release -nunit testResults.xml
          }
          Finally {
            Pop-Location
          }
        "'''

        step([$class: 'NUnitPublisher', testResultsPattern: 'test/FastTests/testResults.xml', debug: false, 
          keepJUnitReports: true, skipJUnitArchiver:false, failIfNoResults: true])

        // commentPullRequest("tests", "Fast tests finished. Starting slow tests.", "PENDING")

        // sh '''powershell -c "
        //   Push-Location \"test/SlowTests\"

        // Try {
        //   dotnet xunit -configuration Release
        // }
        // Finally {
        //   Pop-Location
        // }
          
        //   Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue
        // "'''


        // sh 'dotnet restore'

        // sh 'powershell -c "Copy-Item \"test/xunit.runner.CI.json\" \"test/xunit.runner.json\" -Force"'
        // echo '[LOG] Copy-Item done'

        // sh 'powershell -c "Push-Location \"test/FastTests\""'
        // echo '[LOG] Push-Location done'
        // sh 'dotnet xunit -configuration Release'
        // echo '[LOG] dotnet xunit done'
        // sh 'powershell -c "Pop-Location"'
        // echo '[LOG] Pop-Location done'

        // sh 'powershell -c "Push-Location \"test/SlowTests\""'
        // echo '[LOG] Push-Location done'
        // sh 'dotnet xunit -configuration Release'
        // echo '[LOG] dotnet xunit 2 done'
        // sh 'powershell -c "Pop-Location"'
        // echo '[LOG] Pop-Location done'

        // sh 'powershell -c "Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue"'
        // echo '[LOG] Stop-Process done'
      }

      post {
        success {
          commentPullRequest("tests", "All tests succeeded", "SUCCESS")
          echo '[LOG] All tests succeeded'
        }

        failure {
          commentPullRequest("tests", "Tests failed", "FAILED")
          echo '[LOG] All tests failed'
        }
      }
    }

  }
}