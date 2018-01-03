pipeline {
    agent any
    environment {
        BRANCH = 'master'
        REPOURL = 'https://github.com/topalach/ravendb.git'
    }
    stages {
        when {
            branch '${BRANCH}'
        }
        stage('Clone repository') {
            steps {
                git(url: '${REPOURL}', branch: '${BRANCH}')
                echo 'Repository cloned successfully'
            }
        }
    }
}
