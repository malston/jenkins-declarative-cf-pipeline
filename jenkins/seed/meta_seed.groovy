import javaposse.jobdsl.dsl.DslFactory

DslFactory factory = this

// remove::start[CF]
String repos = 'https://github.com/marcingrzejszczak/github-analytics-multi,https://github.com/marcingrzejszczak/github-webhook'
// remove::end[CF]

// meta-seed
factory.job('meta-seed') {
	scm {
		git {
			remote {
				github('malston/jenkins-declarative-cf-pipeline')
			}
			branch('${TOOLS_BRANCH}')
			extensions {
				submoduleOptions {
					recursive()
				}
			}
		}
	}
	steps {
		gradle("clean build")
		dsl {
			external('jenkins/seed/jenkins_pipeline.groovy')
			removeAction('DISABLE')
			removeViewAction('DELETE')
			ignoreExisting(false)
			lookupStrategy('SEED_JOB')
			additionalClasspath([
				'jenkins/src/main/groovy', 'jenkins/src/main/resources'
			].join("\n"))
		}
	}
	wrappers {
		parameters {
			stringParam('TOOLS_BRANCH', 'master', "The branch with pipeline functions")
		}
	}
}
