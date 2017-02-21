//define global variable
@initialize:python@
count << virtual.count;
@@
#-----------------------------Post Matching Process------------------------------
def print_and_log(filename,first,second,count):
	

	print "No. ", count, " file: ", filename
	print "--first fetch: line ",first
	print "--second fetch: line ",second
	print "------------------------------------\n"

	logfile = open('result.txt','a')
	logfile.write("No." + count + " File: \n" + str(filename) + "\n")
	logfile.write("--first fetch: line " + str(first) + "\n")
	logfile.write("--second fetch: line " + str(second) + "\n")
	logfile.write("-------------------------------\n")
	
	logfile.close()

//---------------------
@ rule1 disable drop_cast exists @
expression addr,exp1,exp2,src,size1,size2,offset,value;
position p1,p2;
identifier func;
type T1,T2;
@@
	func(...){
	...	
(
	ioread8(src)@p1
|
	ioread16(src)@p1	
|
	ioread32(src)@p1
|	
	ioread64(src)@p1
|
	readb(src)@p1
|	
	readw(src)@p1
|
	readl(src)@p1
|
	readq(src)@p1
|
	__raw_readb(src)@p1
|	
	__raw_readw(src)@p1
|
	__raw_readl(src)@p1
|
	__raw_readq(src)@p1
)

	...	when any
		when != src += offset	
		when != src = src + offset
		when != src ++
		when != src -=offset
		when != src = src - offset
		when != src--
		when != src = addr
		when != iowrite8(value,src)
		when != iowrite16(value,src)
		when != iowrite32(value,src)
		when != iowrite64(value,src)
		when != writeb(value,src)
		when != writew(value,src)
		when != writel(value,src)
		when != writeq(value,src)
		when != __raw_writeb(value,src)
		when != __raw_writew(value,src)
		when != __raw_writel(value,src)
		when != __raw_writeq(value,src)
		
(
	ioread8(src)@p2
|
	ioread16(src)@p2	
|
	ioread32(src)@p2
|	
	ioread64(src)@p2
|
	readb(src)@p2
|	
	readw(src)@p2
|
	readl(src)@p2
|
	readq(src)@p2
|
	__raw_readb(src)@p2
|	
	__raw_readw(src)@p2
|
	__raw_readl(src)@p2
|
	__raw_readq(src)@p2
)	
	...
	}

@script:python@
p11 << rule1.p1;
p12 << rule1.p2;
s1 << rule1.src;
@@

print "src1:", str(s1)
if p11 and p12:
	coccilib.report.print_report(p11[0],"rule1 First fetch")
	coccilib.report.print_report(p12[0],"rule1 Second fetch")

	filename = p11[0].file
	first = p11[0].line
	second = p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	if first != second:
		print_and_log(filename, first, second, count)
	#ret = post_match_process(p11, p12, s1, s1, count)
	#if ret: 
		#count = ret


