Class {
	#name : 'PythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests-Tests',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Tests'
}

{ #category : 'tests - operators' }
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

{ #category : 'tests - operators' }
PythonConversionTest >> testAndOrOperator [
	"Ensure an 'and' expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a and b or c'. "= (a and b) or c"
	expected := ASSend
		target: (ASSend
			target: (ASRef variable: #a)
			selector: #pythonAnd:
			args: {ASBlockNode
				arguments: #() locals: #() body: { ASRef variable: #b }})
		selector: #pythonOr:
		args: {ASBlockNode
			arguments: #() locals: #() body: { ASRef variable: #c }}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAssign [
	"Ensure an assignment expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a = b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASRef variable: #b).
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAssignPlus [
	"Ensure an augmented assignment expression (+=) can be converted to Zag properly."
	| expected actual source root node |
	source := 'a += b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASSend
			target: (ASRef variable: #a)
			selector: #+
			args: { ASRef variable: #b }).
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftLeft [
	"Ensure a left bit shift expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a << b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftRight [
	"Ensure a right bit shift expression can be converted to Zag properly.  Included because it has unique semantics compared to left shift."
	| expected actual source root node |
	source := 'a >> b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #negated
			args: #()}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testComparison [
	"Ensure a comparison expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a > b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #>
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testEquals [
	"Ensure an == expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a == b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #=
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - literals' }
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

{ #category : 'tests - operators' }
PythonConversionTest >> testIn [
	"Ensure a 'in' expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a in b'.
	expected := ASSend
		target: (ASRef variable: #b)
		selector: #includes:
		args: {ASRef variable: #a}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - literals' }
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

{ #category : 'tests - operators' }
PythonConversionTest >> testIs [
	"Ensure an 'is' expression can be converted to Zag properly."
	| expected actual source root node |
	source := 'a is b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #==
		args: {ASRef variable: #b}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testIsNot [
	"Ensure an 'is not' expression can be converted to Zag properly.  Separate because it is a two-word operator."
	| expected actual source root node |
	source := 'a is not b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #~~
		args: {ASRef variable: #b}.
	
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

{ #category : 'tests - operators' }
PythonConversionTest >> testNegation [
	"Ensure an addition expression can be converted to Zag properly."
	| expected actual source root node |
	source := '-a'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #negated
		args: #().
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNotIn [
	"Ensure a 'not in' expression can be converted to Zag properly.  Included because it has distinct semantics from 'is' and is one operator of two words."
	| expected actual source root node |
	source := 'a not in b'.
	expected := ASSend
		target: (ASSend
			target: (ASRef variable: #b)
			selector: #includes:
			args: {ASRef variable: #a})
		selector: #not args: {}.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNotOperator [
	"Ensure a 'not' expression can be converted properly."
	| expected actual source root node |
	source := 'not a'.
	expected := ASSend target: (ASRef variable: #a) selector: #pythonNot.
	
	root := ZagTSNode newRoot: source.
	node := root >> 1.
	actual := node asZagASTNode.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
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

{ #category : 'tests - literals' }
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
