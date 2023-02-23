;;; -*- lexical-binding: t; -*-
;;; $DOOMDIR/config.el

(setq user-full-name "Pedro Mendes"
      user-mail-address "pedro.mendes-ext@ab-inbev.com")

(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 17))

(setq doom-theme 'doom-nord)

(setq display-line-numbers-type 'relative)
(remove-hook! 'text-mode-hook #'display-line-numbers-mode)

(setq doom-modeline-major-mode-icon t)

(use-package! company-box
  :after company
  :hook (company-mode . company-box-mode))

(map! :leader
      (:prefix ("r" . "citar")
       :desc "Insert citation"
       "i" #'citar-insert-citation
       :desc "Insert reference"
       "r" #'citar-insert-reference
       :desc "Insert predefined search"
       "o" #'citar-insert-preset))

(envrc-global-mode)

(use-package! helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(use-package! esh-autosuggest
  :after eshell
  :hook (eshell-mode . esh-autosuggest-mode))

(after! org
  (org-display-inline-images)
  (org-toggle-pretty-entities)
  (setq org-directory "~/Documents/org/"
        org-agenda-files '("agenda.org")
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
        org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))
  (setq-default org-latex-pdf-process '("tectonic %f")))

(defun myfun/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . myfun/org-mode-visual-fill))

(defun myfun/presentation-start ()
  (hide-mode-line-mode 1)
  (setq text-scale-mode-amount 2)
  (text-scale-mode 1))

(defun myfun/presentation-end ()
  (hide-mode-line-mode 0)
  (text-scale-mode 0))

(use-package! org-tree-slide
  :after org
  :hook ((org-tree-slide-play . myfun/presentation-start)
         (org-tree-slide-stop . myfun/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > ")
  (org-image-actual-width nil))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ipython . t)
     (nix . t)
     (shell . t)
     (terraform . t)
     (ditaa . t)
     (latex . t)
     (go . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  (map! "<f6>" #'org-babel-tangle))

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src ipython"))
  (add-to-list 'org-structure-template-alist '("jp" . "src jupyter-python :async yes"))
  (add-to-list 'org-structure-template-alist '("nx" . "src nix"))
  (add-to-list 'org-structure-template-alist '("dt" . "src ditaa"))
  (add-to-list 'org-structure-template-alist '("yl" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("js" . "src json"))
  (add-to-list 'org-structure-template-alist '("tr" . "src terraform"))
  (add-to-list 'org-structure-template-alist '("tx" . "src latex"))
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

(defun myfun/flyspell-english ()
  (interactive)
  (ispell-change-dictionary "en")
  (flyspell-buffer))

(defun myfun/flyspell-portuguese ()
  (interactive)
  (ispell-change-dictionary "pt_BR")
  (flyspell-buffer))

(map! :leader
      (:prefix ("l" . "language")
       :desc "Portuguese"
       "p" #'myfun/flyspell-portuguese
       :desc "English"
       "e" #'myfun/flyspell-english))

(remove-hook! 'text-mode-hook #'flyspell-mode)

(after! evil
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer))

(after! dired
  (setq dired-kill-when-opening-new-dired-buffer t))

(after! markdown-mode
  (setq markdown-code-block-braces t)
  (myfun/org-mode-visual-fill))
