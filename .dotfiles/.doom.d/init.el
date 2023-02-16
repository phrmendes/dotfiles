;;; init.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ;;
;;  █▄░▄██░▀██░█▄░▄█▄▄░▄▄█████░▄▄▄██░████ ;;
;;  ██░███░█░█░██░████░███▀▀██░▄▄▄██░████ ;;
;;  █▀░▀██░██▄░█▀░▀███░███▄▄██░▀▀▀██░▀▀░█ ;;
;;  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(doom! :completion
       (company +childframe)
       (vertico +icons)

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
       electric  ; smarter, keyword-based electric-indent
       undo      ; persistent, smarter undo for your inevitable mistakes

       :term
       eshell

       :checkers
       (syntax +childframe)
       (spell +flyspell)

       :tools
       ansible
       terraform
       (debugger +lsp)
       (lsp +lsp +peek)
       (docker +lsp)
       (eval +overlay)    ; inline code evaluation
       (lookup +dicsets)  ; navigate your code and its documentation
       magit              ; a git porcelain for emacs
       tree-sitter        ; syntax and parsing, sitting in a tree...
       direnv             ; save (or destroy) the environment at your leisure

       :lang
       emacs-lisp
       (nix +lsp)
       (go +lsp)
       (json +lsp)
       (markdown +grip)
       (org +jupyter +pretty)
       (python +lsp +pyright)
       (sh +lsp)
       (yaml +lsp)

       :os
       macos

       :config
       (default +bindings +smartparens))
