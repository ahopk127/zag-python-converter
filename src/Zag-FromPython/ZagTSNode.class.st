"
I represent a TSNode with its associated source code, ready to be converted to Zag.
"
Class {
	#name : 'ZagTSNode',
	#superclass : 'Object',
	#instVars : [
		'node',
		'source'
	],
	#category : 'Zag-FromPython-AST',
	#package : 'Zag-FromPython',
	#tag : 'AST'
}

{ #category : 'accessing' }
ZagTSNode class >> converter: type [
	"Returns the conversion function for a node of the given type (symbol)."
	"This function should accept the ZagTSNode and return a Zag AST object."
	type = #identifier ifTrue: [ ^#identifierToZagAST ].
	type = #'expression_statement' ifTrue: [ ^#childToZagAST ].
	type = #module ifTrue: [ ^#moduleToZagAST ].
	type = #string ifTrue: [ ^#stringToZagAST ].
	(#(#integer #float) includes: type) ifTrue: [ ^#numberToZagAST ].
	type = #'not_operator' ifTrue: [ ^#notToZagAST ].
	type = #'unary_operator' ifTrue: [ ^#unaryToZagAST ].
	(#(#'binary_operator' #'comparison_operator') includes: type) ifTrue: [ ^#binaryToZagAST ].
	type = #'boolean_operator' ifTrue: [ ^#booleanToZagAST ].
	type = #assignment ifTrue: [ ^#assignToZagAST ].
	type = #'augmented_assignment' ifTrue: [ ^#augmentedAssignToZagAST ].
	type = #'named_expression' ifTrue: [ ^#assignToZagAST ]. ":= - temp - should have different semantics later"
]

{ #category : 'constants' }
ZagTSNode class >> mainMethodSelector [
	"The selector used for the main method, where non-method code is put in."
	^#main.
]

{ #category : 'instance creation' }
ZagTSNode class >> newRoot: source [
	"comment stating purpose of class-side method"
	"scope: class-variables  &  class-instance-variables"

	| parser pythonLanguage tree root |
	parser := TSParser new.
	pythonLanguage := TSLanguage python.
	parser language: pythonLanguage.
	tree := parser parseString: source.
	
	root := self new.
	root setNode: tree rootNode source: source.
	^root.
]

{ #category : 'converting' }
ZagTSNode class >> pythonToZagAST: source [
	"Converts the provided code to a Zag AST node."
	^(self newRoot: source) asZagASTNode.
]

{ #category : 'accessing' }
ZagTSNode >> >> n [
	"Returns the nth child of this node, as a ZagTSNode."
	| child |
	(n <= 0 or: [ n > node namedChildCount ])
		ifTrue: [ self error: 'invalid child number' ].
	child := self class new.
	child setNode: (node namedChildAt: n) source: source.
	^child.
]

{ #category : 'converting' }
ZagTSNode >> asTSNode [
	^node.
]

{ #category : 'converting' }
ZagTSNode >> asZagASTNode [
	"Returns me as a Zag AST node."
	| converter |
	converter := self class converter: self tsNodeType.
	^converter value: self.
]

{ #category : 'converting - by node type' }
ZagTSNode >> assignToZagAST [
	^ASAssign variable: (self >> 1) asZagASTNode expression: (self >> 2) asZagASTNode.
]

{ #category : 'converting - by node type' }
ZagTSNode >> augmentedAssignToZagAST [
	| op nonAugmentedOp |
	op := self getBinaryOperator.
	nonAugmentedOp := (op asString copyFrom: 1 to: (op asString size - 1)) asSymbol.
	^ASAssign variable: (self >> 1) asZagASTNode expression: (self binaryToZagASTOperator: nonAugmentedOp).
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagAST [
	"Converts a binary operator to a Zag AST."
	| op |
	op := self getBinaryOperator.
	^self binaryToZagASTOperator: op.
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagASTOperator: op [
	"Creates a binary zag AST from this node's children using the provided Python operator."
	(#(#+ #- #* #/ #// #% #& #| #< #<= #> #>=) includes: op) ifTrue: [ ^self binaryToZagASTSelector: op ].
	op = #** ifTrue: [ ^self binaryToZagASTSelector: #raisedTo: ].
	op = #'^' ifTrue: [ ^self binaryToZagASTSelector: #bitXor: ].
	op = #<< ifTrue: [ ^self binaryToZagASTSelector: #bitShift: ].
	op = #>> ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #bitShift: args: {
			ASSend target: (self >> 2) asZagASTNode selector: #negated args: #() } ].
	op = #== ifTrue: [ ^self binaryToZagASTSelector: #= ].
	op = #!= ifTrue: [ ^self binaryToZagASTSelector: #~= ].
	op = #is ifTrue: [ ^self binaryToZagASTSelector: #== ].
	op = #'is not' ifTrue: [ ^self binaryToZagASTSelector: #~~ ].
	op = #in ifTrue: [ ^ASSend target: (self >> 2) asZagASTNode selector: #includes: args: {(self >> 1) asZagASTNode} ].
	op = #'not in' ifTrue: [ ^ASSend target: (ASSend target: (self >> 2) asZagASTNode selector: #includes: args: {(self >> 1) asZagASTNode}) selector: #not args: #() ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> binaryToZagASTSelector: selector [
	"Creates a binary zag AST from this node's children using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {(self >> 2) asZagASTNode}.
]

{ #category : 'converting - by node type' }
ZagTSNode >> booleanToZagAST [
	"convert and/or to Zag AST"
 	| op |
	op := self getBinaryOperator.
	op = #and ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #pythonAnd:
			args: {ASBlockNode arguments: #() locals: #() body: {(self >> 2) asZagASTNode}} ].
	op = #or ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #pythonOr:
			args: {ASBlockNode arguments: #() locals: #() body: {(self >> 2) asZagASTNode}} ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> childToZagAST [
	"Returns my first child as a Zag AST."
	^(self >> 1) asZagASTNode.
]

{ #category : 'computing' }
ZagTSNode >> getBinaryOperator [
	"If I represent a binary operator, return the operator I represent."
	| start end |
	start := ((self >> 1) asTSNode endPositionFromSourceText: source) + 1.
	end := ((self >> 2) asTSNode startPositionFromSourceText: source) - 1.
	^(source copyFrom: start to: end) trimBoth asSymbol.
]

{ #category : 'computing' }
ZagTSNode >> getUnaryOperator [
	"If I represent a unary operator, return the operator I represent."
	| start end |
	start := self asTSNode startPositionFromSourceText: source.
	end := ((self >> 1) asTSNode startPositionFromSourceText: source) - 1.
	^(source copyFrom: start to: end) trimBoth asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> identifierToZagAST [
	"Converts me to a Zag AST, assuming I am an identifier."
	^ASRef variable: self sourcePart asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> moduleToZagAST [
	"Converts a module to a #main method."
	| children |
	children := (1 to: node namedChildCount)
		collect: [ :i | (self >> i) asZagASTNode ].
	^ASMethodNode selector: self class mainMethodSelector body: children.
]

{ #category : 'converting - by node type' }
ZagTSNode >> notToZagAST [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	^ASSend target: (self >> 1) asZagASTNode selector: #pythonNot.
]

{ #category : 'converting - by node type' }
ZagTSNode >> numberToZagAST [
	"Converts a number to a Zag AST."
	^ASLiteral literal: self sourcePart asNumber.
]

{ #category : 'initialization' }
ZagTSNode >> setNode: aNode source: aString [
	node := aNode.
	source := aString.
]

{ #category : 'accessing' }
ZagTSNode >> sourceFull [
	"Returns the complete source code of the tree this node was created with."
	^source.
]

{ #category : 'accessing' }
ZagTSNode >> sourcePart [
	"Returns the part of the source code associated with this node."
	^node textFromSourceText: source.
]

{ #category : 'converting - by node type' }
ZagTSNode >> stringToZagAST [
	"Converts a string to a Zag AST."
	^ASLiteral literal: (self >> 2) sourcePart.
]

{ #category : 'accessing' }
ZagTSNode >> tsNodeType [
	"Returns the type of my associated tree sitter node"
	^node type asSymbol.
]

{ #category : 'converting - by node type' }
ZagTSNode >> unaryToZagAST [
	"Converts a unary operator to a Zag AST."
	| op |
	op := self getUnaryOperator.
	op = #- ifTrue: [ ^self unaryToZagAST: #negated ].
	op = #~ ifTrue: [ ^self unaryToZagAST: #bitInvert ].
]

{ #category : 'converting - by node type' }
ZagTSNode >> unaryToZagAST: selector [
	"Creates a unary zag AST from this node's child using the provided selector."
	^ASSend target: (self >> 1) asZagASTNode selector: selector args: {}.
]
