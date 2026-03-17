Extension { #name : 'Object' }

{ #category : '*Zag-FromPython' }
Object >> toPythonBoolean [
	"Returns me as a boolean according to Python's truthiness semantics."
	"0, nil, false and empty collections are falsy, everything else is truthy."
	^self isNotNil.
]
