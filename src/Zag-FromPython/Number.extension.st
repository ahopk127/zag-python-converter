Extension { #name : 'Number' }

{ #category : '*Zag-FromPython' }
Number >> toPythonBoolean [
	^self isZero not.
]
