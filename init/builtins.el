;;; Adjust built-in settings

;; Raise GC threshold to 32MB
(setq gc-cons-threshold (* 1024 1024 32))

;; Store non-config data outside ~/.emacs.d
(setq user-emacs-directory "~/.cache/emacs")
(setq custom-file "~/.cache/emacs/custom.el")

;; Skip the auto-save and backup gunk
(let ((tramp-save-path (expand-file-name "tramp-autosave/" user-emacs-directory)))
  (setq create-lockfiles nil
        make-backup-files nil
        auto-save-default nil
        auto-save-list-file-prefix nil))

;; Enforce Unicode
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; Skip startup screen
(setq inhibit-startup-screen t)

;; Load new source rather than old bytecode
(setq load-prefer-newer t)

;; Shut the bell up
(setq ring-bell-function 'ignore)

;; Assorted formatting improvements
(setq-default indent-tabs-mode nil) ; Spaces, not tabs
(setq-default fill-column 80) ; Have a wider fill-column
(setq-default truncate-lines t) ; Don't wrap by default
(setq-default word-wrap t) ; But if you do wrap, do it at word boundaries
(add-hook 'text-mode-hook #'visual-line-mode) ; And soft wrap for prose
(setq require-final-newline t) ; Always end files with newlines
(setq sentence-end-double-space nil) ; I separate with a single space

;; Require less typing
(defalias 'yes-or-no-p 'y-or-n-p) ; y, not yes
(setq kill-whole-line t) ; C-k once, not twice

;; Ensure dired reuses the current buffer
(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("RET" . 'dired-find-alternate-file))
  :init (put 'dired-find-alternate-file 'disabled nil))

;; Easily run-or-raise shell relative to current buffer
;; Lovingly adapted from emacsredux' start-or-switch-to
(defun bsb/run-or-raise (function buffer-name)
  (if (not (get-buffer buffer-name))
      (progn
        (split-window-sensibly (selected-window))
        (other-window 1)
        (funcall function))
    (switch-to-buffer-other-window buffer-name)))

(defun bsb/go-shell ()
  (interactive)
  (let ((dir (file-name-directory (buffer-file-name))))
    (bsb/run-or-raise 'shell "*shell*")
    (insert (concat "cd " dir))
    (comint-send-input)))

(defun bsb/find-project-name ()
  (or (cdr (project-current))
      "*global*"))

(defun bsb/find-project-root ()
  (cdr (project-try-vc default-directory)))

(defun bsb/go-project-shell ()
  (interactive)
  (let ((dir (bsb/find-project-root)))
    (bsb/run-or-raise 'shell "*shell*")
    (insert (concat "cd " dir))
    (comint-send-input)))

(global-set-key (kbd "s-;") 'bsb/go-shell)

(global-set-key (kbd "M-o") 'other-window)

;; Add some helpers for navigating a large project until emacs 28 drops
(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p r") 'project-find-regexp)
(global-set-key (kbd "C-c p ;") 'bsb/go-project-shell)
