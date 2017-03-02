@prune disable drop_cast exists@
expression src,count;
position p1,p2;
@@
	...
(
	read_wrapper(src);
	... when any
	read_wrapper(src);
|
	read_wrapper(src);
	... when any
	read_wrapper(src);