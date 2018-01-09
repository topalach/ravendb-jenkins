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
        git url: env.repoUrl, branch: env.ghprbSourceBranch
      }
    }

    stage ('Pull Request Checks') {
      parallel {
        // stage ('Tests') {
        //   steps {
        //     sh '''powershell -c "
        //       dotnet restore
        //       Copy-Item \"test/xunit.runner.CI.json\" \"test/xunit.runner.json\" -Force
        //     "'''

        //     commentPullRequest("tests", "Fast tests started", "PENDING")

        //     sh '''powershell -c "
        //       Push-Location \"test/FastTests\"

        //       Try {
        //         dotnet xunit -configuration Release -nunit testResults.xml
        //       }
        //       Finally {
        //         Pop-Location
        //       }
        //     "'''

        //     script {
        //       nunit testResultsPattern: 'test/FastTests/testResults.xml', failIfNoResults: true

        //       if (currentBuild.result == 'UNSTABLE' || currentBuild.result == 'FAILURE')
        //       {
        //         // commentPullRequest("tests", "Fast Tests failed", "FAILED")
        //         sh 'exit 1'
        //       }
        //     }

        //     echo '[LOG] continuing Tests stage after results analysis'

        //     // commentPullRequest("tests", "Fast tests finished. Starting slow tests.", "PENDING")

        //     // sh '''powershell -c "
        //     //   Push-Location \"test/SlowTests\"

        //     // Try {
        //     //   dotnet xunit -configuration Release -nunit testResults.xml
        //     // }
        //     // Finally {
        //     //   Pop-Location
        //     // }
              
        //     //   Stop-Process -ProcessName dotnet -ErrorAction SilentlyContinue
        //     // "'''

        //     // step([$class: 'NUnitPublisher', testResultsPattern: 'test/SlowTests/testResults.xml', debug: false, 
        //     //   keepJUnitReports: true, skipJUnitArchiver:false, failIfNoResults: true])
        //   }

        //   post {
        //     success {
        //       commentPullRequest("tests", "All tests succeeded", "SUCCESS")
        //     }

        //     failure {
        //       commentPullRequest("tests", "Tests failed", "FAILED")
        //     }
        //   }
        // }

        stage ('Commit Message Conventions') {
          steps {
            sh '''powershell -c "
              \$url = \"https://api.github.com/repos/ravendb/ravendb/pulls/${env.ghprbSourceBranch}/commits\"

              \$allCommits = Invoke-RestMethod -Method Get -Uri \$url
              \$allMatched = \$TRUE

              Foreach (\$commit in \$allCommits) 
              {
                  \$message = \$commit.commit.message
                  Write-Host \"Processing message \'\$message\'\"

                  \$loweredMessage = \$message.ToLowerInvariant()
                  \$match = \$loweredMessage -match \"ravendb-\\d+\" -or \$loweredMessage -match \"rdoc-\\d+\" -or \$loweredMessage -match \"rdbqa-\\d+\" -or \$loweredMessage -match \"rdbc-\\d+\" -or \$loweredMessage -match \"merge branch\" -or \$loweredMessage -match \"merge remote\" -or \$loweredMessage -match \"merge pull request\"
                
                if (\$match -eq \$FALSE) 
                {
                  \$allMatched = \$FALSE
                  Write-Host \"Commit message \'$message\' does not contain issue #\"
                }
              }

              if (\$allMatched -eq \$FALSE)
              {
                throw \"Not all commit messages contain issue #\"
              }
            "'''
          }

          post {
            success {
              commentPullRequest("commit/message/conventions", "Commit message conventions were fulfilled", "SUCCESS")
            }

            failure {
              commentPullRequest("commit/message/conventions", "Commit message conventions were not fulfilled", "FAILED")
            }
          }
        }
      }      
    }

  }
}