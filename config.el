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

;; ========= ORG SETTINGS =========

(after! org
  (setq org-directory "~/pCloudDrive/notes"
        org-agenda-files '("~/pCloudDrive/notes/todo.org")
        org-ellipsis " ▼ "))

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(add-hook 'org-mode-hook (lambda () (org-zotxt-mode 1)))

(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" | "DONE(d)"))))

;; ========= PROJECTILE SETTINGS =========

(setq projectile-project-search-path '("~/Projects"))

;; ========= SPELLCHECK SETTINGS =========

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

;; ========= R SETTINGS =========

(after! ess-mode
  (setq ess-style 'C++
        ;; don't wait when evaluating
        ess-eval-visibly-p 'nowait
        ;; scroll buffer to bottom
        comint-scroll-to-bottom-on-output t)
  )

;; Adding pipe snippet

(defun gkh-r-add-pipe ()
  (interactive)
  (end-of-line)
  (unless (looking-back "|>" nil)
    (just-one-space 1)
    (insert "|>"))
  (newline-and-indent))

;; Quarto

(require 'quarto-mode)
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
