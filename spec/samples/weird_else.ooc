// keep me!
setReturnArg: func (retArg: Expression) {
if(returnArgs empty?()) returnArgs add(retArg)
else                    returnArgs[0] = retArg
}
