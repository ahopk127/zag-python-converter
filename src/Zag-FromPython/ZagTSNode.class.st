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
	#category : 'Zag-FromPython',
	#package : 'Zag-FromPython'
}

{ #category : 'accessing' }
ZagTSNode class >> converter: type [
	"Returns the conversion function for a node of the given type (symbol)."
	"This function should accept the ZagTSNode and return a Zag AST object."
	type = #identifier ifTrue: [ ^[ :node | ASRef variable: node sourcePart asSymbol ] ].
	type = #'expression_statement' ifTrue: [ ^[ :node | (node >> 1) asZagASTNode ] ].
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
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"
	| converter |
	converter := self class converter: self tsNodeType.
	^converter value: self.
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

{ #category : 'accessing' }
ZagTSNode >> tsNodeType [
	^node type asSymbol.
]
