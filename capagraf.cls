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

\endinput
