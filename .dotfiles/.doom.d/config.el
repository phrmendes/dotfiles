;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ;;
;; ██░▄▄▀██░▄▄▄░██░▀██░██░▄▄▄█▄░▄██░▄▄░█████░▄▄▄██░████ ;;
;; ██░█████░███░██░█░█░██░▄▄███░███░█▀▀█▀▀██░▄▄▄██░████ ;;
;; ██░▀▀▄██░▀▀▀░██░██▄░██░████▀░▀██░▀▀▄█▄▄██░▀▀▀██░▀▀░█ ;;
;; ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ========= GC =========

(setq gc-cons-threshold (* 50 1000 1000))

;; ========= ID =========

(setq user-full-name "Pedro Mendes"
      user-mail-address "phrmendes00@pm.me")

;; ========= FONT =========

(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 17))

(setq doom-theme 'doom-nord)

;; ========= LINE NUMBERS =========

(setq display-line-numbers-type 'relative)
(remove-hook! 'text-mode-hook #'display-line-numbers-mode)

;; ========= COMPANY MODE =========

(use-package! company-box
  :after company
  :hook (company-mode . company-box-mode))

;; ========= PYTHON REPL =========

(setq python-shell-completion-native-enable nil)

;; ========= HELPFUL =========

(use-package! helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; ========= ESHELL =========

(use-package! esh-autosuggest
  :after eshell
  :hook (eshell-mode . esh-autosuggest-mode))

;; ========= ORG MODE =========

(after! org
  (org-display-inline-images)
  (setq org-directory "~/Documents/org/"
        org-agenda-files '("agenda.org")
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
        org-display-inline-images t
        org-pretty-entities t
        org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))
  (setq-default org-latex-pdf-process '("tectonic %f")))

;; center org buffers -----

(defun phrm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . phrm/org-mode-visual-fill))

;; slides -----

(defun phrm/presentation-setup ()
  (hide-mode-line-mode 1)
  (centaur-tabs-mode 0)
  (setq text-scale-mode-amount 2)
  (text-scale-mode 1))

(defun phrm/presentation-end ()
  (hide-mode-line-mode 0)
  (text-scale-mode 0)
  (centaur-tabs-mode 1))

(use-package! org-tree-slide
  :after org
  :hook ((org-tree-slide-play . phrm/presentation-setup)
         (org-tree-slide-stop . phrm/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > ")
  (org-image-actual-width nil))

;; org babel -----

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (terraform . t)
     (restclient . t)
     (go . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  (map! "<f6>" #'org-babel-tangle))

;; org templates -----

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("yl" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("tr" . "src terraform"))
  (add-to-list 'org-structure-template-alist '("go" . "src go")))

(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(add-to-list
 'org-latex-classes
 '("article"
   "
\\documentclass[12pt,a4paper]{scrartcl}
\\usepackage[margin=2cm]{geometry}
\\usepackage{lmodern}
\\usepackage{fontspec}
\\usepackage{booktabs}
\\usepackage{indentfirst}
"
   ("\\section*{%s}" . "\\section*{%s}")
   ("\\subsection*{%s}" . "\\subsection*{%s}")
   ("\\subsubsection*{%s}" . "\\subsubsection*{%s}")))

;; ========= DEFT =========

(use-package! deft
  :commands deft
  :config
  (setq deft-directory "~/Documents/org"
        deft-extensions '("md" "org")
        deft-use-filename-as-title t
        deft-recursive t))

(use-package! zetteldeft
  :after deft)

(map! :leader
      (:prefix ("d" . "deft-zetteldeft")
       :desc "Deft"
       "d" #'deft
       :desc "Refresh deft"
       "r" #'deft-refresh
       "n" #'zetteldeft-new-file
       "N" #'zetteldeft-new-file-and-link
       "i" #'zetteldeft-find-file-id-insert
       "I" #'zetteldeft-find-file-full-title-insert
       "f" #'zetteldeft-follow-link
       "o" #'zetteldeft-find-file
       "s" #'zetteldeft-search-current-id
       "R" #'zetteldeft-file-rename
       "t" #'zetteldeft-tag-insert))

;; ========= PROJECTILE =========

(after! projectile
  (setq projectile-project-search-path '("~/Projects")))

;; ========= DIRENV =========

(envrc-global-mode)

;; ========= SPELLCHECK =========

(defun flyspell-english ()
  (interactive)
  (ispell-change-dictionary "english")
  (flyspell-buffer))

(defun flyspell-portuguese ()
  (interactive)
  (ispell-change-dictionary "brasileiro")
  (flyspell-buffer))

(map! :leader
      (:prefix ("l" . "language")
       :desc "Portuguese"
       "p" #'flyspell-portuguese
       :desc "English"
       "e" #'flyspell-english))

(remove-hook! 'text-mode-hook #'flyspell-mode)

;; ========= EVIL SNIPE =========

(after! evil
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer))

;; ========= DIRED =========

(after! dired
  (setq dired-kill-when-opening-new-dired-buffer t))

;; ========= GC =========

(setq gc-cons-threshold (* 2 1000 1000))
