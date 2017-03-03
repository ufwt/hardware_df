@prune1@
expression src;
statement S;
position p1;
@@

(
	S
	read_wrapper(src);@p1
|
	{
	read_wrapper(src);@p1
	...
	}
)

@script:python@
p << prune1.p1;
@@

import remove_record
if p:
	#print 'Prune: ', p[0].file, ' unused read wrapper line: ', p[0].line

	remove_record.delete(p[0].file, p[0].line)

@prune2@
expression src;
position p1;
@@

	write_wrapper(<+...read_wrapper(src)...+>,src) @p1

@script:python@
p << prune2.p1;
@@

import remove_record
if p:
	#print 'Prune: ', p[0].file, ' write(read) line: ', p[0].line

	remove_record.delete(p[0].file, p[0].line)