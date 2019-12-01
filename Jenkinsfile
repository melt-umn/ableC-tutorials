#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

def extension_name = 'ableC-tutorials'
def extensions = []

melt.trynode(extension_name) {
  def newenv

  stage ("Checkout") {
    melt.clearGenerated()
    
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
  melt.clearGenerated()
}

// Build a specific tutotial in the local workspace
def task_tutorial(String tutorialpath, newenv) {
  return {
    node {
      melt.clearGenerated()
      
      newenv << "SILVER_GEN=${env.WORKSPACE}/generated"
      
      withEnv(newenv) {
        // Go back to our "parent" workspace, into the tutorial
        dir("${newenv.EXTS_BASE}/extensions/ableC-tutorials/${tutorialpath}") {
          sh "make -j"
        }
      }
      // Blow away these generated files in our private workspace
      deleteDir()
    }
  }
}

