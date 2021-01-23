;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:

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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; ------ My config ------

;; ------ Custom interactive fns ------

;; Open current buffer in neotree
;; source: https://github.com/jaypei/emacs-neotree/issues/149
(defun aj/neotree-project-root-dir-or-current-dir ()
  "Open NeoTree using the project root, using projectile, or the
current buffer directory."
  (interactive)
  (let ((project-dir (ignore-errors (projectile-project-root)))
        (file-name (buffer-file-name))
        (neo-smart-open t))
    (if (neo-global--window-exists-p)
        (neotree-hide)
      (progn
        (neotree-show)
        (if project-dir
            (neotree-dir project-dir))
        (if file-name
            (neotree-find file-name))))))


(defun aj/neotree-open-externally ()
  "Open currently selected file in the default editor for this file"
  (interactive)
  (let* ((cmd (concat "open " (neo-buffer--get-filename-current-line))))
    (shell-command cmd)))


;; ------ Keybindings ------

(map! (:leader
       (:prefix "p"
        :desc "Toggle open buffer in neotree" "t" #'aj/neotree-project-root-dir-or-current-dir)))

(map! (:leader
       (:prefix "b"
        :desc "Switch buffer" "b" #'ivy-switch-buffer)))

(map! (:leader
       (:desc "Exec cmd"
        "SPC" #'execute-extended-command)))

(map! :leader
      :desc "Previous buffer" "TAB" #'evil-switch-to-windows-last-buffer
      :desc "Workspace" "W" doom-leader-workspace-map)

;; Font
(setq doom-font (font-spec :family "JetBrains Mono"))

;; Package-specific
(setq anaconda-mode-localhost-address "localhost")

;; Run flake8 after lsp checker.
;; LSP is better in handling venv dependencies.
;; Flake8 is better in keeping proper formatting.
;;
;; Python checker setup method #1 - probably doesn't work.
;; TODO: make sure we don't need it and remove it.
;; flycheck<->lsp integration (lsp checker) is provided by lsp-ui-flycheck package.
;; Before its loaded, flycheck complains about "lsp" not being a proper checker.
;; (after! lsp-ui-flycheck
;;   (flycheck-add-next-checker 'lsp 'python-flake8))
;;
;; Python checker setup method #2 - simply use flake8.
(defun aj/set-flake8-checker ()
  (setq flycheck-checker 'python-flake8))

(add-hook 'python-mode-hook #'aj/set-flake8-checker)

;; Pylint highlights valid imports as import errors for virtualenv packages.
(setq-default flycheck-disabled-checkers '(python-pylint))


;; Indent width
(defun aj/set-indent-width-2 ()
  (doom/set-indent-width 2))

(add-hook 'json-mode-hook #'aj/set-indent-width-2)

(defun aj/clip-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "pbcopy")
  (message "Copied."))

;; Disable line numbers for faster scrolling
(setq display-line-numbers-type nil)


;; Customize modeline for faster scrolling
(setq doom-modeline-buffer-state-icon nil)
(setq doom-modeline-buffer-modification-icon nil)
(setq doom-modeline-unicode-fallback t)
(setq doom-modeline-minor-modes nil)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-continuous-word-count-modes nil)
(setq doom-modeline-buffer-encoding nil)
(setq doom-modeline-indent-info nil)

;; Smooth, pixel-level scrolling
(good-scroll-mode 1)

;; (setq good-scroll-render-rate 0.01)
;; (setq good-scroll-step 50)
;; (setq good-scroll-point-jump 5)
;; (setq good-scroll-algorithm #'good-scroll-linear)


;; Handled by doom automatically
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3577ee091e1d318c49889574a31175970472f6f182a9789f1a3e9e4513641d86" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" default)))
