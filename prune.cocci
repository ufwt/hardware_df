@initialize:python@
count << virtual.count;
@@

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

import tool
if p:
	#print 'Prune: ', p[0].file, ' unused read wrapper line: ', p[0].line
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file,' unused read wrapper line: ', p[0].line
	tool.delete(p[0].file, p[0].line)




@prune2@
expression src;
position p1;
@@

	write_wrapper(<+...read_wrapper(src)@p1...+>,src) 

@script:python@
p << prune2.p1;
@@

import tool
if p:
	#print 'Prune: ', p[0].file, ' write(read) line: ', p[0].line
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file, ' write(read) line: ', p[0].line 

	tool.delete(p[0].file, p[0].line)













