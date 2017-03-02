
//---------------------
@switch_read exists@
expression dst,src,count,value;
position p1;
@@
		
(	
-	ioread8(src)@p1
+	read_wrapper(src)
|
-	ioread16(src)@p1
+	read_wrapper(src)	
|
-	ioread32(src)@p1
+	read_wrapper(src)
|	
-	ioread64(src)@p1
+	read_wrapper(src)
|
-	readb(src)@p1
+	read_wrapper(src)
|	
-	readw(src)@p1
+	read_wrapper(src)
|
-	readl(src)@p1
+	read_wrapper(src)
|
-	readq(src)@p1
+	read_wrapper(src)
|
-	__raw_readb(src)@p1
+	read_wrapper(src)
|	
-	__raw_readw(src)@p1
+	read_wrapper(src)
|
-	__raw_readl(src)@p1
+	read_wrapper(src)
|
-	__raw_readq(src)@p1
+	read_wrapper(src)
|
-	ioread8_rep(dst,src,count)@p1
+	block_read_wrapper(dst,src,count)
|
-	ioread16_rep(dst,src,count)@p1
+	block_read_wrapper(dst,src,count)
|
-	ioread32_rep(dst,src,count)@p1
+	block_read_wrapper(dst,src,count)
|
-	ioread64_rep(dst,src,count)@p1
+	block_read_wrapper(dst,src,count)
|
-	memcpy_fromio(dst,src,count)@p1
+	block_read_wrapper(dst,src,count)
)


@script:python@
p11 << switch_read.p1;
@@

if p11 :
	print "Read wrapper function at line:", p11[0].line



@switch_write exists@
expression dst,src,count,value;
position p1;
@@
		
(
-	iowrite8(value,src)@p1
+	write_wrapper(value,src)
|
-	iowrite16(value,src)@p1
+	write_wrapper(value,src)
|
-	iowrite32(value,src)@p1
+	write_wrapper(value,src)
|	
-	iowrite64(value,src)@p1
+	write_wrapper(value,src)
|
-	writeb(value,src)@p1
+	write_wrapper(value,src)
|	
-	writew(value,src)@p1
+	write_wrapper(value,src)
|
-	writel(value,src)@p1
+	write_wrapper(value,src)
|
-	writeq(value,src)@p1
+	write_wrapper(value,src)
|
-	__raw_writeb(value,src)@p1
+	write_wrapper(value,src)
|	
-	__raw_writew(value,src)@p1
+	write_wrapper(value,src)
|
-	__raw_writel(value,src)@p1
+	write_wrapper(value,src)
|
-	__raw_writeq(value,src)@p1
+	write_wrapper(value,src)
|
-	iowrite8_rep(dst,src,count)@p1
+	block_write_wrapper(dst,src,count)
|
-	iowrite16_rep(dst,src,count)@p1
+	block_write_wrapper(dst,src,count)
|
-	iowrite32_rep(dst,src,count)@p1
+	block_write_wrapper(dst,src,count)
|
-	iowrite64_rep(dst,src,count)@p1
+	block_write_wrapper(dst,src,count)
|
-	memcpy_toio(dst,src,count)@p1
+	block_write_wrapper(dst,src,count)
)



@script:python@
p11 << switch_write.p1;
@@

if p11 :
	print "Write wrapper function at line:", p11[0].line
	


