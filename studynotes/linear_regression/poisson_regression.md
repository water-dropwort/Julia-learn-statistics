<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
# ポアソン回帰
回帰により求めたいパラメータのベクトル$\bm{\beta}$を最尤推定法により求める。<br>
最急降下法で計算するものとする。<br>
ポアソン分布
$$ P(y|\lambda)= \frac{\lambda^{y}e^{\lambda}}{y!} $$
に関し、$$ \lambda = \exp {\bm{x} \bm{\beta}} $$として、尤度関数
$$ l_ {\boldsymbol{x} ,y}(\boldsymbol{\beta})= \frac{\lambda^{y}e^{\lambda}}{y!} $$
を最大にする$\bm{\hat{\beta}}$を求める。

