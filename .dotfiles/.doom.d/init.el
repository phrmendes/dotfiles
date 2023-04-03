;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       (company +childframe)
       (ivy +icons +fuzzy +prescient)
       :ui
       doom
       doom-dashboard
       emoji
       (treemacs +lsp)
       (popup +defaults)
       modeline
       window-select
       workspaces            ; tab emulation, persistence & separate workspaces
       hl-todo               ; highlights TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides         ; highlights indented columns
       ophints               ; highlights the region where an operation takes place
       (vc-gutter +pretty)   ; show git diff
       vi-tilde-fringe       ; display tildes on empty lines
       deft                  ; major mode for managing notes written in plain text formats
       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       rotate-text
       snippets
       word-wrap
       :emacs
       (dired +icons)
       (ibuffer +icons)
       (undo +tree)  ; persistent, smarter undo for your inevitable mistakes
       electric      ; smarter, keyword-based electric-indent
       :term
       eshell
       :checkers
       (syntax +childframe)
       (spell +aspell +flyspell)
       :tools
       ansible
       terraform
       biblio
       pdf
       (lsp +lsp +peek)
       (docker +lsp)
       (eval +overlay)
       (lookup +dicsets)
       (magit +forge)
       tree-sitter
       direnv
       :lang
       emacs-lisp
       (nix +lsp)
       (json +lsp)
       (latex +lsp +fold)
       markdown 
       (org +jupyter +pretty)
       (python +lsp +pyright) 
       (sh +lsp)
       (yaml +lsp)
       :config
       (default +bindings +smartparens))
