pipeline {
    agent any
    environment {
        BRANCH = 'master'
        REPOURL = 'https://github.com/topalach/ravendb.git'
    }
    stages {
        stage('Clone repository') {
            when {
                branch '${BRANCH}'
            }
            
            steps {
                git(url: '${REPOURL}', branch: '${BRANCH}')
                echo 'Repository cloned successfully'
            }
        }
    }
}
