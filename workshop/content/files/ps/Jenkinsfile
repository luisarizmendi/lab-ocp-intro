#!groovy

try {
    timeout(time: 20, unit: 'MINUTES') {

        echo "Build Number is: ${env.BUILD_NUMBER}"
        echo "Job Name is: ${env.JOB_NAME}"
        def commit_id, source, origin_url, name

        node('maven') {
            stage('Initialise') {
                // Checkout code from repository - we want commit id and name
                checkout scm
                dir("${WORKSPACE}") {
                    commit_id = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    echo "Git Commit is: ${commit_id}"
                    def cmd0 = $/name=$(git config --local remote.origin.url); name=$${name##*/}; echo $${name%%.git}/$
                    name = sh(returnStdout: true, script: cmd0).trim()
                    echo "Name is: ${name}"
                }
                origin_url = sh(returnStdout: true, script: 'git config --get remote.origin.url').trim()
                source = "${origin_url}#${commit_id}"
                echo "Source URL is: ${source}"
            }

            stage('Build') {
                // Start Build or Create initial app if doesn't exist
                if (!getBuildName(name)) {
                    echo 'Creating build'
                    try {
                        sh "oc new-build --strategy=source --name=${name} --binary -l app=${name},commit=${commit_id} -i eap70-openshift"
                    } catch (e) {
                        echo "build creation failed"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
                echo 'Building image'
                try {
                    sh "oc start-build ${name} --from-file=deployments/ROOT.war --follow"
                } catch (e) {
                    echo "build failed"
                    currentBuild.result = 'FAILURE'
                    throw e
                }

            }

            stage('Deploy') {
                echo 'Deploying image'
                def deploy = getDeployName(name)
                if (deploy) {
                    openshiftDeploy(deploymentConfig: deploy)
                } else {
                    echo 'Creating deployment'
                    sh "oc new-app ${name} --name=${name} -l app=${name},commit=${commit_id}"
                }
            }

            stage('Create Route') {
                echo 'Creating a route to application'
                createRoute(name)
            }
        }
    }

} catch (err) {
    echo "in catch block"
    echo "Caught: ${err}"
    currentBuild.result = 'FAILURE'
    throw err
}

// Expose service to create a route
def createRoute(String name) {
    try {
        def service = getServiceName(name)
        sh "oc expose svc ${service}"
    } catch (Exception e) {
        echo "route exists"
    }
}

// Get Build Name
def getBuildName(String name) {
    def cmd1 = $/buildconfig=$(oc get bc -l app=${name} -o name);echo $${buildconfig##buildconfig/}/$
    bld = sh(returnStdout: true, script: cmd1).trim()
    return bld
}

// Get Deploy Config Name
def getDeployName(String name) {
    def cmd2 = $/deploymentconfigs=$(oc get dc -l app=${name} -o name);echo $${deploymentconfigs##deploymentconfigs/}/$
    dply = sh(returnStdout: true, script: cmd2).trim()
    return dply
}

// Get Service Name
def getServiceName(String name) {
    def cmd3 = $/services=$(oc get svc -l app=${name} -o name);echo $${services##services/}/$
    svc = sh(returnStdout: true, script: cmd3).trim()
    return svc
}

