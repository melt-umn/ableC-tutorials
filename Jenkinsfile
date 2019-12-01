#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

def extension_name = 'ableC-tutorials'
def extensions = []

melt.trynode('ableC-tutorials') {

  def newenv

  stage ("Checkout") {
    // We'll check it out underneath extensions/ just so we can re-use this code
    // It shouldn't hurt because newenv should specify where extensions and ablec_base can be found
    newenv = ablec.prepareWorkspace(extension_name, extensions, true)
  }

  stage ("Test") {
    def tuts = ["construction", "declarations", "embedded_dsl", "error_checking", "extended_env", "getting_started", "lifting", "overloading"]
    
    def tasks = [:]
    tasks << tuts.collectEntries { t -> [(t): task_tutorial(t, newenv)] }
    
    parallel tasks
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  sh "rm -rf generated/* || true"
}

// Tutorial in local workspace
def task_tutorial(String tutorialpath, env) {
  return {
    node {
      melt.clearGenerated()
      
      withEnv(env) {
        // Go back to our "parent" workspace, into the tutorial
        dir("${env.EXTS_BASE}/ableC-tutorials/${tutorialpath}") {
          sh "make -j"
        }
      }
      // Blow away these generated files in our private workspace
      deleteDir()
    }
  }
}

