(bsb/use-package! js2-mode
  :mode ("\\.js\\'" . js2-mode)
  :config (subword-mode 1))

(bsb/use-package! rjsx-mode
  :mode "components/.+\\.js$")
