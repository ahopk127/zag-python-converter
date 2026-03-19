"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagFromPythonTests',
	#superclass : 'PackageManifest',
	#category : 'Zag-FromPython-Tests-Manifest',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagFromPythonTests class >> ruleReAssertWithBooleanEqualtiyRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#PythonTruthyTest)) #'2026-03-19T11:26:44.11-05:00') )
]
