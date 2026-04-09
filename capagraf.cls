% ============================================================
%  capagraf.cls  v2.0
%  Classe LaTeX para geração de capas de livro
%
%  AMBIENTES (conteúdo livre de edição):
%    \begin{capa}        ... \end{capa}
%    \begin{contracapa}  ... \end{contracapa}
%    \begin{lombada}     ... \end{lombada}
%
%  OPÇÕES DO \documentclass:
%    largura=148   altura=210   paginas=600   gramatura=75
%    sangria=5     sulco=5
%
%  COMANDO FINAL:  \gerarCapa
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{capagraf}[2025/04/08 v2.0 Classe para capas de livro]

\LoadClass{article}

% ── Pacotes ──────────────────────────────────────────────────
\RequirePackage{iftex}
\RequirePackage{pgfopts}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{lmodern}
\RequirePackage{environ}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins, fitting}

\ifluatex
  \RequirePackage{fontspec}
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
\fi

% ── Geometria: A3 landscape, sem margens ────────────────────
\RequirePackage[paperwidth=420mm, paperheight=297mm, margin=0pt]{geometry}
\pagestyle{empty}
\setlength{\parindent}{0pt}

% ════════════════════════════════════════════════════════════
%  OPÇÕES DA CLASSE
% ════════════════════════════════════════════════════════════
\newcommand{\cg@largura}{148}
\newcommand{\cg@altura}{210}
\newcommand{\cg@paginas}{300}
\newcommand{\cg@gramatura}{75}
\newcommand{\cg@sangria}{5}
\newcommand{\cg@sulco}{5}
\newcommand{\cg@corSulco}{666666}
\newcommand{\cg@espessuraPorFolha}{0.10}

\pgfkeys{
  /capagraf/.cd,
  largura/.store in   = \cg@largura,
  altura/.store in    = \cg@altura,
  paginas/.store in   = \cg@paginas,
  gramatura/.store in = \cg@gramatura,
  sangria/.store in   = \cg@sangria,
  sulco/.store in     = \cg@sulco,
  corSulco/.store in  = \cg@corSulco,
}
\ProcessPgfPackageOptions{/capagraf}

% ════════════════════════════════════════════════════════════
%  COMPRIMENTOS GLOBAIS (definidos em \gerarCapa)
% ════════════════════════════════════════════════════════════
\newlength{\cgCW}    % largura da capa
\newlength{\cgCH}    % altura da capa
\newlength{\cgSP}    % lombada
\newlength{\cgBL}    % sangria
\newlength{\cgHG}    % sulco
\newlength{\cgTW}    % largura total
\newlength{\cgTH}    % altura total
\newlength{\cgCML}
\newlength{\cgCMO}

% ════════════════════════════════════════════════════════════
%  ARMAZENAMENTO DOS AMBIENTES
% ════════════════════════════════════════════════════════════
\newcommand{\cg@conteudoCapa}{}
\newcommand{\cg@conteudoContracapa}{}
\newcommand{\cg@conteudoLombada}{}

\newif\ifcg@temCapa       \cg@temCapafalse
\newif\ifcg@temContracapa \cg@temContracapafalse
\newif\ifcg@temLombada    \cg@temLombadafalse

% ════════════════════════════════════════════════════════════
%  AMBIENTES PÚBLICOS
% ════════════════════════════════════════════════════════════

\NewEnviron{capa}{%
  \global\cg@temCapatrue
  \global\let\cg@conteudoCapa\BODY
}{}

\NewEnviron{contracapa}{%
  \global\cg@temContracapatrue
  \global\let\cg@conteudoContracapa\BODY
}{}

\NewEnviron{lombada}{%
  \global\cg@temLombadatrue
  \global\let\cg@conteudoLombada\BODY
}{}

% ════════════════════════════════════════════════════════════
%  UTILITÁRIOS PARA USO DENTRO DOS AMBIENTES
% ════════════════════════════════════════════════════════════

% \cgFundo{HEXCOR}
\newcommand{\cgFundo}[1]{%
  \definecolor{cg@@fundo}{HTML}{#1}%
  \tcbset{colback=cg@@fundo}%
  \ignorespaces
}

% \cgImagemFundo{arquivo}
\newcommand{\cgImagemFundo}[1]{%
  \tcbset{
    enhanced,
    underlay={\node[inner sep=0, anchor=south west] at (interior.south west)
      {\includegraphics[width=\tcbtextwidth, height=\tcbtextheight,
       keepaspectratio=false]{#1}};},
  }%
  \ignorespaces
}

% \cgSeparador[HEXCOR]{espessura}{vspace}
\newcommand{\cgSeparador}[3][FFFFFF]{%
  \par\vspace{#3}%
  {\color[HTML]{#1}\rule{\linewidth}{#2}}%
  \par\vspace{#3}%
}

% \cgVspace{fração} — fração da altura da capa
\newcommand{\cgVspace}[1]{\vspace{#1\cgCH}}

% \cgVfill — espaço elástico
\newcommand{\cgVfill}{\vfill}

% \begin{cgMargens}{top mm}{right mm}{bottom mm}{left mm}
\NewEnviron{cgMargens}[4]{%
  \vspace*{#1mm}%
  \noindent\hspace*{#4mm}%
  \begin{minipage}[t]{\dimexpr\linewidth-#2mm-#4mm\relax}%
    \BODY
  \end{minipage}%
  \vspace*{#3mm}%
}{}

% \begin{cgMargensLombada}{top mm}{bottom mm}
\NewEnviron{cgMargensLombada}[2]{%
  \noindent\hspace*{#2mm}%
  \begin{minipage}[c]{\dimexpr\linewidth-#1mm-#2mm\relax}%
    \BODY
  \end{minipage}%
}{}

% ════════════════════════════════════════════════════════════
%  TABELA DE ESPESSURA
% ════════════════════════════════════════════════════════════
\newcommand{\cg@calcEspessura}{%
  \ifthenelse{\equal{\cg@gramatura}{56}}{\renewcommand{\cg@espessuraPorFolha}{0.07}}{}%
  \ifthenelse{\equal{\cg@gramatura}{60}}{\renewcommand{\cg@espessuraPorFolha}{0.08}}{}%
  \ifthenelse{\equal{\cg@gramatura}{75}}{\renewcommand{\cg@espessuraPorFolha}{0.10}}{}%
  \ifthenelse{\equal{\cg@gramatura}{90}}{\renewcommand{\cg@espessuraPorFolha}{0.12}}{}%
  \ifthenelse{\equal{\cg@gramatura}{115}}{\renewcommand{\cg@espessuraPorFolha}{0.15}}{}%
}

% ════════════════════════════════════════════════════════════
%  MACRO INTERNA: renderiza zona via tcolorbox no TikZ
% ════════════════════════════════════════════════════════════
\newcommand{\cg@renderZona}[5]{%
  \node[inner sep=0pt, anchor=south west] at (#1) {%
    \begin{tcolorbox}[
      enhanced,
      width       = #2,
      height      = #3,
      colback     = black,
      colframe    = black,
      boxrule     = 0pt,
      arc         = 0pt,
      outer arc   = 0pt,
      top         = 4mm,
      bottom      = 4mm,
      left        = 6mm,
      right       = 6mm,
      valign      = top,
      rotate      = #5,
    ]%
      #4%
    \end{tcolorbox}%
  };%
}

% ════════════════════════════════════════════════════════════
%  \gerarCapa
% ════════════════════════════════════════════════════════════
\newcommand{\gerarCapa}{%

  \cg@calcEspessura

  \pgfmathsetmacro{\cg@lombadaVal}{\cg@paginas * \cg@espessuraPorFolha / 2}

  \setlength{\cgCW}{\cg@largura mm}
  \setlength{\cgCH}{\cg@altura mm}
  \setlength{\cgSP}{\cg@lombadaVal mm}
  \setlength{\cgBL}{\cg@sangria mm}
  \setlength{\cgHG}{\cg@sulco mm}
  \setlength{\cgCML}{8mm}
  \setlength{\cgCMO}{3mm}
  \setlength{\cgTW}{\dimexpr 2\cgCW + \cgSP + 2\cgHG + 2\cgBL\relax}
  \setlength{\cgTH}{\dimexpr \cgCH + 2\cgBL\relax}

  \definecolor{cgCutMark}{HTML}{FF0000}
  \definecolor{cgGrid}{HTML}{AAAAAA}

  \noindent
  \begin{tikzpicture}[remember picture, overlay]

    \coordinate (cgO) at ($(current page.center)-(0.5\cgTW,0.5\cgTH)$);

    % — Coordenadas —
    \coordinate (cgFullBL)  at (cgO);
    \coordinate (cgFullTR)  at ($(cgO)+(\cgTW,\cgTH)$);

    \coordinate (cgBackBL)  at ($(cgO)+(\cgBL,\cgBL)$);
    \coordinate (cgBackTR)  at ($(cgO)+(\cgBL+\cgCW,\cgBL+\cgCH)$);
    \coordinate (cgBackTL)  at ($(cgBackBL)+(0,\cgCH)$);

    \coordinate (cgHL_BL)   at ($(cgO)+(\cgBL+\cgCW,\cgBL)$);
    \coordinate (cgHL_TR)   at ($(cgO)+(\cgBL+\cgCW+\cgHG,\cgBL+\cgCH)$);

    \coordinate (cgSpBL)    at ($(cgO)+(\cgBL+\cgCW+\cgHG,\cgBL)$);
    \coordinate (cgSpTR)    at ($(cgO)+(\cgBL+\cgCW+\cgHG+\cgSP,\cgBL+\cgCH)$);
    \coordinate (cgSpBLtop) at ($(cgSpBL)+(0,\cgCH)$);
    \coordinate (cgSpTRbot) at ($(cgSpTR)+(0,-\cgCH)$);

    \coordinate (cgHR_BL)   at ($(cgO)+(\cgBL+\cgCW+\cgHG+\cgSP,\cgBL)$);
    \coordinate (cgHR_TR)   at ($(cgO)+(\cgBL+\cgCW+2\cgHG+\cgSP,\cgBL+\cgCH)$);

    \coordinate (cgFrBL)    at ($(cgO)+(\cgBL+\cgCW+2\cgHG+\cgSP,\cgBL)$);
    \coordinate (cgFrTR)    at ($(cgO)+(\cgBL+2\cgCW+2\cgHG+\cgSP,\cgBL+\cgCH)$);
    \coordinate (cgFrBR)    at ($(cgFrBL)+(\cgCW,0)$);

    % ════════════════════════════════════════════════════════
    %  CONTRACAPA
    % ════════════════════════════════════════════════════════
    \ifcg@temContracapa
      \node[inner sep=0pt, anchor=south west] at (cgFullBL){%
        \begin{tcolorbox}[
          enhanced,
          width    = \dimexpr\cgBL+\cgCW+\cgHG\relax,
          height   = \cgTH,
          colback  = black,
          colframe = black,
          boxrule  = 0pt, arc=0pt, outer arc=0pt,
          top      = \the\cgBL,
          bottom   = \the\cgBL,
          left     = \the\cgBL,
          right    = \the\cgHG,
          valign   = top,
        ]%
          \cg@conteudoContracapa
        \end{tcolorbox}%
      };
    \fi

    % ════════════════════════════════════════════════════════
    %  LOMBADA
    % ════════════════════════════════════════════════════════
    \ifcg@temLombada
      \node[inner sep=0pt, anchor=center]
        at ($(cgO)+(\cgBL+\cgCW+\cgHG+0.5\cgSP, 0.5\cgTH)$){%
          \rotatebox{90}{%
            \begin{tcolorbox}[
              enhanced,
              width    = \cgTH,
              height   = \cgSP,
              colback  = black,
              colframe = black,
              boxrule  = 0pt, arc=0pt, outer arc=0pt,
              top      = 0pt,
              bottom   = 0pt,
              left     = \the\cgBL,
              right    = \the\cgBL,
              valign   = center,
            ]%
              \cg@conteudoLombada
            \end{tcolorbox}%
          }%
        };
    \fi

    % ════════════════════════════════════════════════════════
    %  CAPA
    % ════════════════════════════════════════════════════════
    \ifcg@temCapa
      \node[inner sep=0pt, anchor=south west]
        at ($(cgO)+(\cgBL+\cgCW+\cgHG+\cgSP,0)$){%
          \begin{tcolorbox}[
            enhanced,
            width    = \dimexpr\cgHG+\cgCW+\cgBL\relax,
            height   = \cgTH,
            colback  = black,
            colframe = black,
            boxrule  = 0pt, arc=0pt, outer arc=0pt,
            top      = \the\cgBL,
            bottom   = \the\cgBL,
            left     = \the\cgHG,
            right    = \the\cgBL,
            valign   = top,
          ]%
            \cg@conteudoCapa
          \end{tcolorbox}%
        };
    \fi

    % ════════════════════════════════════════════════════════
    %  SULCOS (desenhados por cima dos fundos)
    % ════════════════════════════════════════════════════════
    \definecolor{cgSulcoCor}{HTML}{\cg@corSulco}
    \fill[cgSulcoCor] (cgHL_BL) rectangle (cgHL_TR);
    \fill[cgSulcoCor] (cgHR_BL) rectangle (cgHR_TR);

    % ════════════════════════════════════════════════════════
    %  ANOTAÇÕES DOS SULCOS
    % ════════════════════════════════════════════════════════

    % SULCO HL — ACIMA
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHL_BL)+(0,\cgCH)$) -- ($(cgHL_BL)+(0,\cgCH+22mm)$);
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHL_BL)+(\cgHG,\cgCH+12mm)$) -- ($(cgHL_BL)+(\cgHG,\cgCH+22mm)$);
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgHL_BL)+(0,\cgCH+16mm)$) -- ($(cgHL_BL)+(\cgHG,\cgCH+16mm)$);
    \node[font=\tiny,text=cgGrid,anchor=south]
      at ($(cgHL_BL)+(0.5\cgHG,\cgCH+22mm)$){\cg@sulco mm sulco};

    % SULCO HL — ABAIXO
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHL_BL)+(0,-12mm)$) -- ($(cgHL_BL)+(0,-22mm)$);
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHL_BL)+(\cgHG,0)$) -- ($(cgHL_BL)+(\cgHG,-22mm)$);
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgHL_BL)+(0,-16mm)$) -- ($(cgHL_BL)+(\cgHG,-16mm)$);
    \node[font=\tiny,text=cgGrid,anchor=north]
      at ($(cgHL_BL)+(0.5\cgHG,-22mm)$){\cg@sulco mm sulco};

    % SULCO HR — ACIMA
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHR_BL)+(0,\cgCH+12mm)$) -- ($(cgHR_BL)+(0,\cgCH+22mm)$);
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHR_BL)+(\cgHG,\cgCH)$) -- ($(cgHR_BL)+(\cgHG,\cgCH+22mm)$);
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgHR_BL)+(0,\cgCH+16mm)$) -- ($(cgHR_BL)+(\cgHG,\cgCH+16mm)$);
    \node[font=\tiny,text=cgGrid,anchor=south]
      at ($(cgHR_BL)+(0.5\cgHG,\cgCH+22mm)$){\cg@sulco mm sulco};

    % SULCO HR — ABAIXO
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHR_BL)+(0,0)$) -- ($(cgHR_BL)+(0,-22mm)$);
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgHR_BL)+(\cgHG,-12mm)$) -- ($(cgHR_BL)+(\cgHG,-22mm)$);
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgHR_BL)+(0,-16mm)$) -- ($(cgHR_BL)+(\cgHG,-16mm)$);
    \node[font=\tiny,text=cgGrid,anchor=north]
      at ($(cgHR_BL)+(0.5\cgHG,-22mm)$){\cg@sulco mm sulco};

    % ════════════════════════════════════════════════════════
    %  BORDA DE CORTE
    % ════════════════════════════════════════════════════════
    \draw[blue!60, dashed, line width=0.4pt]
      (cgBackBL) rectangle (cgFrTR);

    % ════════════════════════════════════════════════════════
    %  MARCAÇÕES DE CORTE
    % ════════════════════════════════════════════════════════
    \tikzset{cgCrop/.style={cgCutMark, line width=0.5pt}}

    \newcommand{\cgMarca}[3]{%
      \draw[cgCrop]
        ($(##1)+(##2*\cgCMO,0)$)--($(##1)+(##2*\dimexpr\cgCMO+\cgCML\relax,0)$);%
      \draw[cgCrop]
        ($(##1)+(0,##3*\cgCMO)$)--($(##1)+(0,##3*\dimexpr\cgCMO+\cgCML\relax)$);%
    }
    \cgMarca{cgBackBL}{-1}{-1}
    \cgMarca{cgBackTL}{-1}{1}
    \cgMarca{cgFrBR}{1}{-1}
    \cgMarca{cgFrTR}{1}{1}
    \draw[cgCrop]($(cgSpBL)+(0,-\cgCMO)$)--($(cgSpBL)+(0,-\dimexpr\cgCMO+\cgCML\relax)$);
    \draw[cgCrop]($(cgSpBLtop)+(0,\cgCMO)$)--($(cgSpBLtop)+(0,\dimexpr\cgCMO+\cgCML\relax)$);
    \draw[cgCrop]($(cgSpTRbot)+(0,-\cgCMO)$)--($(cgSpTRbot)+(0,-\dimexpr\cgCMO+\cgCML\relax)$);
    \draw[cgCrop]($(cgSpTR)+(0,\cgCMO)$)--($(cgSpTR)+(0,\dimexpr\cgCMO+\cgCML\relax)$);

    % ════════════════════════════════════════════════════════
    %  ANOTAÇÕES DE MEDIDAS
    % ════════════════════════════════════════════════════════

    % — Contracapa: largura abaixo —
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgBackBL)+(0,-12mm)$)--($(cgBackBL)+(\cgCW,-12mm)$)
      node[midway,below,font=\tiny,text=cgGrid]{\cg@largura mm (contracapa)};

    % — Lombada: largura abaixo —
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgSpBL)+(0,-12mm)$)--($(cgSpTRbot)+(0,-12mm)$)
      node[midway,below,font=\tiny,text=cgGrid]{%
        \pgfmathprintnumber[fixed,precision=1]{\cg@lombadaVal} mm (lombada)};

    % — Capa: largura abaixo —
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgFrBL)+(0,-12mm)$)--($(cgFrBR)+(0,-12mm)$)
      node[midway,below,font=\tiny,text=cgGrid]{\cg@largura mm (capa)};

    % — Altura: à direita —
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgFrBR)+(10mm,0)$)--($(cgFrTR)+(10mm,0)$)
      node[midway,right,font=\tiny,text=cgGrid]{\cg@altura mm};

    % — Sangria: seta a -16mm, texto logo abaixo do fim das linhas (-22mm) —
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgBackBL)+(0,-12mm)$) -- ($(cgBackBL)+(0,-22mm)$);
    \draw[cgGrid, line width=0.3pt, dashed]
      ($(cgBackBL)+(-\cgBL, 0)$) -- ($(cgBackBL)+(-\cgBL,-22mm)$);
    \draw[<->,cgGrid,line width=0.5pt]
      ($(cgBackBL)+(-\cgBL,-16mm)$) -- ($(cgBackBL)+(0,-16mm)$);
    \node[font=\tiny,text=cgGrid,anchor=north]
      at ($(cgBackBL)+(-0.5\cgBL,-22mm)$){\cg@sangria mm sangria};

    % — Info de rodapé —
    \node[font=\tiny,text=cgGrid,anchor=north west]
      at ($(cgBackBL)+(0,-28mm)$){%
        Lombada: \pgfmathprintnumber[fixed,precision=1]{\cg@lombadaVal} mm
        | \cg@paginas\ pág.
        | \cg@gramatura\ g/m\textsuperscript{2}
        | \cg@espessuraPorFolha\ mm/folha};

  \end{tikzpicture}%
}

\endinput
