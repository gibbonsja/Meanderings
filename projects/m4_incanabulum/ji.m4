CInc(`stdio.h',`stdlib.h',`string.h',`sys/types.h',`setjmp.h')

static jmp_buf errb;

typedef struct _a{I t,r,d[3]; W p[2];}*A;
define(A_d,`$1->d')define(A_p,`$1->p')define(A_t,`$1->t')define(A_r,`$1->r')dnl

I *ma(I n){R (I *)malloc(n*sizeof(I));}
V mv(I *d,W *s,I n){DO(n,d[i]=s[i])}
I tr(I r,I* d){I z=1;DO(r,z=z*d[i]);R z;}Cmt(`Tally')
A ga(I t,I r,I *d){A z=(A)ma(5+tr(r,d));A_t(z)=t,A_r(z)=r,mv(A_d(z),d,r);R z;}

V pi(I i){Pr(IFmt,i);}
V nl(){Pr("\n");}
I pr(A w){I r=w->r,*d=w->d,n=tr(r,d);if(w->t)DO(n,Pr(`"< "');pr((A)(A_p(w)[i])))else DO(n,`pi(A_p(w)[i])');nl();R 0;}

V1(`null1'){Pr("** Missing monadic operator\n"); fflush(stdout);longjmp(errb,0);R ga(0,0,0);}
V1(`iota'){I n=*A_p(w);A z=ga(0,1,&n);DO(n,A_p(z)[i]=i);R z;}
V1(`sha'){A z=ga(0,1,&A_r(w));mv(A_p(z),A_d(w),A_r(w));R z;}
V1(`id'){R w;}
V1(`size'){A z=ga(0,0,0);*A_p(z)=A_r(w)?*A_d(w):1;R z;}
V1(`box'){A z=ga(1,0,0);*A_p(z)=(I)w;R z;}

V2(`null2'){Pr("** Missing dyadic operator\n"); fflush(stdout); longjmp(errb,0);R ga(0,0,0);}
V2(`plus'){I r=A_r(w),*d=A_d(w),n=tr(r,d);A z=ga(0,r,d);DO(n,A_p(z)[i]=A_p(a)[i]+A_p(w)[i]);R z;}
V2(`from'){I r=w->r-1,*d=w->d+1,n=tr(r,d);A z=ga(w->t,r,d);mv(z->p,w->p+(n**a->p),n);R z;}
V2(`cat'){I an=tr(a->r,a->d),wn=tr(w->r,w->d),n=an+wn;A z=ga(w->t,1,&n);mv(z->p,a->p,an);mv(z->p+an,w->p,wn);R z;}
V2(`find'){R NULL;}
V2(`rsh'){I r=a->r?*a->d:1,n=tr(r,a->p),wn=tr(w->r,w->d);A z=ga(w->t,r,a->p);mv(z->p,w->p,wn=n>wn?wn:n);if(n-=wn)mv(z->p+wn,z->p,n);R z;}

C vt[]="+{~<#,";
A (*vd[])()={null2,plus,from,find,0,rsh,cat};
A (*vm[])()={null1,id,size,iota,box,sha,0};
I verb(C c){I i=0;for(;vt[i];)if(vt[i++]==c)R i; R 0;}

I st[26];

I qp(I a){R a>='a'&&a<='z';}
I qv(I a){R a<'a';}

A ex(I *e){I a=*e,v;
 if(qp(a)){RIf(e[1]=='=',(A)(st[a-'a']=(I)ex(e+2)));a= st[ a-'a'];}
 RIf(qv(a),(A)(*vm[a])((A)ex(e+1)));
 RIf(e[1], (A)(*vd[e[1]])((A)a,(A)ex(e+2)));
 R (A)a;}

I noun(C c){A z;RIf(c<'0'||c>'9',0);z=ga(0,0,0);*A_p(z)=c-'0';R (I)z;}

C* tkns(C *s) {C *p=s,*q=s;for(;*p!=0;p++){if(*p>' ')*q++=*p;};*q++=0;R s;}
I *wd(C* s){I a,n=strlen((char*)s),*e=ma(n+1);C c; DO(n,e[i]=(a=noun(c=s[i]))?a:(a=verb(c))?a:c);e[n]=0;R e;}

C *prompt(C p,C *b,I n) {C* s; Pr("%c",p);fflush(stdout);R (C*)fgets((char*)b, n, stdin);}
int main(){C s[99]; setjmp(errb); while(prompt('>', s, 98)){ pr(ex(wd(tkns(s))));};R 0;}
