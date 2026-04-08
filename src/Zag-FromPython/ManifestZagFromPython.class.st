"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagFromPython',
	#superclass : 'PackageManifest',
	#category : 'Zag-FromPython-Manifest',
	#package : 'Zag-FromPython',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagFromPython class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ZagTSNode class' #converter: #true)) #'2026-04-08T07:54:23.572-05:00') )
]

{ #category : 'code-critics' }
ManifestZagFromPython class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ZagTSNode class' #converter: #true)) #'2026-04-08T08:20:55.15-05:00') )
]
