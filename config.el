;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ ;;
;; ██░▄▄▀██░▄▄▄░██░▀██░██░▄▄▄█▄░▄██░▄▄░█████░▄▄▄██░████ ;;
;; ██░█████░███░██░█░█░██░▄▄███░███░█▀▀█▀▀██░▄▄▄██░████ ;;
;; ██░▀▀▄██░▀▀▀░██░██▄░██░████▀░▀██░▀▀▄█▄▄██░▀▀▀██░▀▀░█ ;;
;; ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ========= INCREASE GC SIZE =========

(setq gc-cons-threshold (* 50 1000 1000))

;; ========= ID =========

(setq user-full-name "Pedro Mendes"
      user-mail-address "phrmendes@tuta.io")

;; ========= FONT =========

(setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 17))

(setq doom-theme 'doom-gruvbox)

;; ========= LINE NUMBERS =========

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; In this case, line numbers are disable for text buffer.

(setq display-line-numbers-type 'relative)

(remove-hook! 'text-mode-hook #'display-line-numbers-mode)

;; ========= DEFAULT PDF READER =========

(use-package! openwith
  :init (add-hook 'after-init-hook 'openwith-mode)
  :config
  (setq openwith-associations '(("\\.pdf\\'" "evince" (file)))))

;; ========= COMPANY MODE =========

(use-package! company
  :after lsp-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; ========= HELM =========

(require 'helm-easymenu)

(after! helm
  (add-hook! 'helm-find-files-after-init-hook
    (map! :map helm-find-files-map
          "<DEL>" #'helm-find-files-up-one-level)))

;; ========= VTERM =========

(use-package! vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-shell "fish")
  (setq vterm-max-scrollback 10000))

;; ========= ORG MODE =========

(after! org
  (setq org-directory "~/pCloudDrive/notes/"
        org-agenda-files
        '("~/pCloudDrive/notes/todo.org"
          "~/pCloudDrive/notes/dates.org")
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))))

;; Org bullets ---

(use-package! org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Center Org buffers ---

(defun phrm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . phrm/org-mode-visual-fill))

;; Org-Roam ---

(use-package! org-roam
  :init (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/pCloudDrive/notes/roam_notes/")
  (org-roam-complete-everywhere t)
  :config (org-roam-db-autosync-enable))

;; Zotero connection ---

(use-package! zotxt
  :hook (org-mode . org-zotxt-mode))

;; Slides ---

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

;; Org-Babel ---

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)
      (R . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

;; Org template ---

(with-eval-after-load 'org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("rl" . "src R")))

;; ========= PROJECTILE =========

(setq projectile-project-search-path '("~/Projects"))

;; ========= SPELLCHECK =========

(set-input-method "TeX")

(after! guess-language
  (setq guess-language-langcodes
        '((en . ("en_US" "English" "🇺🇸" "English"))
          (pt . ("pt_BR" "Portuguese" "🇧🇷" "Brazilian Portuguese")))
        guess-language-languages '(en pt)
        guess-language-min-paragraph-length 35
        guess-language-langcodes
        '((en . ("en_US" "English" "🇺🇸" "English"))
          (pt . ("pt_BR" "Portuguese" "🇧🇷" "Brazilian Portuguese")))))

(remove-hook 'yaml-mode-hook #'flyspell-prog-mode)
(remove-hook 'json-mode-hook #'flyspell-prog-mode)

;; ========= EVIL SNIPE =========

(evil-snipe-mode +1)
(evil-snipe-override-mode +1)
(setq evil-snipe-scope 'buffer)

;; ========= ESS-R =========

(after! ess-mode
  (setq ess-style 'C++
        ;; don't wait when evaluating
        ess-eval-visibly-p 'nowait
        ;; scroll buffer to bottom
        comint-scroll-to-bottom-on-output t)
  )

;; Pipe snippet ---

(defun gkh-r-add-pipe ()
  (interactive)
  (end-of-line)
  (unless (looking-back "|>" nil)
    (just-one-space 1)
    (insert "|>"))
  (newline-and-indent))

;; Quarto ---

(add-hook 'ess-mode-hook 'quarto-mode)
(add-to-list 'auto-mode-alist '("\\.qmd" . poly-markdown-mode))

;; ========= DECREASE GC SIZE =========

(setq gc-cons-threshold (* 2 1000 1000))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
