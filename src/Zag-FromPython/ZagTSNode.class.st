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
	type = #string ifTrue: [ ^#stringToZagAST ].
	(#(#integer #float) includes: type) ifTrue: [ ^#numberToZagAST ].
	type = #'not_operator' ifTrue: [ ^#notToZagAST ].
	type = #'binary_operator' ifTrue: [ ^#binaryToZagAST ].
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
ZagTSNode >> binaryToZagAST [
	"Converts a binary operator to a Zag AST."
	| op |
	op := self getBinaryOperator.
	
	(#(#+ #- #* #/) includes: op) ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: op args: {(self >> 2) asZagASTNode} ].
	op = #** ifTrue:
		[ ^ASSend target: (self >> 1) asZagASTNode selector: #raisedTo: args: {(self >> 2) asZagASTNode} ].
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

{ #category : 'converting - by node type' }
ZagTSNode >> identifierToZagAST [
	"Converts me to a Zag AST, assuming I am an identifier."
	^ASRef variable: self sourcePart asSymbol.
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
