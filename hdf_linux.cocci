
//---------------------
@ rule1 disable drop_cast exists @
expression src, value, offset, addr;
position p1,p2;
type T1,T2;
@@

	...	
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
-	ioread8(src)@p2
+	read_wrapper(src)
|
-	ioread16(src)@p2
+	read_wrapper(src)	
|
-	ioread32(src)@p2
+	read_wrapper(src)
|	
-	ioread64(src)@p2
+	read_wrapper(src)
|
-	readb(src)@p2
+	read_wrapper(src)
|	
-	readw(src)@p2
+	read_wrapper(src)
|
-	readl(src)@p2
+	read_wrapper(src)
|
-	readq(src)@p2
+	read_wrapper(src)
|
-	__raw_readb(src)@p2
+	read_wrapper(src)
|	
-	__raw_readw(src)@p2
+	read_wrapper(src)
|
-	__raw_readl(src)@p2
+	read_wrapper(src)
|
-	__raw_readq(src)@p2
+	read_wrapper(src)
)	

	...
	

@script:python@
p11 << rule1.p1;
p12 << rule1.p2;
@@

if p11 and p12:
	print p11[0].file
	print p11[0].line
	print p12[0].line


