;; pdb setup
(setq pdb-path "/usr/lib/python2.7/pdb.py")

;; Modes setup and loading
(add-to-list 'load-path "~/emacs/site-lisp/python-mode/")
(autoload 'python-mode "python-mode" "Python Mode." t)
(autoload 'python-mode "python" "Python editing mode." t)
(add-to-list 'interpreter-mode-alist '("ipython" . python-mode))

(add-to-list 'load-path "~/emacs/site-lisp/pylint/")
(add-to-list 'load-path "~/emacs/site-lisp/pep8/")

(require 'compile)
(require 'python-mode)
(require 'python-pylint)
(require 'python-pep8)
(require 'ipython)

;; Keymap modifications
(define-key py-mode-map (kbd "<f1>") 'pylint)
(define-key py-mode-map (kbd "<f2>") 'pep8)
(define-key py-mode-map (kbd "C-M-d") 'pdb)
