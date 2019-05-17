# aadp
Implementação de um agente aspirador de pó em Prolog

# Execução
Para fazer uma consulta para a solução do problema, basta passar uma das seguintes consultas para o interpretador de Prolog:
- `solucao_bl(EstadoInicial, Solucao)`
- `solucao_bp(EstadoInicial, Solucao)`

onde EstadoInicial é `[[[Xinicial, Yinicial], Nsujeiras], Cenario]` e Cenario é ```
[[Xmaximo,Ymaximo],[Sujeira1..SujeiraN],[Xelevador1..XelevadorN],[Parede1...ParedeN],[Xdock,Ydock],[Xlixeira,Ylixeira],NsujeirasMaximo]```
