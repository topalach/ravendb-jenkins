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

  // options {
  //   timeout(time: 300, unit: 'MINUTES')
  // }

  environment {
    repoUrl = 'https://github.com/topalach/ravendb.git'
    githubUser = 'topalach'
    repoName = 'ravendb'

    COMPlus_ReadyToRunExcludeList = 'System.Security.Cryptography.X509Certificates'
    Raven_Enable_Per_Test_Logging = 'true'
  }

  stages {

    stage ('Clone') {
      steps {
        dir ('ravendb') {
          git url: env.repoUrl, branch: env.ghprbSourceBranch
        }
      }
    }

    // stage ('CLA Signed') {
    //   steps {
    //     sh '''powershell -file pipelineScripts/claSigned.ps1'''
    //   }
    // }

    // stage ('Commit Message Conventions') {
    //   steps {
    //     script {
    //       try {
    //         sh '''powershell -file pipelineScripts/commitMessageConventions.ps1'''
    //         commentPullRequest("commit/message/conventions", "Commit message conventions were fulfilled", "SUCCESS")
    //       } catch (err) {
    //         commentPullRequest("commit/message/conventions", "Commit message conventions were not fulfilled", "FAILED")
    //       }
    //     }
    //   }
    // }

    // stage ('Commit Whitespace Conventions') {
    //   steps {
    //     dir ('ravendb') {
    //       script {
    //         try {
    //           sh '''powershell -file ../pipelineScripts/commitWhitespaceConventions.ps1'''
    //           commentPullRequest("commit/whitespace", "Commit whitespace conventions were fulfilled", "SUCCESS")
    //         } catch (err) {
    //           commentPullRequest("commit/whitespace", "Commit whitespace conventions were not fulfilled", "FAILED")  
    //         }
    //       }
    //     }
    //   }
    // }

    stage ('Tests') {
      steps {
        timeout(time: 30, unit: 'SECONDS') {

          dir ('ravendb') {

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

            script {
              nunit testResultsPattern: 'test/FastTests/testResults.xml', failIfNoResults: true

              if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE')
              {
                commentPullRequest("tests", "Fast Tests failed. Starting slow tests.", "FAILED")
              } else {
                commentPullRequest("tests", "Fast tests passed. Starting slow tests.", "PENDING")
              }
            }

            sh '''powershell -c "
              Push-Location \"test/SlowTests\"

              Try {
                dotnet xunit -configuration Release -nunit testResults.xml
              }
              Finally {
                Pop-Location
              }
              
              Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue
            "'''

            nunit testResultsPattern: 'test/SlowTests/testResults.xml', failIfNoResults: true
          }

        }
      }

      post {
        success {
          commentPullRequest("tests", "All tests passed.", "SUCCESS")
        }

        failure {
          commentPullRequest("tests", "Tests failed.", "FAILED")
        }

        aborted {
          commentPullRequest("tests", "Tests were aborted (perhaps because of a timeout).", "FAILED")
        }
      }
    }

  }
}