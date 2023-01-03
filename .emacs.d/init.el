(setq mac-command-modifier 'control)
(setq mac-control-modifier 'command)
(setq inhibit-startup-message t)
(setq backup-directory-alist '((".*" . "~/.Trash")))
(setq markdown-fontify-code-blocks-natively t)
(setq scroll-conservatively 101)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(cua-mode t)
(cua-selection-mode t)


(set-face-attribute 'default nil :font "Fira Code Retina" :height 120)


(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)


(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done))
  :config
  (ivy-mode 1)
  (setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (t      . ivy--regex-fuzzy))))


(use-package flx)

(use-package all-the-icons)

(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))

(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :ensure t
  :after (ivy)
  :init
  (ivy-rich-mode 1))

(use-package general
  :config
  (general-define-key
   "C-j" 'evil-paste-pop-next
   "C-k" 'evil-paste-pop)
  (general-create-definer my-space
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer my-leader
    :keymaps '(normal visual emacs)
    :prefix ";")

  (my-space
    "b"  '(bookmark-jump :which-key "bookmark jump")
    "p"  '(projectile-command-map :which-key "Projectile")
    "h"  '(:ignore t :which-key "descript key")
    "hk" '(describe-key :which-key "describe key")
    "hf" '(counsel-describe-function :which-key "describe function"))

  (my-leader
    "g"  '(lsp-find-definition :which-key "find definition")
    "r"  '(lsp-find-references :which-key "find references")
    "f"  '(counsel-find-file :which-key "find file")
    "d"  '(counsel-dired :which-key "find file")
    "x"  '(counsel-M-x :which-key "M-x")
    "s"  '(swiper :which-key "swiper")
    "w"  '(:ignore t :which-key "toggles")
    "q"  '(delete-window :which-key "delete window")
    "wf"  '(delete-other-windows :which-key "delete other windows")
    "ww"  '(evil-window-next :which-key "switch window")
    "wl"  '(evil-window-right :which-key "right window")
    "wh"  '(evil-window-left :which-key "left window")
    "wk"  '(evil-window-up :which-key "up window")
    "wj"  '(evil-window-down :which-key "down window")
    "b"  '(:ignore t :which-key "toggles")
    "bb"  '(counsel-ibuffer :which-key "ibuffer")
    "bB"  '(ibuffer-list-buffers :which-key "ibuffer list buffers")
    "bw"  '(switch-to-buffer-other-window :which-key "new window")
    "bf"  '(switch-to-buffer-other-frame :which-key "new frame")
    "n"  '(next-buffer :which-key "next buffer")
    "p"  '(previous-buffer :which-key "previous buffer")
    "bk"  '(kill-current-buffer :which-key "kill buffer")
    "bK"  '(kill-buffer :which-key "kill buffer")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (setq projectile-project-search-path '("~/zeevou" "~/workspace"))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-collection
  :after evil magit
  :config
  (evil-collection-init))


(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package typescript-mode
  :mode "\\.tsx\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))


(use-package typescript-mode
  :ensure t
  :init
  (define-derived-mode typescript-tsx-mode typescript-mode "tsx")
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode #'subword-mode)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-tsx-mode)))

(use-package tree-sitter
  :ensure t
  :hook ((typescript-mode . tree-sitter-hl-mode)
	 (typescript-tsx-mode . tree-sitter-hl-mode)))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flx which-key vscode-dark-plus-theme use-package typescript-mode tree-sitter-langs solaire-mode magit lsp-ui lsp-treemacs lsp-ivy ivy-rich gnu-elpa-keyring-update general evil-collection doom-themes doom-modeline counsel-projectile command-log-mode all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
