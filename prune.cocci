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
|
	(void)read_wrapper(src);@p1
)

@script:python@
p << prune1.p1;
@@

import tool
if p:
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file,' unused read wrapper line: ', p[0].line
	tool.delete_one_fetch_line(p[0].file, p[0].line)




@prune2@
expression src;
position p1;
@@

(
	write_wrapper(<+...read_wrapper(src)@p1...+>,src) 
|
	writel_relaxed(<+...read_wrapper(src)@p1...+>,src) 
|
	cy_writel(src,<+...read_wrapper(src)@p1...+>) 
)

@script:python@
p << prune2.p1;
@@

import tool
if p:

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file, ' write(read) line: ', p[0].line 

	tool.delete_one_fetch_line(p[0].file, p[0].line)



@prune3@
expression src,o1,o2;
position p1,p2;
@@


	read_wrapper(src)<<o1 @p1
	... when any
	read_wrapper(src)<<o2 @p2


@script:python@
p1 << prune3.p1;
p2 << prune3.p2;
@@

import tool
if p1 and p2:

	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p1[0].file, 'Serial Read: read() << offset : [', p1[0].line,',', p2[0].line,']'

	tool.delete_two_fetch_lines(p1[0].file, p1[0].line,p2[0].line)
	tool.delete_one_fetch_line(p1[0].file, p1[0].line)
	tool.delete_one_fetch_line(p2[0].file, p2[0].line)


@prune4@
expression src,r1,r2,mask;
position p1,p2;
identifier i1,i2;
@@

(
	r1 = read_wrapper(src)@p1 ;
	r2 = read_wrapper(src)@p2 ; 
|
	r1 = read_wrapper(src)@p1 ;
	r2 = read_wrapper(src)@p2 & mask;
|
	u32 i1 = read_wrapper(src)@p1 & mask;
	u32 i2 = read_wrapper(src)@p2 & mask;
|
	u32 i1 = read_wrapper(src)@p1;
	u32 i2 = read_wrapper(src)@p2;
|
	uint16_t i1 = read_wrapper(src)@p1;
	uint16_t i2 = read_wrapper(src)@p2;
|
	r1 = read_wrapper(src)@p1 & mask;
	...
	r2 = read_wrapper(src)@p2 & mask;
)

@script:python@
p1 << prune4.p1;
p2 << prune4.p2;
@@

import tool
if p1 and p2:
	
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p1[0].file, 'Serial Read: l=read(),h=read() : [', p1[0].line,',', p2[0].line,']'

	tool.delete_two_fetch_lines(p1[0].file, p1[0].line,p2[0].line)
	tool.delete_one_fetch_line(p1[0].file, p1[0].line) #remove constant matches, cannot use when any here
	tool.delete_one_fetch_line(p2[0].file, p2[0].line)


@prune5@
expression src,temp,r1,mask,offset;
position p1,p2;
@@

(
	r1 |= read_wrapper(src)@p1 << offset;
	r1 |= read_wrapper(src)@p2 & mask;
|
	r1 = read_wrapper(src)@p1 & mask;
	r1 |= read_wrapper(src)@p2 << offset;
|
	r1 = read_wrapper(src)@p1 << offset;
	r1 |= read_wrapper(src)@p2;
|
	r1 = read_wrapper(src)@p1;
	r1 |= read_wrapper(src)@p2  << offset;
|
	r1 = (u32) read_wrapper(src)@p1;
	...
	r1 |= ((u32)read_wrapper(src)@p2 ) << offset;
|
	temp = read_wrapper(src)@p1;
	r1 |= temp << offset;
	temp = read_wrapper(src)@p2;
|
	r1 = read_wrapper(src)@p1;
	r1 <<= offset;
	...
	r1 |= read_wrapper(src)@p2;
)

@script:python@
p1 << prune5.p1;
p2 << prune5.p2;
@@

import tool
if p1 and p2:
	
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p1[0].file, 'Serial Read:read()>>, read()&, [', p1[0].line,',',p2[0].line,']' 

	tool.delete_two_fetch_lines(p1[0].file, p1[0].line, p1[0].line)
	tool.delete_one_fetch_line(p1[0].file, p1[0].line) #remove constant matches, cannot use when any here
	tool.delete_one_fetch_line(p2[0].file, p2[0].line)

# Any fetch involves a display function should be abandoned,
# because it will not cause any security related problem
# Here we only consider display functions with up to 4 parameters.
@prune6@
expression src,e0,e1,e2,e3,e4,e5,e6;
position p1;
@@

(
	printk(e1,<+...read_wrapper(src)@p1...+>)
|
	printk(e1,e2,<+...read_wrapper(src)@p1...+>)
|
	printk(e1,<+...read_wrapper(src)@p1...+>,e2)
|
	printk(e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	printk(e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	printk(e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	printk(e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	printk(e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	printk(e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	printk(e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	netdev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>)//-------------
|
	netdev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	netdev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	netdev_dbg(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	netdev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	netdev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	netdev_dbg(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	netdev_dbg(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	netdev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	netdev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	pr_debug(e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	pr_debug(e1,e2,<+...read_wrapper(src)@p1...+>)
|
	pr_debug(e1,<+...read_wrapper(src)@p1...+>,e2)
|
	pr_debug(e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	pr_debug(e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	pr_debug(e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	pr_debug(e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	pr_debug(e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	pr_debug(e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	pr_debug(e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	DPRINTK(e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	DPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>)
|
	DPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2)
|
	DPRINTK(e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	DPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	DPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	DPRINTK(e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	DPRINTK(e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	DPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	DPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	VPRINTK(e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	VPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>)
|
	VPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2)
|
	VPRINTK(e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	VPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	VPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	VPRINTK(e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	VPRINTK(e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	VPRINTK(e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	VPRINTK(e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	vdev_err(e0,e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	vdev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	vdev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	vdev_err(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	vdev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	vdev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	vdev_err(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	vdev_err(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	vdev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	vdev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	dev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	dev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	dev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	dev_dbg(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	dev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	dev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	dev_dbg(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	dev_dbg(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	dev_dbg(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	dev_dbg(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	dev_info(e0,e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	dev_info(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	dev_info(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	dev_info(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	dev_info(e0,e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	dev_info(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	dev_info(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	dev_info(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	dev_info(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	dev_info(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	dev_warn(e0,e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	dev_warn(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	dev_warn(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	dev_warn(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	dev_warn(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	dev_warn(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	dev_warn(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	dev_warn(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	dev_warn(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	dev_warn(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	dev_err(e0,e1,<+...read_wrapper(src)@p1...+>)//-----------------
|
	dev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	dev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	dev_err(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>)
|
	dev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	dev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3)
|
	dev_err(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>)
|
	dev_err(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	dev_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	dev_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)

|
	PRINTK(e0,<+...read_wrapper(src)@p1...+>)
|
	snprintf(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	dev_debug(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4,e5)
|
	dev_debug(e0,e1,e2,e3,e4,<+...read_wrapper(src)@p1...+>,e5)
|
	dev_debug(e0,e1,e2,e3,e4,e5,<+...read_wrapper(src)@p1...+>)
|
	dprintk(e0,e1,<+...read_wrapper(src)@p1...+>,e2,e3,e4)
|
	dprintk(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3,e4)
|
	dprintk(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4)
|
	IPRINTK(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|
	IPRINTK(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	TXPRINTK(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	pch_dbg(e0,e1,<+...read_wrapper(src)@p1...+>)
|
	pmcraid_info(e0,<+...read_wrapper(src)@p1...+>,e1)
|
	S3C_PMDBG(e0,<+...read_wrapper(src)@p1...+>,e1)
|	
	pr_err(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|	
	pr_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>)
|	
	pr_err(e0,e1,e2,<+...read_wrapper(src)@p1...+>,e3)
|
	f_ddprintk(e0,e1,<+...read_wrapper(src)@p1...+>,e2)
|
	xhci_dbg(e0,e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4,e5,e6)
|
	printk(e1,e2,e3,<+...read_wrapper(src)@p1...+>,e4,e5)

)


@script:python@
p << prune6.p1;
@@

import tool
if p:
	
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file, ' display function: ', p[0].line 

	tool.delete_one_fetch_line(p[0].file, p[0].line)


# A part of the source address changed between the two fetches
# Then these two fetches are not fetching the same data, should be removed.
@prune7@
expression src,addr;
position p1,p2;
@@


	read_wrapper(<+...src...+>)@p1
	... when any
(
	src = addr
|
	src += addr
)
	... when any
	read_wrapper(<+...src...+>)@p2



@script:python@
p1 << prune7.p1;
p2 << prune7.p2;
@@

import tool
if p1 and p2:
	
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p1[0].file, ' Address changed (', p1[0].line,',',p2[0].line,')' 

	tool.delete_two_fetch_lines(p1[0].file, p1[0].line, p1[0].line)

# Remove the fetches that the fetched value is used for print
@prune8@
expression src,e0,e1,e2,e3,e4,e5,e6;
position p1,p2;
identifier value;
@@


(
	uint16_t value  = read_wrapper(src)@p1;
|
	value  = read_wrapper(src)@p1;
)
	... when any

(
	pr_debug(e0,e1,value,e2,e3)@p2;
|
	pr_debug(e0,e1,e2,value,e3)@p2;
|
	pr_debug(e0,e1,e2,e3,value)@p2;
|
	dev_dbg(e0,e1,value,e2,e3)@p2;
|
	dev_dbg(e0,e1,e2,value,e3)@p2;
|
	dev_dbg(e0,e1,e2,e3,value)@p2;
|
	printk(e0,e1,e2,e3,value,e4)@p2;
|
	printk(e0,e1,e2,e3,e4,value)@p2;
|
	dev_warn(e0,e1,value,e2,e3)@p2;
|
	dev_warn(e0,e1,e2,value,e3)@p2;
|
	dev_warn(e0,e1,e2,e3,value)@p2;
|
	dev_dbg(e0,e1,e2,value,e3,e4)@p2;
|
	dev_dbg(e0,e1,e2,e3,value,e4)@p2;
|
	dev_dbg(e0,e1,e2,e3,e4,value)@p2;
)
		



@script:python@
p << prune8.p1;
@@

import tool
if p:
	
	if count:
		count = str(int(count) + 1)
	else:
		count = "1"
	print '==>Prune: [',count,']', p[0].file, ' fetch for display: ', p[0].line 

	tool.delete_one_fetch_line(p[0].file, p[0].line)
