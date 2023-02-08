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
  (org-toggle-pretty-entities)
  (setq org-directory "~/pCloudDrive/org/"
        org-agenda-files '("agenda.org" "agenda_rec.org" "calendario.org")
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
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
     (nix . t)
     (shell . t)
     (terraform . t)
     (ditaa . t)
     (latex . t)
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
  (add-to-list 'org-structure-template-alist '("nx" . "src nix"))
  (add-to-list 'org-structure-template-alist '("dt" . "src ditaa"))
  (add-to-list 'org-structure-template-alist '("yl" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("tr" . "src terraform"))
  (add-to-list 'org-structure-template-alist '("tx" . "src latex"))
  (add-to-list 'org-structure-template-alist '("go" . "src go")))

(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(add-to-list
 'org-latex-classes
 '("default"
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
  (setq deft-directory "~/pCloudDrive/org"
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

;; ========= ZOTERO INTEGRATION =========

(use-package! zotxt
  :after org
  :hook (org-zotxt-mode . org-mode))

(map! :leader
      (:prefix ("z" . "zotero")
       :desc "Insert reference link"
       "i" #'org-zotxt-insert-reference-link
       :desc "Update reference link"
       "u" #'org-zotxt-update-reference-link-at-point
       :desc "Open attachment"
       "o" #'org-zotxt-open-attachment))

;; ========= CITAR =========

(use-package! citar
  :custom
  (citar-bibliography '("~/pCloudDrive/org/library.bib")))

(map! :leader
      (:prefix ("r" . "citar")
       :desc "Insert citation"
       "i" #'citar-insert-citation
       :desc "Insert reference"
       "r" #'citar-insert-reference
       :desc "Insert predefined search"
       "o" #'citar-insert-preset))

;; ========= PROJECTILE =========

(after! projectile
  (setq projectile-project-search-path '("~/Projects")))

;; ========= DIRENV =========

(envrc-global-mode)

;; ========= SPELLCHECK =========

(let ((langs '("en_US" "pt_BR")))
  (setq lang-ring (make-ring (length langs)))
  (dolist (elem langs) (ring-insert lang-ring elem)))
(let ((dics '("american-english" "portuguese")))
  (setq dic-ring (make-ring (length dics)))
  (dolist (elem dics) (ring-insert dic-ring elem)))

(defun cycle-ispell-languages ()
  (interactive)
  (let ((lang (ring-ref lang-ring -1))
        (dic (ring-ref dic-ring -1)))
    (ring-insert lang-ring lang)
    (ring-insert dic-ring dic)
    (ispell-change-dictionary lang)))

(map! "<f5>" #'cycle-ispell-languages)

(remove-hook! 'text-mode-hook #'flyspell-mode)

;; ;; ========= DAP MODE =========

(after! dap-mode
  (require 'dap-python)
  (require 'dap-dlv-go)
  (setq dap-python-debugger 'debugpy))

;; ========= EVIL SNIPE =========

(after! evil
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer))

;; ========= DIRED =========

(after! dired
  (setq dired-kill-when-opening-new-dired-buffer t))

;; ========= QUARTO =========

(use-package! quarto-mode
  :mode (("\\.[q]md" . poly-quarto-mode)))

(after! poly-quarto-mode
  (setq markdown-code-block-braces t)
  (phrm/org-mode-visual-fill))

;; ========= GC =========

(setq gc-cons-threshold (* 2 1000 1000))
