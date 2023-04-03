;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Pedro Mendes"
      user-mail-address "phrmendes00@pm.me")

(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 17))

(setq doom-theme 'doom-dracula)

(setq display-line-numbers-type 'relative)
(remove-hook! 'text-mode-hook #'display-line-numbers-mode)

(setq doom-modeline-major-mode-icon t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(modify-all-frames-parameters
 '((right-divider-width . 8)
   (internal-border-width . 8)))

(use-package! company-box
  :after company
  :hook (company-mode . company-box-mode))

(after! projectile
  (setq projectile-project-search-path '("~/Projects")))

(envrc-global-mode)

(use-package! helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

(after! org
  (org-display-inline-images)
  (org-toggle-pretty-entities)
  (setq org-directory (concat (getenv "HOME")"/pCloudDrive/org")
        org-agenda-files '("agenda.org")
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
        org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))
  (setq-default org-latex-pdf-process '("tectonic %f")))

(defun myfun/org-mode-visual-fill ()
  (setq visual-fill-column-width 175
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . myfun/org-mode-visual-fill))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ipython . t)
     (nix . t)
     (shell . t)
     (latex . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes)
  (map! "<f6>" #'org-babel-tangle))

(after! org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src ipython"))
  (add-to-list 'org-structure-template-alist '("nx" . "src nix"))
  (add-to-list 'org-structure-template-alist '("yl" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("js" . "src json"))
  (add-to-list 'org-structure-template-alist '("tx" . "src latex")))

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

(setq bibtex-completion-bibliography (concat (getenv "HOME") "/pCloudDrive/org/references/library.bib")
      bibtex-completion-library-path (concat (getenv "HOME") "/pCloudDrive/zotero")
      bibtex-completion-format-citation-functions
      '((org-mode . bibtex-completion-format-citation-org-link-to-PDF)
        (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (poly-quarto-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (default . bibtex-completion-format-citation-default)))

(use-package! deft
  :commands deft
  :config
  (setq deft-directory (concat (getenv "HOME") "/pCloudDrive/org/zetteldeft")
        deft-extensions '("org")
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

(use-package! quarto-mode
  :mode (("\\.qmd" . poly-quarto-mode)))

(setq python-shell-completion-native-disabled-interpreters '("python" "ipython"))
