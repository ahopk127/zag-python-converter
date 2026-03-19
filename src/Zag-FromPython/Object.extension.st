Extension { #name : 'Object' }

{ #category : '*Zag-FromPython' }
Object >> pythonAnd: other [
	"Like 'and:', but using Python's truthy/falsy semantics."
	^self toPythonBoolean
		ifTrue: [ other value ]
		ifFalse: [ self ].
]

{ #category : '*Zag-FromPython' }
Object >> pythonNot [
	"Like 'not', but using Python's truthy semantics."
	^self toPythonBoolean not.
]

{ #category : '*Zag-FromPython' }
Object >> pythonOr: other [
	"Like 'or:', but using Python's truthy/falsy semantics."
	^self toPythonBoolean
		ifTrue: [ self ]
		ifFalse: [ other value ].
]

{ #category : '*Zag-FromPython' }
Object >> toPythonBoolean [
	"Returns me as a boolean according to Python's truthiness semantics."
	"0, nil, false and empty collections are falsy, everything else is truthy."
	^self isNotNil.
]
