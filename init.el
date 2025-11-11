 (setq inhibit-startup-message t)

(scroll-bar-mode -1)

(tool-bar-mode -1)

(tooltip-mode -1)

(set-fringe-mode 10)

(menu-bar-mode -1)

(setq ring-bell-function 'ignore)

(set-face-attribute 'default nil :font "Fira Code" :height 180)

(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(electric-pair-mode 1)

(add-hook 'emacs-startup-hook
       (lambda ()
           (when (equal (buffer-name) "*startup*")
              (display-line-numbers-mode -1))))

(defun my-startup-buffer ()
          (interactive)
  (switch-to-buffer "*startup*")
  (erase-buffer)
   (with-current-buffer "*startup*"

  (let* ((image-path "~/.emacs.d/minomacs.png") ; replace with your image path
         (image (create-image image-path nil nil :width 300 :height 300) )
         (window-pixel-width (window-pixel-width))
         (image-width 300) ; replace with your image width
         (text-width 450)
         (space-width (window-font-width nil 'default))
         (margin (/ (max 0 (- window-pixel-width image-width)) space-width 2))
         (text-margin (/ (max 0 (- window-pixel-width text-width)) space-width 2))
         (text (propertize "Welcome to the Labyrinth!"
                    'face '(:height 1.5 :weight bold :foreground "red")))
         )
          (insert "\n\n")
          (insert (make-string margin ?\s))
          (insert-image image)
          (insert "\n\n\n\n")
          (insert (make-string text-margin ?\s))
          (insert text)
      )

    ))

(add-hook 'emacs-startup-hook 'my-startup-buffer)

(defun center-startup-image ()
    (when (get-buffer "*startup*")
      (with-current-buffer "*startup*"
        (let* ((image-path "~/.emacs.d/minomacs.png") ; replace with your image path
               (image (create-image image-path nil nil :width 300 :height 300))
               (window-pixel-width (window-pixel-width))
               (image-width 300) ; replace with your image width
               (text-width 390)
               (space-width (window-font-width nil 'default))
               (margin (/ (max 0 (- window-pixel-width image-width)) space-width 2))
               (text-margin (/ (max 0 (- window-pixel-width text-width)) space-width 2))
               (text (propertize "Welcome to the Labyrinth!"
                      'face '(:height 1.5 :weight bold :foreground "red")))
               (title (propertize "MinoMacs"
                      'face '(:height 2.5 :weight bold :foreground "gold")))
               (title-width 190)
               (title-margin (/ (max 0 (- window-pixel-width title-width)) space-width 2))

               )
          (erase-buffer)
          (insert "\n\n")
          (insert (make-string margin ?\s))
          (insert-image image)
          (insert "\n\n" (make-string title-margin ?\s) title "\n\n")
          (insert (make-string text-margin ?\s))
          (insert text)
          ))))

      (add-hook 'window-configuration-change-hook 'center-startup-image)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))


;; Initialize use-package on non-Linux platforms

(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package nerd-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map


         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map


         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
:init
(ivy-rich-mode 1))

(use-package counsel
  :bind
  ("M-x" . counsel-M-x)
  ("C-c k" . counsel-ag)
  ("C-x C-f" . counsel-find-file))

(use-package doom-themes)

(load-theme 'doom-miramare t)

(use-package helpful
:ensure t
:custom
(counsel-describe-function-function #'helpful-capable)
(counsel-describe-variable-function #'helpful-variable)
:bind
([remap describe-function] . counsel-describe-function)
([remap describ-command] . helpful-command)
([remap describe-variable] . counsel-describe-variable)
([remap describe-key] . helpful-key))

(use-package general
:config
(general-evil-setup t)
(general-create-definer adel/leader-keys
			:keymaps '(normal emacs)
			:prefix "SPC"
			:gloabl-prefix "C-SPC"
			)


(adel/leader-keys
  "t" '(:ignore t :which-key "toggles")
  "tt" '(counsel-load-theme :which-key "choose-theme")))

(general-define-key
 "C-x e" 'eval-buffer
 "C-M-j" 'counsel-switch-buffer)

(defun adel/evil-hook()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  (evil-mode 1)
  :hook (evil-mode . adel/evil-hook)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; use visual motions outside visual line mode too

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
:after evil
:config
(evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 10)
  "scale text"
   ("j" text-scale-increase "in")
   ("k" text-scale-decrease "out")
   ("f" nil "finished" :exit t))

(adel/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))


(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge)

(defun adel/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  )

(use-package org
  :hook (org-mode . adel/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t
        )

  (setq org-agenda-files '("~Anyfile.org"
                          "~Anyfile.org"))


(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)


(setq org-todo-keywords
  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
    (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANCELED(k@)")))

(setq org-agenda-custom-commands
  '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))


    ("W" "Work Tasks" tags-todo "+work")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))


(setq org-refile-targets
      '(("~Anyfile.org" :maxlevel . 1)
        ))


(setq org-capture-templates
  `(("t" "Tasks / Projects")
    ("tt" "Task" entry (file+olp "~Anyfile.org" "Inbox")
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
    ("ts" "Clocked Entry Subtask" entry (clock)
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

    ("j" "Journal Entries")
    ("jj" "Journal" entry
         (file+olp+datetree "~Anyfile.org")
         "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
         :clock-in :clock-resume
         :empty-lines 1)
    ("jm" "Meeting" entry
         (file+olp+datetree "~Anyfile.org")
         "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)

    ("w" "Workflows")
    ("we" "Checking Email" entry (file+olp+datetree "~Anyfile.org")
         "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

    ("m" "Metrics Capture")
    ("mw" "Weight" table-line (file+headline "~Anyfile.org" "Weight")
     "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(require 'ob-js)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (lisp . t)
   (java . t)
   (js . t)
   (fortran . t)))

(add-to-list 'org-babel-tangle-lang-exts '("js" . "js"))


(setq org-confirm-babel-evaluate nil)
)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("js" . "src js"))

(setq org-agenda-include-diary t)

(require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(with-eval-after-load 'org-faces (dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)
                ))
  (set-face-attribute (car face) nil :font "Fira Code" :weight 'regular :height (cdr face)))
)

(font-lock-add-keywords 'org-mode
     '(("^ *\\([-]\\) ) "
     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "."))))))

(with-eval-after-load 'org-faces
   (set-face-attribute 'default nil :font "Fira Code") 
    (set-face-attribute 'fixed-pitch nil :font "Andale Mono")
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil :foreground nil :inherit 'fixed-pitch)

  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))

  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))

  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))

  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  )

(defun adel/org-mode-visual-fill ()
(setq-default visual-fill-column-width 100
      visual-fill-column-center-text t)
(visual-fill-column-mode 1))

(use-package visual-fill-column
:hook (org-mode . adel/org-mode-visual-fill))

(defun adel/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . adel/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-ui
:hook (lsp-mode . lsp-ui-mode)
:custom
(setq lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  (setq emms-source-file-default-directory "~/Media/"
        emms-playlist-buffer-name "*Media*"
        emms-info-asynchronously t
        emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
  (define-emms-simple-player vlc '(file url)
    (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
                  ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "https://"
                  "mms://" "rtsp://" "vlc://"))
    "vlc" "-I" "rc"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("Anyfile.org"))
 '(package-selected-packages
   '(which-key vlc visual-fill-column typescript-mode rainbow-delimiters org-bullets lsp-ui lsp-treemacs lsp-ivy ivy-rich helpful general forge evil-collection emms-player-mpv-jp-radios doom-themes doom-modeline counsel-projectile company-box command-log-mode all-the-icons-dired)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
