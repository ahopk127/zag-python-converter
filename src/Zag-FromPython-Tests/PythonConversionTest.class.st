Class {
	#name : 'PythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests',
	#package : 'Zag-FromPython-Tests'
}

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
