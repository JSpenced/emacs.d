;; -*- mode: Emacs-Lisp -*-

;; needs to be loaded before markdown mode I think so put at the beginning
(setq markdown-header-scaling t)
(setq markdown-header-scaling-values '(1.25 1.15 1.1 1.05 1.0 1.0))

(load "functions")
(load "bindings")
(load "settings")
;; if error stringp, nil (filename-extension: wrong-type argument) likely due to (desktop-read)

(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(auto-complete-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using but remove with upgrade to new version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
