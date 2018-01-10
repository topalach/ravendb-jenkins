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

  options {
    timeout(time: 600, unit: 'SECONDS')
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
        dir ('ravendb') {
          git url: env.repoUrl, branch: env.ghprbSourceBranch
        }
      }
    }

    stage ('CLA Signed') {
      steps {
        sh '''powershell -file pipelineScripts/claSigned.ps1'''
      }
    }

    stage ('Commit Message Conventions') {
      steps {
        script {
          try {
            sh '''powershell -file pipelineScripts/commitMessageConventions.ps1'''
            commentPullRequest("commit/message/conventions", "Commit message conventions were fulfilled", "SUCCESS")
          } catch (err) {
            commentPullRequest("commit/message/conventions", "Commit message conventions were not fulfilled", "FAILED")
          }
        }
      }
    }

    stage ('Commit Whitespace Conventions') {
      steps {
        dir ('ravendb') {
          script {
            try {
              sh '''powershell -file ../pipelineScripts/commitWhitespaceConventions.ps1'''
              commentPullRequest("commit/whitespace", "Commit whitespace conventions were fulfilled", "SUCCESS")
            } catch (err) {
              commentPullRequest("commit/whitespace", "Commit whitespace conventions were not fulfilled", "FAILED")  
            }
          }
        }
      }
    }

    stage ('Tests') {
      steps {
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
            echo '[LOG] build result before FIRST report: '
            echo currentBuild.result

            nunit testResultsPattern: 'test/FastTests/testResults.xml', failIfNoResults: true

            echo '[LOG] build result after FIRST report: '
            echo currentBuild.result

            if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE')
            {
              commentPullRequest("tests", "Fast Tests failed", "FAILED")
              currentBuild.result = 'SUCCESS'

              echo '[LOG] reported FIRST test failure'
            }
          }

          echo '[LOG] continuing Tests stage after results analysis'
          echo '[LOG] build result: '
          echo currentBuild.result



          // testing purposes only
          script {
            echo '[LOG] reporting test results AGAIN'
            echo '[LOG] build result before SECOND report: '
            echo currentBuild.result
            
            nunit testResultsPattern: 'test/FastTests/testResults.xml', failIfNoResults: true

            echo '[LOG] build result after SECOND report: '
            echo currentBuild.result

            if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE')
            {
              commentPullRequest("tests", "Fast Tests failed - second report", "FAILED")

              echo '[LOG] reported SECOND test failure'
            }
          }

          echo '[LOG] continuing Tests stage after SECOND results analysis'

          // commentPullRequest("tests", "Fast tests finished. Starting slow tests.", "PENDING")

          // sh '''powershell -c "
          //   Push-Location \"test/SlowTests\"

          // Try {
          //   dotnet xunit -configuration Release -nunit testResults.xml
          // }
          // Finally {
          //   Pop-Location
          // }
            
          //   Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue
          // "'''

          // step([$class: 'NUnitPublisher', testResultsPattern: 'test/SlowTests/testResults.xml', debug: false, 
          //   keepJUnitReports: true, skipJUnitArchiver:false, failIfNoResults: true])

        }
      }

      post {
        success {
          commentPullRequest("tests", "All tests succeeded", "SUCCESS")
        }

        // failure {
        //   commentPullRequest("tests", "Tests failed", "FAILED")
        // }
      }
    }

  }
}