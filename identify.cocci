
@identify@
expression dst1,dst2,src,buf,value,count;
position p1,p2;
identifier func;
@@


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
|
	ioread8_rep(dst1,src,count)@p1
|
	ioread16_rep(dst1,src,count)@p1
|
	ioread32_rep(dst1,src,count)@p1
|
	ioread64_rep(dst1,src,count)@p1
|
	memcpy_fromio(dst1,src,count)@p1
)

	 ... when any
	 	when != iowrite8(value,src)
		when != iowrite16(value,src)
		when !=	iowrite32(value,src)
		when != iowrite64(value,src)
		when !=	writeb(value,src)	
		when !=	writew(value,src)
		when != writel(value,src)
		when != writeq(value,src)
		when != __raw_writeb(value,src)
		when !=	__raw_writew(value,src)
		when != __raw_writel(value,src)
		when != __raw_writeq(value,src)
		when != iowrite8_rep(src,buf,count)
		when != iowrite16_rep(src,buf,count)
		when != iowrite32_rep(src,buf,count)
		when != iowrite64_rep(src,buf,count)
		when != memcpy_toio(src,buf,count)

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
|
	ioread8_rep(dst2,src,count)@p2
|
	ioread16_rep(dst2,src,count)@p2
|
	ioread32_rep(dst2,src,count)@p2
|
	ioread64_rep(dst2,src,count)@p2
|
	memcpy_fromio(dst2,src,count)@p2
)



@script:python@
p11 << identify.p1;
p12 << identify.p2;
@@

import json
def print_and_log(filename,first,second):
	
	record = {}
	record['fileName'] = filename
	record['first'] = first
	record['second'] = second
	print "record", record

	data = json.dumps(record)
	logfile = open('result.txt','a')
	logfile.write(data + "\n")
	logfile.close()

if p11 and p12:
	#print("Identified wrapper function",p11[0])
	#coccilib.report.print_report(p11[0],"identify First fetch")
	#coccilib.report.print_report(p12[0],"identify Second fetch")

	print_and_log(p11[0].file, p11[0].line, p12[0].line)


