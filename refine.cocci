//define global variable
@initialize:python@
count << virtual.count;
@@

@identify1 @
expression dst1,dst2,src,buf,value,count1,count2,count,offset,addr;
position p1,p2;
@@


(
	read_wrapper(src)@p1 
|
	block_read_wrapper(dst,src,count)@p1
)

	 ... when any
		when != write_wrapper(value,src)
		when != block_write_wrapper(src,buf,count)
		when != src = src + offset
		when != src ++
		when != src = addr
		when != src = src - offset
		when != src --

(
	read_wrapper(src)@p2
|
	block_read_wrapper(dst2,src,count2)@p2
)



@script:python@
p11 << identify1.p1;
p12 << identify1.p2;
@@

import tool
if p11 and p12:
	print "[refine1][1st]: ",p11[0].line
	print "[refine2][2nd]: ",p12[0].line
	#coccilib.report.print_report(p11[0],"identify1 First fetch")
	#coccilib.report.print_report(p12[0],"identify1 Second fetch")

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_refined_files(p11[0].file, p11[0].line, p12[0].line, count)




@identify2@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count,offset,addr;
position p1,p2;
type T;
@@

(
	read_wrapper(src)@p1
|
	block_read_wrapper(dst1,src,count1)@p1
)

	 ... when any
		when != write_wrapper(value,src)
		when != block_write_wrapper(src,buf,count)
		when != src = src + offset
		when != src ++
		when != src = addr
		when != src = src - offset
		when != src --
( 
	ptr = src
|
	ptr = (T) src
)
	 ... when any
	 	when != ptr = ptr + offset
		when != ptr ++
		when != ptr = addr
		when != ptr = ptr - offset
		when != ptr --

		when != write_wrapper(value,ptr)
		when != block_write_wrapper(ptr,buf,count)
		

		when != write_wrapper(value,src)
		when != block_write_wrapper(src,buf,count)


(
	read_wrapper(ptr)@p2
|
	block_read_wrapper(dst2,ptr,count2)@p2
)


@script:python@
p11 << identify2.p1;
p12 << identify2.p2;
@@

import tool
if p11 and p12:
	print "[refine2][1st]: ",p11[0].line
	print "[refine2][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_refined_files(p11[0].file, p11[0].line, p12[0].line, count)






@identify3@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count,offset,addr;
position p1,p2;
type T;
@@


( 
	ptr = src
|
	ptr = (T)src
)
	... when any
	 
(
	read_wrapper(src)@p1
|
	block_read_wrapper(dst1,src,count1)@p1
)

	 ... when any
	 	when != ptr = ptr + offset
		when != ptr ++
		when != ptr = addr
		when != ptr = ptr - offset
		when != ptr --

		when != write_wrapper(value,ptr)
		when != block_write_wrapper(ptr,buf,count)

		when != write_wrapper(value,src)
		when != block_write_wrapper(src,buf,count)

(
	read_wrapper(ptr)@p2
|
	block_read_wrapper(dst2,ptr,count2)@p2
)


@script:python@
p11 << identify3.p1;
p12 << identify3.p2;
@@

import tool
if p11 and p12:
	print "[refine3][1st]: ",p11[0].line
	print "[refine3][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_refined_files(p11[0].file, p11[0].line, p12[0].line, count)




@identify4@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count,offset,addr;
position p1,p2;
type T;
@@


( 
	ptr = src
|
	ptr = (T)src
)
	... when any
	 
(
	read_wrapper(ptr)@p1
|
	block_read_wrapper(dst2,ptr,count1)@p1
)

	 ... when any
	 	when != src = src + offset
		when != src ++
		when != src = addr
		when != src = src - offset
		when != src --

	 	when != write_wrapper(value,ptr)
		when != block_write_wrapper(ptr,buf,count)

		when != write_wrapper(value,src)
		when != block_write_wrapper(src,buf,count)

(
	read_wrapper(src)@p2
|
	block_read_wrapper(dst1,src,count2)@p2
)


@script:python@
p11 << identify4.p1;
p12 << identify4.p2;
@@

import tool
if p11 and p12:
	print "[refine3][1st]: ",p11[0].line
	print "[refine3][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_refined_files(p11[0].file, p11[0].line, p12[0].line, count)

