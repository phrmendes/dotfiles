;;; init.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ;;
;;  █▄░▄██░▀██░█▄░▄█▄▄░▄▄█████░▄▄▄██░████ ;;
;;  ██░███░█░█░██░████░███▀▀██░▄▄▄██░████ ;;
;;  █▀░▀██░██▄░█▀░▀███░███▄▄██░▀▀▀██░▀▀░█ ;;
;;  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(doom! :completion
       (company +childframe)                       ; the ultimate code completion backend
       (ivy +fuzzy +icons +prescient)  ; yesterday's lightest search engine

       :ui
       doom                  ; what makes DOOM look the way it does
       doom-dashboard        ; a nifty splash screen for Emacs
       doom-quit             ; DOOM quit-message prompts when you quit Emacs
       emoji                 ; 🙂
       hl-todo               ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides         ; highlighted indent columns
       (ligatures +extra)    ; ligatures and symbols to make your code pretty again
       modeline              ; snazzy, Atom-inspired modeline, plus API
       ophints               ; highlight the region an operation acts on
       (popup +defaults)     ; tame sudden yet inevitable temporary windows
       (tabs +centaur-tabs)  ; a tab bar for Emacs
       (treemacs +lsp)       ; a project drawer, like neotree but cooler
       (vc-gutter +pretty)   ; vcs diff in the fringe
       vi-tilde-fringe       ; fringe tildes to mark beyond EOB
       window-select         ; visually switch windows
       workspaces            ; tab emulation, persistence & separate workspaces
       zen                   ; distraction-free coding or writing
       deft                  ; major mode for managing notes written in plain text formats

       :editor
       (evil +everywhere)  ; come to the dark side, we have cookies
       file-templates      ; auto-snippets for empty files
       fold                ; (nigh) universal code folding
       (format +onsave)    ; automated prettiness
       multiple-cursors    ; editing in many places at once
       rotate-text         ; cycle region at point between text candidates
       snippets            ; they type so I don't have to
       word-wrap           ; soft wrapping with language-aware indent

       :emacs
       (dired + icons)  ; making dired pretty [functional]
       electric         ; smarter, keyword-based electric-indent
       undo             ; persistent, smarter undo for your inevitable mistakes
       vc               ; version-control and Emacs, sitting in a tree

       :term
       eshell

       :checkers
       (syntax +childframe)       ; tasing you for every semicolon you forget
       (spell +aspell +flyspell)  ; tasing you for misspelling mispelling

       :tools
       ansible            ; DevOps automation tool
       biblio             ; writes a PhD for you (citation needed)
       (debugger +lsp)    ; FIXME stepping through code, to help you add bugs
       (docker +lsp)      ; container management tool
       editorconfig       ; let someone else argue about tabs vs spaces
       ein                ; tame Jupyter notebooks with emacs
       (eval +overlay)    ; run code, run (also, repls)
       (lookup +dicsets)  ; navigate your code and its documentation
       (lsp +lsp +peek)   ; M-x vscode
       (magit +forge)     ; a git porcelain for Emacs
       make               ; the discount build system
       terraform          ; infrastructure as code
       tree-sitter        ; syntax and parsing, sitting in a tree...
       direnv             ; save (or destroy) the environment at your leisure

       :lang
       emacs-lisp
       (nix +lsp)
       (go +lsp)
       (json +lsp)
       (latex +lsp +fold)
       (markdown +grip)
       (org +dragndrop +jupyter +pretty +present +noter)
       (python +lsp +poetry +pyright)
       (sh +lsp +fish)
       (yaml +lsp)

       :config
       (default +bindings +smartparens))
