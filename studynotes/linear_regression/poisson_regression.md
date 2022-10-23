# ポアソン回帰
overで書いたやつ  
$$ {2 \over 3} $$  
fracで書いたやつ  
$$ \frac{2}{3} $$  

euler: $e^{i\pi}=-1$
回帰により求めたいパラメータのベクトル $\boldsymbol{\beta}$ を最尤推定法により求める。<br>
最急降下法で計算するものとする。<br>
ポアソン分布  
$$ P(y|\lambda)= {\lambda^{y}e^{\lambda} \over y!} $$  
に関し、
$$
\lambda = \exp {\boldsymbol{x} \boldsymbol{\beta}}
$$
として、尤度関数
$$
l_ {\boldsymbol{x} ,y}(\boldsymbol{\beta})= \frac{\lambda^{y}e^{\lambda}}{y!}
$$
を最大にする $\boldsymbol{\hat{\beta}}$ を求める。

