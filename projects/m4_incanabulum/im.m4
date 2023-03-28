divert(-1)
define(Cmt,`')
define(CInc1,``#'include<$1>
')
define(CInc,`ifelse($#,1,`CInc1($1)',`CInc1($1)CInc(shift($@))')')Cmt(`Include list')
define(C,`unsigned char')
define(I,`int64_t')define(IFmt,`"%ld "')
define(W,`int64_t')define(WFmt,`"$ld "')
define(Pr,`printf($@)')
define(R,`return')define(RIf,`if ($1) return $2')
define(V,`void')
define(V1,`A $1(A w)')Cmt(`Monadic function header')
define(V2, `A $1(A a, A w)')Cmt(`Dyadic function header')
define(DO, `{I i=0;I _n=($1);for(;i<_n;++i){$2;};}')
divert

