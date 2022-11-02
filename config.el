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

(setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'semi-light)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 17))

(setq doom-theme 'doom-gruvbox)

;; ========= LINE NUMBERS =========

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; In this case, line numbers are disable for text buffer.

(setq display-line-numbers-type 'relative)

(remove-hook! 'text-mode-hook #'display-line-numbers-mode)

;; ========= COMPANY MODE =========

(add-hook 'after-init-hook 'global-company-mode)

(use-package! company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
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

;; ========= ESHELL =========

(defun phrm/configure-eshell ()
  ;; save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package! eshell-git-prompt
  :after eshell)

(use-package! eshell
  :hook (eshell-first-time-mode . phrm/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("fish" "nvim")))

  (eshell-git-prompt-use-theme 'powerline))

;; ========= ORG MODE =========

(after! org
  (setq org-directory "~/pCloudDrive/notes/"
        org-agenda-files
        '("~/pCloudDrive/notes/todo.org"
          "~/pCloudDrive/notes/dates.org")
        org-roam-directory "~/pCloudDrive/notes/roam_notes/"
        org-cite-csl-styles-dir "~/Zotero/styles"
        org-ellipsis " ▼ "
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))))

;; Org bullets ---

(use-package! org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Center org buffers ---

(defun phrm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package! visual-fill-column
  :hook (org-mode . phrm/org-mode-visual-fill))

;; Deft ---

(use-package! deft
  :commands deft
  :init
  (setq deft-default-extension "org"
        ;; de-couples filename and note title:
        deft-use-filename-as-title nil
        deft-use-filter-string-for-filename t
        ;; disable auto-save
        deft-auto-save-interval -1.0
        ;; converts the filter string into a readable file-name using kebab-case:
        deft-file-naming-rules
        '((noslash . "-")
          (nospace . "-")
          (case-fn . downcase)))
  :config
  (add-to-list 'deft-extensions "tex"))

;; Org-Roam ---

(use-package! org-roam-bibtex
  :after org-roam
  :config
  (require 'org-ref)
  (require 'org-ref-helm)
  :hook (org-roam-mode . org-roam-bibtex-mode))

;; Org-Ref ---

(after! org-ref
  (setq
   bibtex-completion-notes-path "~/pCloudDrive/notes/roam_notes/"
   bibtex-completion-bibliography "~/pCloudDrive/notes/roam_notes/library.bib"
   bibtex-completion-library-path '("~/pCloudDrive/zotero")
   bibtex-completion-pdf-field "file"
   bibtex-completion-additional-search-fields '(keywords)
   bibtex-completion-notes-template-multiple-files
   (concat
    "#+TITLE: ${title}\n"
    "#+ROAM_KEY: cite:${=key=}\n"
    "* TODO Notes\n"
    ":PROPERTIES:\n"
    ":Custom_ID: ${=key=}\n"
    ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
    ":AUTHOR: ${author-abbrev}\n"
    ":JOURNAL: ${journaltitle}\n"
    ":DATE: ${date}\n"
    ":YEAR: ${year}\n"
    ":DOI: ${doi}\n"
    ":URL: ${url}\n"
    ":END:\n\n")))

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;; Org-Noter

(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; the WM can handle splits
   org-noter-notes-window-location 'other-frame
   ;; please stop opening frames
   org-noter-always-create-frame nil
   ;; i want to see the whole file
   org-noter-hide-other nil
   ;; everything is relative to the main notes file
   org-noter-notes-search-path '("~/pCloudDrive/notes/")))

;; ========= PROJECTILE =========

(setq projectile-project-search-path '("~/Projects"))

;; ========= SPELLCHECK =========

(after! guess-language
  (setq guess-language-langcodes
        '((en . ("en_US" "English" "🇺🇸" "English"))
          (pt . ("pt_BR" "Portuguese" "🇧🇷" "Brazilian Portuguese")))
        guess-language-languages '(en pt)
        guess-language-min-paragraph-length 35
        guess-language-langcodes
        '((en . ("en_US" "English" "🇺🇸" "English"))
          (pt . ("pt_BR" "Portuguese" "🇧🇷" "Brazilian Portuguese"))))
  (add-hook 'text-mode-hook (lambda () (guess-language-mode 1))))

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
