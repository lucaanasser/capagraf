# capagraf.cls

Classe LaTeX para geração de capas de livro prontas para impressão (capa, contracapa e lombada) em uma única página A3 landscape, com sangrias, sulcos e marcações de corte automáticas.

> Compile com **LuaLaTeX**.

---

## Instalação

Coloque `capagraf.cls` na mesma pasta do seu `.tex`.

---

## Uso básico

```latex
\documentclass[
  largura=148, altura=210,
  paginas=600, gramatura=75,
  sangria=5,   sulco=5,
  corSulco=666666
]{capagraf}

\begin{capa}
  \cgFundo{1B6B7B}
  % conteúdo da capa
\end{capa}

\begin{contracapa}
  \cgFundo{1B6B7B}
  % sinopse, ISBN etc.
\end{contracapa}

\begin{lombada}
  \cgFundo{D4A96A}
  % título e autor
\end{lombada}

\begin{document}
  \gerarCapa
\end{document}
```

Os ambientes são declarados **antes** do `\begin{document}`. O comando `\gerarCapa` monta e renderiza tudo.

---

## Principais utilitários

| Comando | Descrição |
|---|---|
| `\cgFundo{HEX}` | Cor de fundo da zona |
| `\cgImagemFundo{arquivo}` | Imagem de fundo (área viva) |
| `\cgSeparador[HEX]{esp}{vspace}` | Linha horizontal decorativa |
| `\cgVfill` | Espaço elástico vertical |
| `\cgVspace{fração}` | Espaço proporcional à altura |
| `\begin{cgMargens}{t}{r}{b}{l}` | Margens internas em mm (capa/contracapa) |
| `\begin{cgMargensLombada}{t}{b}` | Margens nas extremidades da lombada |

---

Para documentação completa consulte o **manual**.