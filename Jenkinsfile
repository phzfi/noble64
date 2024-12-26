def CHANGELOG
def SLACK_CHANNEL

//Note! To get Multibranch pipeline to work, you need to use http -endpoint, and "Git.in.phz.fi readonly access" -key
//Declarative pipeline example for multibranch pipeline
pipeline {
  agent { label 'master' }

  environment {
    PROJECT_NAME = "noble64"
    //the idea is that the team is full stack (meaning able to fix also CI issues), values high quality,
    //and is able and willing to fix errors on CI immediately, receiving notifications on project channel
    SLACK_CHANNEL = "#devops"

    //Multibranch pipeline
    BUILD_ENV = [master: 'prod', develop: 'stg'].get(env.BRANCH_NAME, 'dev')
    VERSION = "${currentBuild.id}"
  }

  options {
    //colors
    ansiColor('xterm')
    //set default pipeline timeout to 3hours if there is a jam, it will abort automatically
    timeout(time: 180, unit: 'MINUTES')
  }

  triggers {
    cron('H 01 8 */2 *')
  }

  stages {
    stage("Prepare") {
      steps {
        //prevent Jenkins wrong branch checkout failure
        //see https://stackoverflow.com/questions/44928459/is-it-possible-to-rename-default-declarative-checkout-scm-step
        checkout scm

        //If building custom branch, the BUILD_ENV setting above returns null, revert to dev
        script {
          if (BUILD_ENV == null) {
            BUILD_ENV = 'dev'
          }
        }

        //parse CHANGELOG
        script {
          def changeLogSets = currentBuild.rawBuild.changeSets
          CHANGELOG = ""
          for (int i = 0; i < changeLogSets.size(); i++) {
            def entries = changeLogSets[i].items
            for (int j = 0; j < entries.length; j++) {
              def entry = entries[j]
              CHANGELOG = CHANGELOG + "${entry.author}: ${entry.msg}\n"
            }
          }
          //prevent double builds, check if changelog is empty, skip
          if (CHANGELOG && CHANGELOG.trim().length() == 0) {
            currentBuild.result = 'SUCCESS'
            return
          }
        }
        echo "Release Notes:\n${CHANGELOG}"
      }
    }

    stage("Clean") {
      steps {
        script {
          sh "./down.sh > /dev/null 2>&1 || true"
          sh "./clean.sh > /dev/null 2>&1 || true"
        }
      }
    }

    stage("Provision") {
      steps {
        timeout(time: 300, unit: 'MINUTES') {
          sh script: "vagrant up", returnStatus: true
          sh script: "vagrant up --provision", returnStatus: true
          sh script: "vagrant up --provision", returnStatus: true
        }
      }
    }

    stage("Build") {
      steps {
        script {
          currentBuild.result = hudson.model.Result.SUCCESS.toString()
          if (currentBuild.result=='SUCCESS') {
            sh "./build.sh ${BUILD_ENV} ${VERSION}"
          } else {
            echo "FAIL: Not deploying because currentBuild.result = ${currentBuild.result}"
          }
        }
      }
    }

    stage("Deploy") {
      steps {
        withCredentials([
          [$class: 'UsernamePasswordMultiBinding', credentialsId: 'VAGRANT_CLOUD', usernameVariable: 'VAGRANT_CLOUD_USERNAME', passwordVariable: 'VAGRANT_CLOUD_PASSWORD']
        ]) {
          script {
            currentBuild.result = hudson.model.Result.SUCCESS.toString()
            if (currentBuild.result=='SUCCESS') {
              sh "./deploy.sh ${BUILD_ENV} ${VERSION}"
            } else {
              echo "FAIL: Not deploying because currentBuild.result = ${currentBuild.result}"
            }
          }
        }
      }
    }
  }

  post {
    always {
      script {
        //See https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/how-to-troubleshoot-hudson-filepath-is-missing-in-pipeline-run
        if (getContext(hudson.FilePath)) {
          sh "./clean.sh > /dev/null 2>&1 || true"
        }
      }
    }

    success {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "good", message: "Deployed ${env.JOB_NAME}#${env.BUILD_NUMBER} successfully to ${env.BUILD_ENV}, please Smoke Tests (see README.md #4.1). Add Reaction thumbsup or thumbsdown to indicate Smoke Test cases pass or not.\n${CHANGELOG}"

      emailext (
        subject: "Deployed ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>New build completed and deployed successfully: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Please Smoke Tests (see README.md #4.1). Add Reaction thumbsup or thumbsdown on Slack to indicate Smoke Test cases pass or not.</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
      script {
        sh "vagrant destroy -f || true"
      }
    }

    unstable {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "warning", message: "Unstable build ${env.JOB_NAME}#${env.BUILD_NUMBER} to ${env.BUILD_ENV}, please fix: ${env.BUILD_URL}console#footer\n${CHANGELOG}"

      emailext (
        subject: "Unstable build ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>Unstable build: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Check console output at &QUOT;<a href='${env.BUILD_URL}console#footer'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
      script {
        sh "vagrant halt"
      }
    }

    failure {
      slackSend channel: "${env.SLACK_CHANNEL}", color: "danger", message: "FAIL ${env.JOB_NAME}#${env.BUILD_NUMBER} to ${env.BUILD_ENV}, please fix: ${env.BUILD_URL}console#footer\n${CHANGELOG}"

      emailext (
        subject: "Failed to build ${env.JOB_NAME} to ${env.BUILD_ENV} [${env.BUILD_NUMBER}]",
        body: """<p>Build failed: '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
          <p>Check console output at &QUOT;<a href='${env.BUILD_URL}console#footer'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>
          <p>${CHANGELOG}""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
      script {
        sh "vagrant halt"
      }
    }
  }
}
