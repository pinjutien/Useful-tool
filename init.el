(setq inhibit-startup-message t)

;;(require 'use-package)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))


;;;;; ensime start

;; global variables
;;(setq
;; inhibit-startup-screen t
;; create-lockfiles nil
;; make-backup-files nil
;; column-number-mode t
;; scroll-error-top-bottom t
;; show-paren-delay 0.5
;; use-package-always-ensure t
;; sentence-end-double-space nil)

;; buffer local variables
;;(setq-default
;; indent-tabs-mode nil
;; tab-width 4
;; c-basic-offset 4)

;; modes
;;(electric-indent-mode 0)

;; global keybindings
(global-unset-key (kbd "C-z"))


(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/"))

package-archive-priorities '(("melpa-stable" . 1)))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;;;; ensime end


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


(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))


(use-package ensime
  :ensure t
  :pin melpa-stable)

;; ensime https://github.com/syl20bnr/spacemacs/issues/4746
(setq ensime-sem-high-faces
        '(
           (implicitConversion nil)
           (var . (:foreground "#ff2222"))
           (varField . (:foreground "#ff3333"))
           (functionCall . (:foreground "#dc9157"))
           (object . (:foreground "#D884E3"))
           (operator . (:foreground "#cc7832"))
           (object . (:foreground "#6897bb" :slant italic))
           (package . (:foreground "yellow"))
           (deprecated . (:strike-through "#a9b7c6"))
           (implicitParams nil)
         )
        ;; ensime-completion-style 'company
        ;; ensime-sem-high-enabled-p nil ;; disable semantic highlighting
        ensime-tooltip-hints t ;; disable type-inspecting tooltips
        ensime-tooltip-type-hints t ;; disable typeinspecting tooltips
)




;; ensime
(add-to-list 'exec-path "/usr/local/bin")

;; theme
(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

(defalias 'ar #'align-regexp)

;; highlight
(global-hl-line-mode t)
(set-face-background 'hl-line "#1794c1")

;; flashes the cursor's line when you scroll
(use-package beacon
:ensure t
:config
(beacon-mode 1)
; this color looks good for the zenburn theme but not for the one
; I'm using for the videos
(setq beacon-color "#666600")
)

(custom-set-faces
  `(lazy-highlight ((t (:foreground "white" :background "SteelBlue")))))


;; marked region color
(set-face-attribute 'region nil :background "#666")


;(global-set-key (kbd "C-x C-g") 'dumb-jump-go)
;(global-set-key (kbd "C-x C-b") 'dumb-jump-back)

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
	 ("M-g j" . dumb-jump-go)
	 ("M-g b" . dumb-jump-back)
	 ("M-g x" . dumb-jump-go-prefer-external)
	 ("M-g z" . dumb-jump-go-prefer-external-other-window))
   :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)


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

;; for scala project;; https://github.com/jacktasia/dumb-jump#configuration
;; does not work!
(setq dumb-jump-default-project "~/.sbt/0.13/staging/f42aec95b698116a995a/slider/")
