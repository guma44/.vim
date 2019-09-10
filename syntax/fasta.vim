" Vim syntax file
" Language:     Fasta files
" Maintainer:   Rafal Gumienny
" Last Change:  11.05.2014
" Version:      1

if exists("b:current_syntax")
  finish
endif

syn region id	start=/^>/ end=/\n/
syn region entry	start=/^[A-Za-z\-]/ end=/\n/

highlight link id		Keyword
highlight link entry		String
syn case ignore
let b:current_syntax = "fasta"
