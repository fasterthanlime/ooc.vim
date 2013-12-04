// keep me
yes(
a,
expr ? (':' + expr()) ':',
expr ? ('\'' + expr()) '\'',
expr ? ('\\' + expr()) '\\',
expr ? ('\n' + expr()) '\n',
expr ? ('\013' + expr()) '\013',
expr ? ('\x13' + expr()) '\x13',
expr ? ('\u1230' + expr()) '\u1230',
// invalid, but should still not fuck up
expr ? ('' + expr()) '',
expr ? ('\018' + expr()) '\018',
expr ? ('\xeg' + expr()) '\0eg',
c
)
