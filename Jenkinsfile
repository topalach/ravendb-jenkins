pipeline {
    agent any
    environment {
        BRANCH = 'master'
        REPOURL = 'https://github.com/topalach/ravendb.git'
    }
    stages {
        stage('Print env') {
            steps {
                echo env.BRANCH
            }
        }

        stage('Clone repository') {
            when {
                branch env.BRANCH
            }

            steps {
                git(url: env.REPOURL, branch: env.BRANCH)
                echo 'Repository cloned successfully'
            }
        }
    }
}
