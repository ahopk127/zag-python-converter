Class {
	#name : 'PythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests',
	#package : 'Zag-FromPython-Tests'
}

{ #category : 'tests' }
PythonConversionTest >> testAddition [
	"Ensure an addition expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a + b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testFloatNode [
	"Ensure a variable can be converted to Zag properly."
	| expected actual source root node |
	source := '2.0'.
	expected := ASLiteral literal: 2.0.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testIntegerNode [
	"Ensure a variable can be converted to Zag properly."
	| expected actual source root node |
	source := '2'.
	expected := ASLiteral literal: 2.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testMultiOperators [
	"Ensure an expression with multiple operators can be converted to Zag properly."
	| expected actual source root node |
	source := 'a + b * c'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #*
			args: {ASRef variable: #c}}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testNotOperator [
	"Ensure a 'not' expression can be converted properly."
	| expected actual source root node |
	source := 'not a'.
	expected := ASSend target: (ASSend target: (ASRef variable: #a) selector: #toPythonBoolean) selector: #not.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testPowers [
	"Ensure an exponent can be converted to Zag properly."
	| expected actual source root node |
	source := 'a ** b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #raisedTo:
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testStringNode [
	"Ensure a variable can be converted to Zag properly."
	| expected actual source root node |
	source := '"a"'.
	expected := ASLiteral literal: 'a'.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testVariableNode [
	"Ensure a variable can be converted to Zag properly."
	| expected actual source root node |
	source := 'a'.
	expected := ASRef variable: #a.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]
