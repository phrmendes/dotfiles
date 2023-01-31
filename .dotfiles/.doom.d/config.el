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
      user-mail-address "phrmendes@tuta.io")

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
  :hook (eshell-mode . esh-autosuggest-mode))

;; ========= ORG MODE =========

(after! org
  (setq org-directory "~/pCloudDrive/org/"
        org-agenda-files '("agenda.org" "agenda_rec.org" "calendario.org")
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
        org-display-inline-images t
        org-pretty-entities t
        org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")
        org-refile-targets '("arquivo.org" :maxlevel . 1)))
(advice-add 'org-refile :after 'org-save-all-org-buffers)
(setq-default org-latex-pdf-process '("tectonic %f"))

;; center org buffers -----

(defun phrm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . phrm/org-mode-visual-fill))

;; slides -----

(defun phrm/presentation-setup ()
  ;; hide the mode line
  (hide-mode-line-mode 1)
  ;; display images inline
  (org-display-inline-images)
  ;; hide tabs
  (centaur-tabs-mode 0)
  ;; scale the text
  (setq text-scale-mode-amount 2)
  (text-scale-mode 1))

(defun phrm/presentation-end ()
  ;; show the mode line again
  (hide-mode-line-mode 0)
  ;; descale the text
  (text-scale-mode 0)
  ;; show tabs
  (centaur-tabs-mode 1))

(use-package! org-tree-slide
  :hook ((org-tree-slide-play . phrm/presentation-setup)
         (org-tree-slide-stop . phrm/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation started!")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " > ")
  (org-image-actual-width nil))

;; org-babel -----

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages '((emacs-lisp . t)
                               (python . t)
                               (nix . t)
                               (shell . t)
                               (terraform . t)
                               (ditaa . t)
                               (latex . t)
                               (go . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

;; tangle config files -----

(global-set-key [f6] 'org-babel-tangle)

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

(add-to-list 'org-latex-classes
             '("default"
               "
\\documentclass[12pt,a4paper]{scrartcl}
\\usepackage[margin=2cm]{geometry}
\\usepackage{lmodern}
\\usepackage{fontspec}
\\usepackage{booktabs}
\\usepackage{indentfirst}"
               ("\\section*{%s}" . "\\section*{%s}")
               ("\\subsection*{%s}" . "\\subsection*{%s}")
               ("\\subsubsection*{%s}" . "\\subsubsection*{%s}")))

;; org roam -----

(use-package! org-roam
  :config
  (define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)
  (setq org-roam-directory "~/pCloudDrive/org/roam")
  (setq org-roam-capture-templates '(("d" "default" plain
                                      "%?"
                                      :target
                                      (file+head "%<%Y%m%d%H%M%S>-${name}.org"
                                                 "#+title: ${title}\n")
                                      :unnarrowed t)
                                     ("r" "bibliography reference" plain
                                      "%?"
                                      :target
                                      (file+head
                                       "references/${citekey}.org"
                                       "#+title: ${title}\n")
                                      :unnarrowed t)))
  (org-roam-db-autosync-mode t))

(use-package! org-roam-ui
  :after org-roam
  (setq
   org-roam-ui-sync-theme t
   org-roam-ui-follow t
   org-roam-ui-update-on-save t
   org-roam-ui-open-on-start t))

(use-package! org-ref
  :config
  (setq
   bibtex-completion-bibliography "~/pCloudDrive/org/roam/references/library.bib"
   bibtex-completion-library-path "~/pCloudDrive/zotero"
   bibtex-completion-notes-path "~/pCloudDrive/org/roam/references"
   bibtex-completion-pdf-field "file"))

(use-package! org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (require 'org-ref))

;; ========= DEFT =========

(use-package! deft
  :bind ("<f8>" . deft)
  :commands (deft)
  :config
  (setq deft-directory "~/pCloudDrive/org"
        deft-extensions '("md" "org")
        deft-recursive t))

;; ========= PROJECTILE =========

(after! projectile
  (setq projectile-project-search-path '("~/Projects")))

;; ========= DIRENV =========

(envrc-global-mode)

;; ========= SPELLCHECK =========

(after! flycheck
  (setq flyspell-issue-message-flag nil))

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

(global-set-key [f5] 'cycle-ispell-languages)

(remove-hook! 'text-mode-hook #'flyspell-mode)

;; ========= DAP MODE =========

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

(use-package! dired-single)

;; ========= QUARTO =========

(use-package! quarto-mode
  :mode (("\\.[q]md" . poly-quarto-mode)))

(after! poly-quarto-mode
  (setq markdown-code-block-braces t)
  (phrm/org-mode-visual-fill))

;; ========= GC =========

(setq gc-cons-threshold (* 2 1000 1000))
