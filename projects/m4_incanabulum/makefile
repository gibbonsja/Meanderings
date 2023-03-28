CC=gcc

ji:	ji.c
	${CC} -g ji.c -o ji | tee ji.txt

ji.c:	ji.m4 im.m4
	m4 im.m4 ji.m4 > ji.c

