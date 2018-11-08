(setq inhibit-startup-message t)

;;(require 'use-package)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))


(global-unset-key (kbd "C-z"))


(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")
		    )

package-archive-priorities '(("melpa-stable" . 1)))

(package-initialize)
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

(use-package try
	:ensure t)

(use-package which-key
	:ensure t 
	:config
	(which-key-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(defalias 'list-buffers 'ibuffer) ; make ibuffer default

(use-package magit
  :ensure t
  :init
  (progn
  (bind-key "C-x g" 'magit-status)
  ))

(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode +1))

(global-set-key (kbd "M-g M-g") 'hydra-git-gutter/body)


(use-package git-timemachine
  :ensure t
  )

; ace window
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0 :foreground "#30ffdf" ))))) 
    ))


;; it looks like counsel is a requirement for swiper

(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))


(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))


(use-package color-theme
  :ensure t)


(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))


(use-package elpy
:ensure t
:config 
(elpy-enable))


(use-package yasnippet
  :ensure t
  :init
    (yas-global-mode 1))

;; theme

;; dakrone theme
;; (package-install "dakrone-theme")
;; (load-theme 'dakrone t)

;; (load-theme 'material t)
;; (load-theme 'leuven t)

;; (use-package dakrone-theme
;;   :ensure t
;;   :config (load-theme 'dakrone t))


(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

(defalias 'ar #'align-regexp)

;; highlight
(global-hl-line-mode t)
(set-face-background 'hl-line "#585959")

;; flashes the cursor's line when you scroll
;; (use-package beacon
;; :ensure t
;; :config
;; (beacon-mode 1)
;; ; this color looks good for the zenburn theme but not for the one
;; ; I'm using for the videos
;; (setq beacon-color "#666600")
;; )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0 :foreground "#30ffdf"))))
 '(lazy-highlight ((t (:foreground "white" :background "SteelBlue")))))


;; marked region color
(set-face-attribute 'region nil :background "#000dc6")


;(global-set-key (kbd "C-x C-g") 'dumb-jump-go)
;(global-set-key (kbd "C-x C-b") 'dumb-jump-back)


(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
	 ("M-g j" . dumb-jump-go)
	 ;; ("M-g j" . dumb-jump-force-searcher)
	 ("M-g b" . dumb-jump-back)
	 ("M-g x" . dumb-jump-go-prefer-external)
	 ("M-g z" . dumb-jump-go-prefer-external-other-window))
   :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)

(setq dumb-jump-force-searcher 'ag)
(setq dumb-jump-prefer-searcher 'ag)

(progn
  ;; turn on highlight matching brackets when cursor is on one
  (show-paren-mode 1)
  ;; highlight brackets
  (setq show-paren-style 'parenthesis)

  ;; highlight entire expression
  (setq show-paren-style 'expression)

  ;; highlight brackets if visible, else entire expression
  (setq show-paren-style 'mixed)
  )




(load "~/.emacs.d/lisp/my-abbrev.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (git-timemachine magit git-gutter-fringe git-gutter ein realgud "dakrone-theme" dakrone-theme zygospore ztree zenburn-theme which-key use-package try org-bullets material-theme jedi flycheck ensime elpy dumb-jump counsel color-theme beacon ace-window))))


