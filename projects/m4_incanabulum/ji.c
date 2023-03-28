

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<setjmp.h>


static jmp_buf errb;

typedef struct _a{int64_t t,r,d[3]; int64_t p[2];}*A;

int64_t *ma(int64_t n){return (int64_t *)malloc(n*sizeof(int64_t));}
void mv(int64_t *d,int64_t *s,int64_t n){{int64_t i=0;int64_t _n=(n);for(;i<_n;++i){d[i]=s[i];};}}
int64_t tr(int64_t r,int64_t* d){int64_t z=1;{int64_t i=0;int64_t _n=(r);for(;i<_n;++i){z=z*d[i];};};return z;}
A ga(int64_t t,int64_t r,int64_t *d){A z=(A)ma(5+tr(r,d));z->t=t,z->r=r,mv(z->d,d,r);return z;}

void pi(int64_t i){printf("%ld ",i);}
void nl(){printf("\n");}
int64_t pr(A w){int64_t r=w->r,*d=w->d,n=tr(r,d);if(w->t){int64_t i=0;int64_t _n=(n);for(;i<_n;++i){printf("< ");pr((A)(w->p[i]));};}else {int64_t i=0;int64_t _n=(n);for(;i<_n;++i){pi(w->p[i]);};};nl();return 0;}

A null1(A w){printf("** Missing monadic operator\n"); fflush(stdout);longjmp(errb,0);return ga(0,0,0);}
A iota(A w){int64_t n=*w->p;A z=ga(0,1,&n);{int64_t i=0;int64_t _n=(n);for(;i<_n;++i){z->p[i]=i;};};return z;}
A sha(A w){A z=ga(0,1,&w->r);mv(z->p,w->d,w->r);return z;}
A id(A w){return w;}
A size(A w){A z=ga(0,0,0);*z->p=w->r?*w->d:1;return z;}
A box(A w){A z=ga(1,0,0);*z->p=(int64_t)w;return z;}

A null2(A a, A w){printf("** Missing dyadic operator\n"); fflush(stdout); longjmp(errb,0);return ga(0,0,0);}
A plus(A a, A w){int64_t r=w->r,*d=w->d,n=tr(r,d);A z=ga(0,r,d);{int64_t i=0;int64_t _n=(n);for(;i<_n;++i){z->p[i]=a->p[i]+w->p[i];};};return z;}
A from(A a, A w){int64_t r=w->r-1,*d=w->d+1,n=tr(r,d);A z=ga(w->t,r,d);mv(z->p,w->p+(n**a->p),n);return z;}
A cat(A a, A w){int64_t an=tr(a->r,a->d),wn=tr(w->r,w->d),n=an+wn;A z=ga(w->t,1,&n);mv(z->p,a->p,an);mv(z->p+an,w->p,wn);return z;}
A find(A a, A w){return NULL;}
A rsh(A a, A w){int64_t r=a->r?*a->d:1,n=tr(r,a->p),wn=tr(w->r,w->d);A z=ga(w->t,r,a->p);mv(z->p,w->p,wn=n>wn?wn:n);if(n-=wn)mv(z->p+wn,z->p,n);return z;}

unsigned char vt[]="+{~<#,";
A (*vd[])()={null2,plus,from,find,0,rsh,cat};
A (*vm[])()={null1,id,size,iota,box,sha,0};
int64_t verb(unsigned char c){int64_t i=0;for(;vt[i];)if(vt[i++]==c)return i; return 0;}

int64_t st[26];

int64_t qp(int64_t a){return a>='a'&&a<='z';}
int64_t qv(int64_t a){return a<'a';}

A ex(int64_t *e){int64_t a=*e,v;
 if(qp(a)){if (e[1]=='=') return (A)(st[a-'a']=(int64_t)ex(e+2));a= st[ a-'a'];}
 if (qv(a)) return (A)(*vm[a])((A)ex(e+1));
 if (e[1]) return (A)(*vd[e[1]])((A)a,(A)ex(e+2));
 return (A)a;}

int64_t noun(unsigned char c){A z;if (c<'0'||c>'9') return 0;z=ga(0,0,0);*z->p=c-'0';return (int64_t)z;}

unsigned char* tkns(unsigned char *s) {unsigned char *p=s,*q=s;for(;*p!=0;p++){if(*p>' ')*q++=*p;};*q++=0;return s;}
int64_t *wd(unsigned char* s){int64_t a,n=strlen((char*)s),*e=ma(n+1);unsigned char c; {int64_t i=0;int64_t _n=(n);for(;i<_n;++i){e[i]=(a=noun(c=s[i]))?a:(a=verb(c))?a:c;};};e[n]=0;return e;}

unsigned char *prompt(unsigned char p,unsigned char *b,int64_t n) {unsigned char* s; printf("%c",p);fflush(stdout);return (unsigned char*)fgets((char*)b, n, stdin);}
int main(){unsigned char s[99]; setjmp(errb); while(prompt('>', s, 98)){ pr(ex(wd(tkns(s))));};return 0;}
