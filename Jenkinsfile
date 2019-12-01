#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

melt.trynode('ableC-tutorials') {
  def extension_name = 'ableC-tutorials'
  def extensions = []
  
  melt.clearGenerated()
      
  // We'll check it out underneath extensions/ just so we can re-use this code
  // It shouldn't hurt because newenv should specify where extensions and ablec_base can be found
  def newenv = ablec.prepareWorkspace(extension_name, extensions, true)

  
  
  def tuts = ["construction", "declarations", "embedded_dsl", "error_checking", "extended_env", "getting_started", "lifting", "overloading"]
  
  def tasks = [:]
  tasks << tuts.collectEntries { t -> [(t): task_tutorial(t, newenv)] }
  
  parallel tasks
}

// Build a specific tutotial in the local workspace
def task_tutorial(String tutorialpath, newenv) {
  return {
    node {
      melt.clearGenerated()
      
      newenv << "SILVER_GEN=${env.WORKSPACE}/generated"
      
      withEnv(newenv) {
        // Go back to our "parent" workspace, into the tutorial
        dir("extensions/${extension_name}/${tutorialpath}") {
          sh "make -j"
        }
      }
      // Blow away these generated files in our private workspace
      deleteDir()
    }
  }
}

