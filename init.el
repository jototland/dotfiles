;(setq gc-cons-threshold 100000000)
;(emacs-init-time)

;; Do not litter!
(setq create-lockfiles nil)
(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Do not beep!
(setq visible-bell 1)

;; Melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package)
  (package-refresh-contents))
(require 'use-package)

;; Enable Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
(unless (package-installed-p 'key-chord)
  (package-install 'key-chord))
(require 'evil)
(evil-mode 1)

;; Key chord
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(define-key evil-motion-state-map ";" #'evil-ex)

;; Evil commentary
(unless (package-installed-p 'evil-commentary)
  (package-install 'evil-commentary))
(require 'evil-commentary)
(evil-commentary-mode)

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(require 'lsp-pyright)
(use-package lsp-pyright
     :hook (python-mode . (lambda () (require 'lsp-pyright)))
     :init (when (executable-find "python3")
             (setq lsp-pyright-python-executable-cmd "python3")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(wheatgrass))
 '(package-selected-packages '(evil-commentary lsp-pyright lps-pyright key-chord evil)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
