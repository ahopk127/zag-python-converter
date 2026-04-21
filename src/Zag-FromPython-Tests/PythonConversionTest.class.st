Class {
	#name : 'PythonConversionTest',
	#superclass : 'TestCase',
	#category : 'Zag-FromPython-Tests-Tests',
	#package : 'Zag-FromPython-Tests',
	#tag : 'Tests'
}

{ #category : 'text - helpers' }
PythonConversionTest >> assertExpression: source convertsTo: tree [
	"Asserts the provided Python code converts to the provided AST."
	"Puts the provided AST in a main method."
	| expected actual |
	expected := ASMethodNode selector: ZagTSNode mainMethodSelector body: {tree}.
	actual := ZagTSNode pythonToZagAST: source.
	self assert: actual equals: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAddition [
	"Ensure an addition expression can be converted to Zag properly."
	| expected source |
	source := 'a + b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testAndOrOperator [
	"Ensure an 'and' expression can be converted to Zag properly."
	| expected source |
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
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testAssign [
	"Ensure an assignment expression can be converted to Zag properly."
	| expected source |
	source := 'a = b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASRef variable: #b).
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testAssignPlus [
	"Ensure an augmented assignment expression (+=) can be converted to Zag properly."
	| expected source |
	source := 'a += b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASSend
			target: (ASRef variable: #a)
			selector: #+
			args: { ASRef variable: #b }).
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftLeft [
	"Ensure a left bit shift expression can be converted to Zag properly."
	| expected source |
	source := 'a << b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testBitShiftRight [
	"Ensure a right bit shift expression can be converted to Zag properly.  Included because it has unique semantics compared to left shift."
	| expected source |
	source := 'a >> b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #bitShift:
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #negated
			args: #()}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testComparison [
	"Ensure a comparison expression can be converted to Zag properly."
	| expected source |
	source := 'a > b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #>
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testEquals [
	"Ensure an == expression can be converted to Zag properly."
	| expected source |
	source := 'a == b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #=
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testFloatNode [
	"Ensure a variable can be converted to Zag properly."
	| expected source |
	source := '2.0'.
	expected := ASLiteral literal: 2.0.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIn [
	"Ensure a 'in' expression can be converted to Zag properly."
	| expected source |
	source := 'a in b'.
	expected := ASSend
		target: (ASRef variable: #b)
		selector: #includes:
		args: {ASRef variable: #a}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testIntegerNode [
	"Ensure a variable can be converted to Zag properly."
	| expected source |
	source := '2'.
	expected := ASLiteral literal: 2.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIs [
	"Ensure an 'is' expression can be converted to Zag properly."
	| expected source |
	source := 'a is b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #==
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testIsNot [
	"Ensure an 'is not' expression can be converted to Zag properly.  Separate because it is a two-word operator."
	| expected source |
	source := 'a is not b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #~~
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda0Arg [
	| source expected |
	source := 'lambda: 1'.
	expected := ASBlockNode
		arguments: #()
		locals: #()
		body: { ASLiteral literal: 1 }.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda1Arg [
	| source expected |
	source := 'lambda x: x + 1'.
	expected := ASBlockNode
		arguments: { ASRef variable: #x }
		locals: #()
		body: { ASSend target: (ASRef variable: #x) selector: #+ args: { ASLiteral literal: 1 }}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - functions' }
PythonConversionTest >> testLambda2Arg [
	| source expected |
	source := 'lambda a, b: a * b'.
	expected := ASBlockNode
		arguments: { (ASRef variable: #a) . (ASRef variable: #b) }
		locals: #()
		body: { ASSend target: (ASRef variable: #a) selector: #* args: { ASRef variable: #b }}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testMultiOperators [
	"Ensure an expression with multiple operators can be converted to Zag properly."
	| expected source |
	source := 'a + b * c'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #+
		args: {ASSend
			target: (ASRef variable: #b)
			selector: #*
			args: {ASRef variable: #c}}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNegation [
	"Ensure an addition expression can be converted to Zag properly."
	| expected source |
	source := '-a'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #negated
		args: #().
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - comparison & membership operators' }
PythonConversionTest >> testNotIn [
	"Ensure a 'not in' expression can be converted to Zag properly.  Included because it has distinct semantics from 'is' and is one operator of two words."
	| expected source |
	source := 'a not in b'.
	expected := ASSend
		target: (ASSend
			target: (ASRef variable: #b)
			selector: #includes:
			args: {ASRef variable: #a})
		selector: #not args: {}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testNotOperator [
	"Ensure a 'not' expression can be converted properly."
	| expected source |
	source := 'not a'.
	expected := ASSend target: (ASRef variable: #a) selector: #pythonNot.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - operators' }
PythonConversionTest >> testPowers [
	"Ensure an exponent can be converted to Zag properly."
	| expected source |
	source := 'a ** b'.
	expected := ASSend
		target: (ASRef variable: #a)
		selector: #raisedTo:
		args: {ASRef variable: #b}.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - literals' }
PythonConversionTest >> testStringNode [
	"Ensure a variable can be converted to Zag properly."
	| expected source |
	source := '"a"'.
	expected := ASLiteral literal: 'a'.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests' }
PythonConversionTest >> testVariableNode [
	"Ensure a variable can be converted to Zag properly."
	| expected source |
	source := 'a'.
	expected := ASRef variable: #a.
	self assertExpression: source convertsTo: expected.
]

{ #category : 'tests - assignment' }
PythonConversionTest >> testWalrus [
	"Ensure a := expression can be converted to Zag properly."
	| expected source |
	source := 'a := b'.
	expected := ASAssign
		variable: (ASRef variable: #a)
		expression: (ASRef variable: #b).
	self assertExpression: source convertsTo: expected.
]
