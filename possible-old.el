;; -*- mode: Lisp -*-

(set-face-font 'default "Source Code Pro Semibold-9")
(set-face-font 'variable-pitch "Segoe UI Semibold-9")
(copy-face 'default 'fixed-pitch)

;;============================================================
;; toggle between variable pitch and fixed pitch font for
;; the current buffer
(defun fixed-pitch-mode ()
  (buffer-face-mode -1))

(defun variable-pitch-mode ()
  (buffer-face-mode t))

(defun toggle-pitch (&optional arg)
  "Switch between the `fixed-pitch' face and the `variable-pitch' face"
  (interactive)
  (buffer-face-toggle 'variable-pitch))

;; enable buffer-face mode to provide buffer-local fonts
(buffer-face-mode)

;; Set the fonts to format correctly
					;(add-hook 'text-mode-hook 'fixed-pitch-mode)
					;(add-hook 'dired-mode-hook 'fixed-pitch-mode)
					;(add-hook 'calendar-mode-hook 'fixed-pitch-mode)
					;(add-hook 'org-agenda-mode-hook 'fixed-pitch-mode)
					;(add-hook 'shell-mode-hook 'fixed-pitch-mode)
					;(add-hook 'eshell-mode-hook 'fixed-pitch-mode)
					;(add-hook 'bs-mode-hook 'fixed-pitch-mode)
					;(add-hook 'w3m-mode-hook 'variable-pitch-mode)
					;(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'eww-mode-hook 'variable-pitch-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not using but good ideas below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defvar my-keys-minor-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-i") 'some-function)
;;     map)
;;   "my-keys-minor-mode keymap.")

;; (define-minor-mode my-keys-minor-mode
;;   "A minor mode so that my key settings override annoying major modes."
;;   :init-value t
;;   :lighter " my-keys")

;; (my-keys-minor-mode 1)

;; (defun my-minibuffer-setup-hook ()
;;   (my-keys-minor-mode 0))

;; (add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; Remove with emacs 26.2 as new variable auto-save-no-message was added
;; custom autosave to suppress messages
;;
;; For some reason `do-auto-save' doesn't work if called manually
;; after switching off the default autosave altogether. Instead set
;; to a long timeout so it is not called.
;; (setq auto-save-timeout 99999)

;; ;; Set up my timer
;; (defvar bjm/auto-save-timer nil
;;   "Timer to run `bjm/auto-save-silent'")

;; ;; Auto-save every 5 seconds of idle time
;; (defvar bjm/auto-save-interval 10
;;   "How often in seconds of idle time to auto-save with `bjm/auto-save-silent'")

;; ;; Function to auto save files silently
;; (defun bjm/auto-save-silent ()
;;   "Auto-save all buffers silently"
;;   (interactive)
;;   (do-auto-save t))

;; ;; Start new timer
;; (setq bjm/auto-save-timer
;;       (run-with-idle-timer 0 bjm/auto-save-interval 'bjm/auto-save-silent))
