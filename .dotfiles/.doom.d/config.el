;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ;;
;; ██░▄▄▀██░▄▄▄░██░▀██░██░▄▄▄█▄░▄██░▄▄░█████░▄▄▄██░████ ;;
;; ██░█████░███░██░█░█░██░▄▄███░███░█▀▀█▀▀██░▄▄▄██░████ ;;
;; ██░▀▀▄██░▀▀▀░██░██▄░██░████▀░▀██░▀▀▄█▄▄██░▀▀▀██░▀▀░█ ;;
;; ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(use-package! company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :config
  (setq company-global-modes '(not org-mode))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

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
  (add-hook! 'org-mode-hook 'evil-tex-mode #'org-cdlatex-mode)
  (setq org-directory "~/pCloudDrive/notes/"
        org-agenda-files
        '("~/pCloudDrive/notes/todo.org"
          "~/pCloudDrive/notes/datas.org")
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        org-src-fontify-natively t
        org-display-inline-images t
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

;; preview equations in org-mode -----

(use-package! org-fragtog
  :hook (org-mode . org-fragtog-mode))

;; ========= DEFT =========

(use-package! deft
  :bind ("<f8>" . deft)
  :commands (deft)
  :config
  (setq deft-directory "~/pCloudDrive/notes"
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

;; ========= EVIL SNIPE =========

(after! evil
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1)
  (setq evil-snipe-scope 'buffer))

;; ========= QUARTO =========

(use-package! quarto-mode
  :mode (("\\.[q]md" . poly-quarto-mode)))

(after! poly-quarto-mode
  (setq markdown-code-block-braces t)
  (phrm/org-mode-visual-fill))

;; ========= ZOTERO INTEGRATION =========

(use-package! zotxt
  :hook
  ((poly-quarto-mode . zotxt-citekey-mode)
  (org-mode . org-zotxt-mode)))

(map! :leader
      (:prefix-map ("z" . "zotero")
       :desc "Insert citekey" "s" #'zotxt-citekey-insert
       :desc "Complete citekey at point" "c" #'zotxt-citekey-complete-at-point
       :desc "Select citekey at point" "y" #'zotxt-citekey-select-item-at-point
       :desc "Insert reference link" "i" #'org-zotxt-insert-reference-link
       :desc "Open attachment" "o" #'org-zotxt-open-attachment))

;; ========= SNIPPETS =========

(use-package! yasnippet
  :config
  (setq yas-snippet-dirs '("./snippets"))
  (yas-global-mode 1))
