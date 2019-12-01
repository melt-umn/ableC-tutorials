#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

def extension_name = 'ableC-tutorials'
def extensions = []

melt.trynode('ableC-tutorials') {

  def tuts = ["construction", "declarations", "embedded_dsl", "error_checking", "extended_env", "getting_started", "lifting", "overloading"]
  
  def tasks = [:]
  tasks << tuts.collectEntries { t -> [(t): task_tutorial(t)] }
  
  parallel tasks
  
}

// Tutorial in local workspace
def task_tutorial(String tutorial) {
  return {
    node {
      def newenv

      stage ("Checkout") {
        // We'll check it out underneath extensions/ just so we can re-use this code
        // It shouldn't hurt because newenv should specify where extensions and ablec_base can be found
        newenv = ablec.prepareWorkspace(extension_name, extensions, true)
      }

      stage ("Test") {
        melt.clearGenerated()
        
        newenv = ableC.getSilverAbleCEnv(silver_base)
        newenv << "SILVER_HOST_GEN=${ablec_gen}"
        withEnv(newenv) {
          // Go back to our "parent" workspace, into the tutorial
          dir("${newenv.EXTS_BASE}/ableC-tutorials/${tutorial}") {
            sh "make -j"
          }
        }
        // Blow away these generated files in our private workspace
        deleteDir()
      }
    }
  }
}

