# Zag To/From Python

This is a project that converts Python code to and from [Zag Smalltalk](https://github.com/Zag-Research/Zag-Smalltalk)'s AST.  It is implemented in [Pharo Smalltalk](https://pharo.org/).

This project is currently in the early stages of development; don't expect every Python feature to work at the moment.

## Use Instructions

To convert Python code to a Zag AST:
```
((ZagTSNode newRoot: '[PYTHON CODE]') >> 1) asZagASTNode
```

## Dependencies

- [Tree Sitter](https://tree-sitter.github.io/tree-sitter/), Pharo Smalltalk version

## Authors/Contact

This is the thesis project of [Adrien Hopkins](https://ahopkins.ca/) (<a1hopkins@torontomu.ca>), made as part of the [Zag Research](https://github.com/Zag-Research/) team.
