//define global variable
@initialize:python@
count << virtual.count;
@@

@identify1 @
expression dst1,dst2,src,buf,value,count1,count2,count;
position p1,p2;
@@


(
	ioread8(src) @p1
|
	ioread16(src) @p1
|
	ioread32(src) @p1
|	
	ioread64(src) @p1
|
	readb(src) @p1
|	
	readw(src) @p1
|
	readl(src) @p1
|
	readq(src) @p1
|
	__raw_readb(src) @p1
|	
	__raw_readw(src) @p1
|
	__raw_readl(src) @p1
|
	__raw_readq(src) @p1
|
	ioread8_rep(dst1,src,count1) @p1
|
	ioread16_rep(dst1,src,count1) @p1
|
	ioread32_rep(dst1,src,count1) @p1
|
	ioread64_rep(dst1,src,count1) @p1
|
	memcpy_fromio(dst1,src,count1) @p1
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
	ioread8(src) @p2
|
	ioread16(src) @p2
|
	ioread32(src) @p2
|	
	ioread64(src) @p2
|
	readb(src) @p2
|	
	readw(src) @p2
|
	readl(src) @p2
|
	readq(src) @p2
|
	__raw_readb(src) @p2
|	
	__raw_readw(src) @p2
|
	__raw_readl(src) @p2
|
	__raw_readq(src) @p2
|
	ioread8_rep(dst2,src,count2) @p2
|
	ioread16_rep(dst2,src,count2) @p2
|
	ioread32_rep(dst2,src,count2) @p2
|
	ioread64_rep(dst2,src,count2) @p2
|
	memcpy_fromio(dst2,src,count2) @p2
)



@script:python@
p11 << identify1.p1;
p12 << identify1.p2;
@@

import tool
if p11 and p12:
	print "[identify1][1st]: ",p11[0].line
	print "[identify1][2nd]: ",p12[0].line
	#coccilib.report.print_report(p11[0],"identify1 First fetch")
	#coccilib.report.print_report(p12[0],"identify1 Second fetch")

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_identified_files(p11[0].file, p11[0].line, p12[0].line, count)




@identify2@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count;
position p1,p2;
type T;
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
	ioread8_rep(dst1,src,count1)@p1
|
	ioread16_rep(dst1,src,count1)@p1
|
	ioread32_rep(dst1,src,count1)@p1
|
	ioread64_rep(dst1,src,count1)@p1
|
	memcpy_fromio(dst1,src,count1)@p1
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
	ptr = src
|
	ptr = (T) src
)
	 ... when any
		when != iowrite8(value,ptr)
		when != iowrite16(value,ptr)
		when !=	iowrite32(value,ptr)
		when != iowrite64(value,ptr)
		when !=	writeb(value,ptr)	
		when !=	writew(value,ptr)
		when != writel(value,ptr)
		when != writeq(value,ptr)
		when != __raw_writeb(value,ptr)
		when !=	__raw_writew(value,ptr)
		when != __raw_writel(value,ptr)
		when != __raw_writeq(value,ptr)
		when != iowrite8_rep(ptr,buf,count)
		when != iowrite16_rep(ptr,buf,count)
		when != iowrite32_rep(ptr,buf,count)
		when != iowrite64_rep(ptr,buf,count)
		when != memcpy_toio(ptr,buf,count)

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
	ioread8(ptr)@p2
|
	ioread16(ptr)@p2
|
	ioread32(ptr)@p2
|	
	ioread64(ptr)@p2
|
	readb(ptr)@p2
|	
	readw(ptr)@p2
|
	readl(ptr)@p2
|
	readq(ptr)@p2
|
	__raw_readb(ptr)@p2
|	
	__raw_readw(ptr)@p2
|
	__raw_readl(ptr)@p2
|
	__raw_readq(ptr)@p2
|
	ioread8_rep(dst2,ptr,count2)@p2
|
	ioread16_rep(dst2,ptr,count2)@p2
|
	ioread32_rep(dst2,ptr,count2)@p2
|
	ioread64_rep(dst2,ptr,count2)@p2
|
	memcpy_fromio(dst2,ptr,count2)@p2
)


@script:python@
p11 << identify2.p1;
p12 << identify2.p2;
@@

import tool
if p11 and p12:
	print "[identify2][1st]: ",p11[0].line
	print "[identify2][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_identified_files(p11[0].file, p11[0].line, p12[0].line, count)






@identify3@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count;
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
	ioread8_rep(dst1,src,count1)@p1
|
	ioread16_rep(dst1,src,count1)@p1
|
	ioread32_rep(dst1,src,count1)@p1
|
	ioread64_rep(dst1,src,count1)@p1
|
	memcpy_fromio(dst1,src,count1)@p1
)

	 ... when any
		when != iowrite8(value,ptr)
		when != iowrite16(value,ptr)
		when !=	iowrite32(value,ptr)
		when != iowrite64(value,ptr)
		when !=	writeb(value,ptr)	
		when !=	writew(value,ptr)
		when != writel(value,ptr)
		when != writeq(value,ptr)
		when != __raw_writeb(value,ptr)
		when !=	__raw_writew(value,ptr)
		when != __raw_writel(value,ptr)
		when != __raw_writeq(value,ptr)
		when != iowrite8_rep(ptr,buf,count)
		when != iowrite16_rep(ptr,buf,count)
		when != iowrite32_rep(ptr,buf,count)
		when != iowrite64_rep(ptr,buf,count)
		when != memcpy_toio(ptr,buf,count)

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
	ioread8(ptr)@p2
|
	ioread16(ptr)@p2
|
	ioread32(ptr)@p2
|	
	ioread64(ptr)@p2
|
	readb(ptr)@p2
|	
	readw(ptr)@p2
|
	readl(ptr)@p2
|
	readq(ptr)@p2
|
	__raw_readb(ptr)@p2
|	
	__raw_readw(ptr)@p2
|
	__raw_readl(ptr)@p2
|
	__raw_readq(ptr)@p2
|
	ioread8_rep(dst2,ptr,count2)@p2
|
	ioread16_rep(dst2,ptr,count2)@p2
|
	ioread32_rep(dst2,ptr,count2)@p2
|
	ioread64_rep(dst2,ptr,count2)@p2
|
	memcpy_fromio(dst2,ptr,count2)@p2
)


@script:python@
p11 << identify3.p1;
p12 << identify3.p2;
@@

import tool
if p11 and p12:
	print "[identify3][1st]: ",p11[0].line
	print "[identify3][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_identified_files(p11[0].file, p11[0].line, p12[0].line, count)




@identify4@
expression dst1,dst2,src,ptr,buf,value,count1,count2,count;
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
	ioread8(ptr)@p1
|
	ioread16(ptr)@p1
|
	ioread32(ptr)@p1
|	
	ioread64(ptr)@p1
|
	readb(ptr)@p1
|	
	readw(ptr)@p1
|
	readl(ptr)@p1
|
	readq(ptr)@p1
|
	__raw_readb(ptr)@p1
|	
	__raw_readw(ptr)@p1
|
	__raw_readl(ptr)@p1
|
	__raw_readq(ptr)@p1
|
	ioread8_rep(dst2,ptr,count1)@p1
|
	ioread16_rep(dst2,ptr,count1)@p1
|
	ioread32_rep(dst2,ptr,count1)@p1
|
	ioread64_rep(dst2,ptr,count1)@p1
|
	memcpy_fromio(dst2,ptr,count1)@p1
)

	 ... when any
	 	when != iowrite8(value,ptr)
		when != iowrite16(value,ptr)
		when !=	iowrite32(value,ptr)
		when != iowrite64(value,ptr)
		when !=	writeb(value,ptr)	
		when !=	writew(value,ptr)
		when != writel(value,ptr)
		when != writeq(value,ptr)
		when != __raw_writeb(value,ptr)
		when !=	__raw_writew(value,ptr)
		when != __raw_writel(value,ptr)
		when != __raw_writeq(value,ptr)
		when != iowrite8_rep(ptr,buf,count)
		when != iowrite16_rep(ptr,buf,count)
		when != iowrite32_rep(ptr,buf,count)
		when != iowrite64_rep(ptr,buf,count)
		when != memcpy_toio(ptr,buf,count)

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
	ioread8_rep(dst1,src,count2)@p2
|
	ioread16_rep(dst1,src,count2)@p2
|
	ioread32_rep(dst1,src,count2)@p2
|
	ioread64_rep(dst1,src,count2)@p2
|
	memcpy_fromio(dst1,src,count2)@p2
)


@script:python@
p11 << identify4.p1;
p12 << identify4.p2;
@@

import tool
if p11 and p12:
	print "[identify3][1st]: ",p11[0].line
	print "[identify3][2nd]: ",p12[0].line

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"

	tool.record_identified_files(p11[0].file, p11[0].line, p12[0].line, count)

