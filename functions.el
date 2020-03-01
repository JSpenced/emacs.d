;; -*- mode: Emacs-Lisp -*-
(define-prefix-command 'commandpalette-map)
(global-set-key (kbd "s-p") 'commandpalette-map)
(define-prefix-command 'comment-map)
(global-set-key (kbd "s-/") 'comment-map)
(define-prefix-command 'jj-command-m-map)
(global-set-key (kbd "s-m") 'jj-command-m-map)
(define-prefix-command 'dumb-jump-map)
(global-set-key (kbd "M-g d") 'dumb-jump-map)
(define-prefix-command 'jj-eyebrowse-wg-map)
(global-set-key (kbd "M-1") 'jj-eyebrowse-wg-map)
(define-prefix-command 'tags-jump-map)
(global-set-key (kbd "M-g t") 'tags-jump-map)
(defvar grep-and-find-map (make-sparse-keymap))
(define-key global-map "\C-xf" grep-and-find-map)

;; ensures packages are installed or installs them but doesn't keep them updated
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(require 'todotxt)
(require 'multiple-cursors)
(require 'expand-region)
(require 'avy)
(require 'openwith)
(require 'savehist)
(require 'ivy-dired-history)
(require 'ace-jump-zap)
(require 'visible-mark)
(require 'dash)
(require 'visual-regexp)
(require 'visual-regexp-steroids)
(require 'transpose-frame)
(require 'desktop)
(require 'tiny)
(require 'dired-x)
(require 'dired-aux)
(require 'find-dired)
(require 'peep-dired)
(require 'dired-ranger)
(require 'dired-narrow)
(require 'dired-filter)
;; TODO: get dired+ working properly (one issue is doesn't flag dot files as before)
;; emailed Drew Adams "drew.adams@oracle.com"
(require 'whole-line-or-region)
(require 'backup-each-save)
(require 'wttrin)
(require 'frame-cmds)
(require 'f)
(require 'evil)
(require 'pdf-tools)
(require 'gse-number-rect)
(require 'man)
(require 'smartparens)
(require 'dtrt-indent)
(require 'clean-aindent-mode)
(require 'ws-butler)
(require 'whitespace-cleanup-mode)
(require 'cyphejor)
(require 'org-download)
(require 'dumb-jump)
(require 'counsel-projectile)
(counsel-projectile-mode)
(require 'back-button)
(back-button-mode 1)
;; (require 'nice-jumper)
;; (global-nice-jumper-mode t)

(use-package ibuffer
  :bind (
		 :map ibuffer-mode-map
		 :prefix-map ibuffer-h-prefix-map
		 :prefix "h"
		 ("h" . describe-mode)
		 ("g" . ibuffer-clear-filter-groups)
		 ("r" . ibuffer-clear-filter-groups)
		 ("l" . jj/ibuffer-jump-to-last-buffer))
  :config
  (defun jj/ibuffer-jump-to-last-buffer ()
	(interactive)
	(ibuffer-jump-to-buffer (buffer-name (cadr (buffer-list)))))
  )

(use-package ibuffer-vc
  :bind (:map ibuffer-h-prefix-map
			  ("v" . jj/ibuffer-vc-set-filter-groups-by-vc-root)
			  ("V" . jj/ibuffer-vc-refresh-state))
  :config
  (defun jj/vc-refresh-state-all-buffers ()
	"Refresh all vc buffer statuses by calling `vc-refresh-state` on each one if it has an associated vc backend. Uses functions from `ibuffer-vc`, so decouple these functions if you need to use this without loading ibuffer-vc."
	(interactive)
	(dolist (buf (buffer-list))
	  (let ((file-name (with-current-buffer buf
						 (file-truename (or buffer-file-name
											default-directory)))))
		(when (ibuffer-vc--include-file-p file-name)
		  (let ((backend (ibuffer-vc--deduce-backend file-name)))
			(when backend
			  (with-current-buffer buf (vc-refresh-state))
			  ))))))

  (defun jj/ibuffer-vc-refresh-state ()
	"Refresh all vc buffer statuses and redisplay to update the current status in ibuffer."
	(interactive)
	(jj/vc-refresh-state-all-buffers)
	(ibuffer-redisplay))

  (defun jj/ibuffer-vc-set-filter-groups-by-vc-root ()
	"First run `ibuffer-vc-set-filter-groups-by-vc-root` and then `jj/ibuffer-jump-to-last-buffer`."
	(interactive)
	(ibuffer-vc-set-filter-groups-by-vc-root)
	(jj/ibuffer-jump-to-last-buffer))

  (add-hook 'ibuffer-mode-hook 'jj/ibuffer-vc-refresh-state)
  )

(require 'vlf-setup)
(require 'doom-todo-ivy)
(use-package magit-todos
  :after magit
  :after hl-todo
  :init
  (setq magit-todos-update 86400)
  ;; Needs entire regex set to optional if you want to recognize words not ending with suffixes
  ;; (setq magit-todos-keyword-suffix nil)
  :config
  ;; nil Forces manual update of magit-todos
  ;; or int is number of seconds (so updates every 24 hours)
  (magit-todos-mode))
(use-package hideshow
  :bind (("<escape> f" . hs-toggle-hiding)
	 ("<escape> F" . hs-show-block)
	 ("C-c f s" . hs-show-block)
	 ("C-c f S" . hs-show-all)
	 ("C-c f h" . hs-hide-block)
	 ("C-c f H" . hs-hide-all)
	 ("C-c f t" . hs-toggle-hiding)
	 ("C-c f a" . hs-show-all))
  :init (add-hook 'json-mode-hook #'hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (setq hs-special-modes-alist
	(mapcar 'purecopy
		'((c-mode "{" "}" "/[*/]" nil nil)
		  (c++-mode "{" "}" "/[*/]" nil nil)
		  (java-mode "{" "}" "/[*/]" nil nil)
		  (js-mode "{" "}" "/[*/]" nil)
		  (js2-mode "{" "}" "/[*/]" nil)
		  (json-mode "{" "}" "/[*/]" nil)
		  (javascript-mode  "{" "}" "/[*/]" nil)))))
(use-package sentence-navigation :defer t)
(use-package xah-lookup
  :defer 6
  :config

  (defun xah-lookup-word-thesaurus-eww (&optional @word)
	"Lookup definition of current word or text selection in URL `http://www.freethesaurus.com/curlicue'.
Version 2017-02-09"
	(interactive)
	(xah-lookup-word-on-internet
	 @word
	 (get 'xah-lookup-word-thesaurus-eww 'xah-lookup-url)
	 (get 'xah-lookup-word-thesaurus-eww 'xah-lookup-browser-function))
	;;
	)
  (put 'xah-lookup-word-thesaurus-eww 'xah-lookup-url "http://www.freethesaurus.com/word02051")
  (put 'xah-lookup-word-thesaurus-eww 'xah-lookup-browser-function 'eww)

  (defun xah-lookup-word-thesaurus (&optional @word)
	"Lookup definition of current word or text selection in URL `http://www.freethesaurus.com/curlicue'.
Version 2017-02-09"
	(interactive)
	(xah-lookup-word-on-internet
	 @word
	 (get 'xah-lookup-word-thesaurus 'xah-lookup-url )
	 (get 'xah-lookup-word-thesaurus 'xah-lookup-browser-function ))
	;;
	)
  (put 'xah-lookup-word-thesaurus 'xah-lookup-url "http://www.freethesaurus.com/word02051")
  (put 'xah-lookup-word-thesaurus 'xah-lookup-browser-function xah-lookup-browser-function)

  (defun xah-lookup-word-definition-eww (&optional @word)
	"Lookup definition of current word or text selection in URL `http://www.thefreedictionary.com/curlicue'.
Version 2017-02-09"
	(interactive)
	(xah-lookup-word-on-internet
	 @word
	 (get 'xah-lookup-word-definition-eww 'xah-lookup-url )
	 (get 'xah-lookup-word-definition-eww 'xah-lookup-browser-function ))
	;;
	)
  (put 'xah-lookup-word-definition-eww 'xah-lookup-url "http://www.thefreedictionary.com/word02051")
  (put 'xah-lookup-word-definition-eww 'xah-lookup-browser-function 'eww)

  (defun xah-lookup-power-thesaurus-eww (&optional @word)
	"Lookup definition of current word or text selection in URL `http://www.thefreedictionary.com/curlicue'.
Version 2017-02-09"
	(interactive)
	(xah-lookup-word-on-internet
	 @word
	 (get 'xah-lookup-power-thesaurus-eww 'xah-lookup-url)
	 (get 'xah-lookup-power-thesaurus-eww 'xah-lookup-browser-function))
	;;
	)
  (put 'xah-lookup-power-thesaurus-eww 'xah-lookup-url "http://www.powerthesaurus.org/word02051/synonyms")
  (put 'xah-lookup-power-thesaurus-eww 'xah-lookup-browser-function 'eww)

  (defun xah-lookup-power-thesaurus (&optional @word)
	"Lookup definition of current word or text selection in URL `http://www.thefreedictionary.com/curlicue'.
Version 2017-02-09"
	(interactive)
	(xah-lookup-word-on-internet
	 @word
	 (get 'xah-lookup-power-thesaurus 'xah-lookup-url)
	 (get 'xah-lookup-power-thesaurus 'xah-lookup-browser-function))
	;;
	)
  (put 'xah-lookup-power-thesaurus 'xah-lookup-url "http://www.powerthesaurus.org/word02051/synonyms")
  (put 'xah-lookup-power-thesaurus 'xah-lookup-browser-function xah-lookup-browser-function)
  )
(use-package poporg :defer t
  ;; bind: doesn't work here I think because prefix defined outside package
  ;; :bind (("s-/ o" . poporg-dwim))
  ;; :bind (("s-/ j" . poporg-dwim))
  )
;; (use-package total-lines
;;   :config (global-total-lines-mode))
(use-package darkroom :defer 6
  :init
  (setq darkroom-text-scale-increase 1))
(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; turn off cua so copy works
  ;; turn on pdf-view-auto-slice-minor-mode so runs s b automatically
  (add-hook 'pdf-view-mode-hook
		(lambda () (cua-mode 0)
		  (pdf-view-auto-slice-minor-mode)))
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)

  (defvar jj/pdftools-selected-pages '())

  (defun jj/pdftools-select-page ()
	"Add current page to list of selected pages."
	(interactive)
	(add-to-list 'jj/pdftools-selected-pages (pdf-view-current-page) t))

  (defun jj/pdftools-unselect-page ()
	"Add current page to list of selected pages."
	(interactive)
	(setq jj/pdftools-selected-pages (delete (pdf-view-current-page)  jj/pdftools-selected-pages)))

  (defun jj/pdftools-extract-selected-pages (file)
	"Save selected pages to FILE."
	(interactive "FSave as: ")
	(setq jj/pdftools-selected-pages (sort jj/pdftools-selected-pages #'<))
	(start-process "pdfjam" "*pdfjam*"
		   "pdfjam"
		   (buffer-file-name)
		   (mapconcat #'number-to-string
				  jj/pdftools-selected-pages
				  ",")
		   "-o"
		   (expand-file-name file)))

  ;; keyboard shdefine-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map "S" #'jj/pdftools-select-page)
  (define-key pdf-view-mode-map "U" #'jj/pdftools-unselect-page)
  (define-key pdf-view-mode-map "u" #'jj/pdftools-unselect-page)
  (define-key pdf-view-mode-map "l" #'jj/pdftools-select-page)
  (define-key pdf-view-mode-map "s s" #'jj/pdftools-select-page)
  (define-key pdf-view-mode-map "e" #'jj/pdftools-extract-selected-pages)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))
(use-package eyebrowse
  :diminish eyebrowse-mode
  :init
  (setq eyebrowse-keymap-prefix (kbd "C-c w"))
  (setq eyebrowse-new-workspace nil)
  (setq eyebrowse-switch-back-and-forth t)
  :bind
  (("s-{" . eyebrowse-prev-window-config)
   ("s-}" . eyebrowse-next-window-config)
   ("M-2" . eyebrowse-switch-to-window-config-2)
   ("M-3" . eyebrowse-switch-to-window-config-3)
   ("M-4" . eyebrowse-switch-to-window-config-4)
   ("M-5" . eyebrowse-switch-to-window-config-5)
   ("M-5" . eyebrowse-switch-to-window-config-5)
   ("M-6" . eyebrowse-switch-to-window-config-6)
   ("M-7" . eyebrowse-switch-to-window-config-7)
   ("M-8" . eyebrowse-switch-to-window-config-8)
   ("M-9" . eyebrowse-switch-to-window-config-9)
   ("M-<f11>" . eyebrowse-switch-to-window-config-21)
   ("M-<f12>" . eyebrowse-switch-to-window-config-22)

   ;; :prefix-map jj-eyebrowse-wg-map
   ;; :prefix "M-1"
   :map jj-eyebrowse-wg-map
   ("C-c" . eyebrowse-create-window-config)
   ("\"" . eyebrowse-close-window-config)
   ("k" . jj/eyebrowse-close-window-config-switch-to-2)
   ("'" . eyebrowse-last-window-config)
   ("," . eyebrowse-rename-window-config)
   ("." . eyebrowse-switch-to-window-config)
   ("b" . eyebrowse-switch-to-window-config)
   ("<return>" . eyebrowse-switch-to-window-config)
   ("0" . eyebrowse-switch-to-window-config-0)
   ("1" . eyebrowse-switch-to-window-config-1)
   ("M-1" . eyebrowse-last-window-config)
   ("2" . eyebrowse-switch-to-window-config-2)
   ("3" . eyebrowse-switch-to-window-config-3)
   ("4" . eyebrowse-switch-to-window-config-4)
   ("5" . eyebrowse-switch-to-window-config-5)
   ("6" . eyebrowse-switch-to-window-config-6)
   ("7" . eyebrowse-switch-to-window-config-7)
   ("8" . eyebrowse-switch-to-window-config-8)
   ("9" . eyebrowse-switch-to-window-config-9)
   ("<f1>" . eyebrowse-switch-to-window-config-11)
   ("<f2>" . eyebrowse-switch-to-window-config-12)
   ("<f3>" . eyebrowse-switch-to-window-config-13)
   ("<f4>" . eyebrowse-switch-to-window-config-14)
   ("<f5>" . eyebrowse-switch-to-window-config-15)
   ("<f6>" . eyebrowse-switch-to-window-config-16)
   ("<f7>" . eyebrowse-switch-to-window-config-17)
   ("<f8>" . eyebrowse-switch-to-window-config-18)
   ("<f9>" . eyebrowse-switch-to-window-config-19)
   ("<f10>" . eyebrowse-switch-to-window-config-20)
   ("<f11>" . eyebrowse-switch-to-window-config-21)
   ("<f12>" . eyebrowse-switch-to-window-config-22)
   ("," . eyebrowse-prev-window-config)
   ("." . eyebrowse-next-window-config)
   ("'" . eyebrowse-next-window-config)
   ("c" . eyebrowse-create-window-config))
  :config (eyebrowse-mode t))

(use-package chronos
  :config
  ;; (use-package chronos)
  ;; https://github.com/dxknight/chronos
  ;; now is 17:00
  ;; 5 gives an expiry time of 17:05
  ;; 1:30 gives 18:30
  ;; 0:0:30 gives 30 seconds after 17:00
  ;; empty or 0 gives a count up timer starting now, at 17:00.

  ;; =17:00/Drink coffee + -5/Brew coffee + -5/Boil kettle + 25/Finish break
  ;; Which will give a timer at 5 o'clock to drink coffee, a timer five minutes before that (16:55) to
  ;; start brewing the coffee, a reminder five minutes before that (16:50) to put the kettle on and a
  ;; reminder 25 minutes after that (17:15) to finish drinking coffee and get back to work.

  ;; Key	Action
  ;; a	add a timer by specifying expiry time and a message
  ;; A	add multiple consecutive timer(s) in one go
  ;; n/p	move selection down/up (also C-n/C-p <down>/<up>)
  ;; SPC	pause/unpause (pausing affects time to go and the expiry time, but not elapsed time)
  ;; d	delete selected timer
  ;; D	delete all expired timers
  ;; e	edit selected timer
  ;; l	lap selected timer
  ;; F	freeze/unfreeze the display
  ;; q	quit window



  (defun jj/chronos-shell-notify (c)
	"Notify expiration of timer C by running a shell command."
	;; NOTE: for alarm.wav to work has to be copied to /System/Library/sounds
	(if (eq system-type 'darwin)
	(chronos--shell-command "Chronos shell notification for Mac OS X"
				"/usr/local/bin/terminal-notifier"
				(list "-ignoreDnD" "-sound" "alarm.wav" "-title" "Chronos Timer" "-message" (chronos--message c))
				)
	  (chronos--shell-command "Chronos shell notification for Linux & Windows"
				  "notify-send"
				  (list "-t" "3600000" "Chronos Timer" (chronos--message c))))
	;; 24*60*60*1000 = 86400000  60*60*1000 = 3600000
	)

  (setq
   ;; chronos-shell-notify-program "mpg123"
   ;; chronos-shell-notify-parameters '("-q ~/.emacs.d/manual-addons/sounds/end.mp3")
   ;; chronos-shell-notify-program "notify-send"
   ;; chronos-shell-notify-parameters '("-t" "0" "Сработал таймер")
   chronos-notification-wav (expand-file-name "~/Programs/scimax/user/sounds/techno.wav")
   chronos-expiry-functions '(chronos-buffer-notify
				  jj/chronos-shell-notify
				  chronos-message-notify
				  ;; chronos-sound-notify
				  ))
  (use-package helm-chronos)
  ;; hack for manual addons. helm updates?
  (setq helm-chronos--fallback-source
	(helm-build-dummy-source "test"
	  :action '(("Add timer" . helm-chronos--parse-string-and-add-timer))))

  (setq helm-chronos-standard-timers
	'(
	  "45/P: Work + 6/P: Break"
	  "45/P: Work"
	  " 6/Break"
	  "15/Long Break"
	  ))

  ;; (global-set-key (kbd "s-p t") 'helm-chronos-add-timer)
  (global-set-key (kbd "s-t") 'helm-chronos-add-timer)
  (defun jj/helm-chronos-add-timer-switch-to-chronos ()
	(interactive)(helm-chronos-add-timer)(switch-to-buffer "*chronos*"))
  (defun jj/switch-to-chronos ()
	(interactive)(switch-to-buffer "*chronos*"))
  (global-set-key (kbd "s-p s-T") 'jj/helm-chronos-add-timer-switch-to-chronos)
  ;; Don't use helm if I don't want the timer stored
  (global-set-key (kbd "s-p t") 'chronos-add-timer)
  (global-set-key (kbd "s-p M-t") 'chronos-add-timer)
  ;; (global-set-key (kbd "s-p T") 'chronos-add-timers-from-string)
  (global-set-key (kbd "s-p s-t") 'jj/switch-to-chronos)
  (global-set-key (kbd "s-p T") 'chronos-delete-all-expired))

(use-package goto-chg :defer t
  :bind (("M-[" . goto-last-change)
	 ("M-]" . jj/goto-last-change-reverse)
	 ("C-M-s-0" . jj/goto-last-change-back-to-first))
  )

(use-package grip-mode
  :ensure t
  :bind (:map markdown-mode-command-map
		  ("g" . grip-mode)))

(use-package wgrep
  :custom
  ;; (wgrep-auto-save-buffer t)
  (wgrep-change-readonly-file t))

(use-package ag
  :custom
  (ag-highligh-search t)
  (ag-reuse-buffers t)
  (ag-reuse-window t)
  ;; :bind
  ;; ("M-s a" . ag-project)
  :config
  (use-package wgrep-ag))

(use-package deadgrep
  :bind (("C-x f d" . deadgrep))
  :config
  (define-key deadgrep-mode-map (kbd "C-c j") 'counsel-imenu)
  (define-key deadgrep-mode-map (kbd "C-c C-j") 'counsel-semantic-or-imenu)
  (define-key deadgrep-mode-map (kbd "i") 'counsel-imenu)
  (define-key deadgrep-mode-map (kbd "j") 'counsel-imenu))

;; latexmk works for compiling but not updating viewers
;; (require 'auctex-latexmk)
;; (require 'workgroups2)
;; (require 'evil-nerd-commenter)
;; (require 'counsel-etags)
(eval-when-compile (require 'cl))
;; (require 'dired-subtree)
;; Not installed but can use for two-pane dired work
;; (require 'sunrise-commander)

;; Needs to be installed but can be used for dedicatiing windows and reloading window configurations
;; (require 'window-purpose)

(defun toggle-alternative-input-method (method &optional arg interactive)
  (if arg
	  (toggle-input-method arg interactive)
	(let ((previous-input-method current-input-method))
	  (when current-input-method
	(deactivate-input-method))
	  (unless (and previous-input-method
		   (string= previous-input-method method))
	(activate-input-method method)))))

(defun reload-alternative-input-methods ()
  (dolist (config alternative-input-methods)
	(let ((method (car config)))
	  (global-set-key (cdr config)
			  `(lambda (&optional arg interactive)
			 ,(concat "Behaves similar to `toggle-input-method', but uses \""
				  method "\" instead of `default-input-method'")
			 (interactive "P\np")
			 (toggle-alternative-input-method ,method arg interactive))))))

(defun jj/swiper-symbol-at-point ()
  "Get the current symbol at point all buffers"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'symbol))))
  (swiper (format "%s" (thing-at-point 'symbol))))
(defun jj/swiper-word-at-point ()
  "Get the current word at point all buffers"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'word))))
  (swiper (format "%s" (thing-at-point 'word))))

(defun jj/swiper-region ()
  "Use current region if active for swiper search"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'word))))
  (if (use-region-p)
	  (swiper (format "%s" (buffer-substring (region-beginning) (region-end))))
	(swiper)))

(defun jj/counsel-grep-or-swiper-symbol-at-point ()
  "Get the current symbol at point all buffers"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'symbol))))
  (counsel-grep-or-swiper (format "%s" (thing-at-point 'symbol))))
(defun jj/counsel-grep-or-swiper-word-at-point ()
  "Get the current word at point all buffers"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'word))))
  (counsel-grep-or-swiper (format "%s" (thing-at-point 'word))))
(defun jj/counsel-grep-or-swiper-region ()
  "Use current region if active for swiper search"
  (interactive)
  ;; (swiper (format "\\<%s\\>" (thing-at-point 'word))))
  (if (use-region-p)
	  (counsel-grep-or-swiper (format "%s" (buffer-substring (region-beginning) (region-end))))
	(swiper)))
(defun jj/counsel-find-name-everything ()
  "list everything recursively"
  (interactive)
  (let* ((cands (split-string
		 (shell-command-to-string "find .") "\n" t)))
	(ivy-read "File: " cands
		  :action #'find-file
		  :caller 'jj/counsel-find-name-everything)))

(defun jj/make-current-mark-region-active ()
  "Make the current mark region active"
  (interactive)
	(exchange-point-and-mark)
	  (exchange-point-and-mark))

(defun jj/duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
	With argument N, make N copies.
	With negative N, comment out original line and use the absolute value."
  (interactive "*p")
  (let ((use-region (use-region-p)))
	(save-excursion
	  (let ((text (if use-region        ;Get region if active, otherwise line
			  (buffer-substring (region-beginning) (region-end))
			(prog1 (thing-at-point 'line)
			  (end-of-line)
			  (if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
			  (newline))))))
	(dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
	  (insert text))))
	(if use-region nil                  ;Only if we're working with a line (not a region)
	  (let ((pos (- (point) (line-beginning-position)))) ;Save column
	(if (> 0 n)                             ;Comment out original with negative arg
		(comment-region (line-beginning-position) (line-end-position)))
	(forward-line 1)
	(forward-char pos)))))

(defun jj/backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line 0)
  (indent-relative))

;; duplicate current line
(defun jj/duplicate-line (&optional n)
  "duplicate current line, make more than 1 copy given a numeric argument"
  (interactive "p")
  (save-excursion
	(let ((nb (or n 1))
	  (current-line (thing-at-point 'line)))
	  ;; when on last line, insert a newline first
	  (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
	(insert "\n"))

	  ;; now insert as many time as requested
	  (while (> n 0)
	(insert current-line)
	(decf n)))))

;; (defun jj/duplicate-line ()
;;   (interactive)
;;   (let ((col (current-column)))
;;     (move-beginning-of-line 1)
;;     (kill-line)
;;     (yank)
;;     (newline)
;;     (yank)
;;     (move-to-column col)))

(defun jj/delete-forward-sexp-or-dir (&optional p)
  "Kill forward sexp or directory.
If inside a string or minibuffer, and if it looks like
we're typing a directory name, kill forward until the next
/. Otherwise, `kill-sexp'"
  (interactive "p")
  (if (< p 0)
	  (jj/delete-backward-sexp-or-dir (- p))
	(let ((r (point)))
	  (if (and (or (in-string-p)
		   (minibuffer-window-active-p
			(selected-window)))
		   (looking-at "[^[:blank:]\n\r]*[/\\\\]"))
	  (progn (search-forward-regexp
		  "[/\\\\]" nil nil p)
		 (delete-region r (point)))
	(jj/delete-sexp p)))))

(defun jj/delete-backward-sexp-or-dir (&optional p)
  "Kill backwards sexp or directory."
  (interactive "p")
  (if (< p 0)
	  (jj/delete-forward-sexp-or-dir (- p))
	(let ((r (point))
	  (l (save-excursion
		   (point))))
	  (if (and (or (in-string-p)
		   (minibuffer-window-active-p
			(selected-window)))
		   (looking-back "[/\\\\][^[:blank:]\n\r]*"))
	  (progn (backward-char)
		 (search-backward-regexp
		  "[/\\\\]" (point-min) nil p)
		 (forward-char)
		 (delete-region (point) l))
	(jj/delete-sexp (- p))))))

(defun jj/kill-sexp-forward-or-dir (&optional p)
  "Kill forward sexp or directory.
If inside a string or minibuffer, and if it looks like
we're typing a directory name, kill forward until the next
/. Otherwise, `kill-sexp'"
  (interactive "p")
  (if (< p 0)
	  (jj/backward-kill-sexp-or-dir (- p))
	(let ((r (point)))
	  (if (and (or (in-string-p)
		   (minibuffer-window-active-p
			(selected-window)))
		   (looking-at "[^[:blank:]\n\r]*[/\\\\]"))
	  (progn (search-forward-regexp
		  "[/\\\\]" nil nil p)
		 (kill-region r (point)))
	(kill-sexp p)))))

(defun jj/backward-kill-sexp-or-dir (&optional p)
  "Kill backwards sexp or directory."
  (interactive "p")
  (if (< p 0)
	  (jj/forward-kill-sexp-or-dir (- p))
	(let ((r (point))
	  (l (save-excursion
		   (point))))
	  (if (and (or (in-string-p)
		   (minibuffer-window-active-p
			(selected-window)))
		   (looking-back "[/\\\\][^[:blank:]\n\r]*"))
	  (progn (backward-char)
		 (search-backward-regexp
		  "[/\\\\]" (point-min) nil p)
		 (forward-char)
		 (kill-region (point) l))
	(kill-sexp (- p))))))

(defun jj/dark-theme-set-visible-mark-faces ()
  (interactive)
  (setq visible-mark-faces `(visible-mark-magenta visible-mark-dark-teal)))
(defun jj/light-theme-set-visible-mark-faces ()
  (interactive)
  (setq visible-mark-faces `(visible-mark-face1 visible-mark-face2)))

(defun jj/delete-sexp (&optional arg)
  "Kill the sexp (balanced expression) following point.
With ARG, kill that many sexps after point.
Negative arg -N means kill N sexps before point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (let ((opoint (point)))
	(forward-sexp (or arg 1))
	(delete-region opoint (point))))

(defun jj/delete-backward-sexp (&optional arg)
  "Kill the sexp (balanced expression) preceding point.
With ARG, kill that many sexps before point.
Negative arg -N means kill N sexps after point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (jj/delete-sexp (- (or arg 1))))

(defun jj/delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
	 (forward-word arg)
	 (point))))

(defun jj/delete-backward-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (jj/delete-word (- arg)))

(defun jj/delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (jj/delete-line 0)
  (indent-for-tab-command))

(defun jj/kill-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (kill-line 0)
  (indent-for-tab-command))

;; visual-line-mode remaps kill-line
;; (define-key visual-line-mode-map [remap kill-line] nil)
(defun jj/kill-line (&optional arg)
  "Kill the rest of the current line; if no nonblanks there, kill thru newline.
With prefix argument ARG, kill that many lines from point.
Negative arguments kill lines backward.
With zero argument, kills the text before point on the current line.

When calling from a program, nil means \"no arg\",
a number counts as a prefix arg.

To kill a whole line, when point is not at the beginning, type \
\\[move-beginning-of-line] \\[kill-line] \\[kill-line].

If `show-trailing-whitespace' is non-nil, this command will just
kill the rest of the current line, even if there are no nonblanks
there.

If option `kill-whole-line' is non-nil, then this command kills the whole line
including its terminating newline, when used at the beginning of a line
with no argument.  As a consequence, you can always kill a whole line
by typing \\[move-beginning-of-line] \\[kill-line].

If you want to append the killed line to the last killed text,
use \\[append-next-kill] before \\[kill-line].

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive "P")
  (kill-region (point)
		   ;; It is better to move point to the other end of the kill
		   ;; before killing.  That way, in a read-only buffer, point
		   ;; moves across the text that is copied to the kill ring.
		   ;; The choice has no effect on undo now that undo records
		   ;; the value of point from before the command was run.
		   (progn
		 (if arg
			 (forward-visible-line (prefix-numeric-value arg))
		   (if (eobp)
			   (signal 'end-of-buffer nil))
		   (let ((end
			  (save-excursion
				(end-of-visible-line) (point))))
			 (if (or (save-excursion
				   ;; If trailing whitespace is visible,
				   ;; don't treat it as nothing.
				   (unless show-trailing-whitespace
				 (skip-chars-forward " \t" end))
				   (= (point) end))
				 (and kill-whole-line (bolp)))
			 (forward-visible-line 1)
			   (goto-char end))))
		 (point))))

(defun jj/kill-line-save (&optional arg)
  "Kill the rest of the current line; if no nonblanks there, kill thru newline.
With prefix argument ARG, kill that many lines from point.
Negative arguments kill lines backward.
With zero argument, kills the text before point on the current line.

When calling from a program, nil means \"no arg\",
a number counts as a prefix arg.

To kill a whole line, when point is not at the beginning, type \
\\[move-beginning-of-line] \\[kill-line] \\[kill-line].

If `show-trailing-whitespace' is non-nil, this command will just
kill the rest of the current line, even if there are no nonblanks
there.

If option `kill-whole-line' is non-nil, then this command kills the whole line
including its terminating newline, when used at the beginning of a line
with no argument.  As a consequence, you can always kill a whole line
by typing \\[move-beginning-of-line] \\[kill-line].

If you want to append the killed line to the last killed text,
use \\[append-next-kill] before \\[kill-line].

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive "P")
  (save-mark-and-excursion (copy-region-as-kill (point)
						;; It is better to move point to the other end of the kill
						;; before killing.  That way, in a read-only buffer, point
						;; moves across the text that is copied to the kill ring.
						;; The choice has no effect on undo now that undo records
						;; the value of point from before the command was run.
						(progn
						  (if arg
							  (forward-visible-line (prefix-numeric-value arg))
							(if (eobp)
							(signal 'end-of-buffer nil))
							(let ((end
							   (save-excursion
								 (end-of-visible-line) (point))))
							  (if (or (save-excursion
								;; If trailing whitespace is visible,
								;; don't treat it as nothing.
								(unless show-trailing-whitespace
								  (skip-chars-forward " \t" end))
								(= (point) end))
								  (and kill-whole-line (bolp)))
							  (forward-visible-line 1)
							(goto-char end))))
						  (point)))))

;; (defun jj/slick-cut (beg end)
;;   (interactive
;;    (if mark-active
;;        (list (region-beginning) (region-end))
;;      (list (line-beginning-position) (line-beginning-position 2)))))

;; (defun jj/slick-copy (beg end)
;;   (interactive
;;    (if mark-active
;;        (list (region-beginning) (region-end))
;;      (message "Copied line")
;;      (list (line-beginning-position) (line-beginning-position 2)))))

(defun jj/copy-line-or-region ()
  "Copy current line, or text selection.
When `universal-argument' is called first, copy whole buffer (but respect `narrow-to-region')."
  (interactive)
  (let (p1 p2)
	(if (null current-prefix-arg)
	(progn (if (use-region-p)
		   (progn (setq p1 (region-beginning))
			  (setq p2 (region-end)))
		 (progn (setq p1 (line-beginning-position))
			(setq p2 (line-end-position)))))
	  (progn (setq p1 (point-min))
		 (setq p2 (point-max))))
	(kill-ring-save p1 p2)))

(defun jj/cut-line-or-region ()
  "Cut current line, or text selection.
When `universal-argument' is called first, cut whole buffer (but respect `narrow-to-region')."
  (interactive)
  (let (p1 p2)
	(if (null current-prefix-arg)
	(progn (if (use-region-p)
		   (progn (setq p1 (region-beginning))
			  (setq p2 (region-end)))
		 (progn (setq p1 (line-beginning-position))
			(setq p2 (line-beginning-position 2)))))
	  (progn (setq p1 (point-min))
		 (setq p2 (point-max))))
	(kill-region p1 p2)))

(defun jj/multi-pop-to-mark (orig-fun &rest args)
  "Call ORIG-FUN until the cursor moves.
Try the repeated popping up to 10 times."
  (let ((p (point)))
	(dotimes (i 10)
	  (when (= p (point))
	(apply orig-fun args)))))

(defun jj/uncomment-sexp (&optional n)
  "Uncomment a sexp around point."
  (interactive "P")
  (let* ((initial-point (point-marker))
	 (inhibit-field-text-motion t)
	 (p)
	 (end (save-excursion
		(when (elt (syntax-ppss) 4)
		  (re-search-backward comment-start-skip
					  (line-beginning-position)
					  t))
		(setq p (point-marker))
		(comment-forward (point-max))
		(point-marker)))
	 (beg (save-excursion
		(forward-line 0)
		(while (and (not (bobp))
				(= end (save-excursion
					 (comment-forward (point-max))
					 (point))))
		  (forward-line -1))
		(goto-char (line-end-position))
		(re-search-backward comment-start-skip
					(line-beginning-position)
					t)
		(ignore-errors
		  (while (looking-at-p comment-start-skip)
			(forward-char -1)))
		(point-marker))))
	(unless (= beg end)
	  (uncomment-region beg end)
	  (goto-char p)
	  ;; Indentify the "top-level" sexp inside the comment.
	  (while (and (ignore-errors (backward-up-list) t)
		  (>= (point) beg))
	(skip-chars-backward (rx (syntax expression-prefix)))
	(setq p (point-marker)))
	  ;; Re-comment everything before it.
	  (ignore-errors
	(comment-region beg p))
	  ;; And everything after it.
	  (goto-char p)
	  (forward-sexp (or n 1))
	  (skip-chars-forward "\r\n[:blank:]")
	  (if (< (point) end)
	  (ignore-errors
		(comment-region (point) end))
	;; If this is a closing delimiter, pull it up.
	(goto-char end)
	(skip-chars-forward "\r\n[:blank:]")
	(when (eq 5 (car (syntax-after (point))))
	  (delete-indentation))))
	;; Without a prefix, it's more useful to leave point where
	;; it was.
	(unless n
	  (goto-char initial-point))))

(defun jj/comment-sexp--raw ()
  "Comment the sexp at point or ahead of point."
  (pcase (or (bounds-of-thing-at-point 'sexp)
		 (save-excursion
		   (skip-chars-forward "\r\n[:blank:]")
		   (bounds-of-thing-at-point 'sexp)))
	(`(,l . ,r)
	 (goto-char r)
	 (skip-chars-forward "\r\n[:blank:]")
	 (save-excursion
	   (comment-region l r))
	 (skip-chars-forward "\r\n[:blank:]"))))

(defun jj/comment-or-uncomment-sexp (&optional n)
  "Comment the sexp at point and move past it.
If already inside (or before) a comment, uncomment instead.
With a prefix argument N, (un)comment that many sexps."
  (interactive "P")
  (if (or (elt (syntax-ppss) 4)
	  (< (save-excursion
		   (skip-chars-forward "\r\n[:blank:]")
		   (point))
		 (save-excursion
		   (comment-forward 1)
		   (point))))
	  (jj/uncomment-sexp n)
	(dotimes (_ (or n 1))
	  (jj/comment-sexp--raw))))

(defun jj/unwrap-next-sexp ()
  (interactive)
  (let ((close (progn (forward-sexp 1)
			  (point)))
	(open (progn (forward-sexp -1)
			 (point))))
	(goto-char close)
	(delete-char -1)
	(goto-char open)
	(delete-char 1)))

(defun jj/append-to-list (list-var elements)
  "Append ELEMENTS to the end of LIST-VAR.

The return value is the new value of LIST-VAR."
  (unless (consp elements)
	(error "ELEMENTS must be a list"))
  (let ((list (symbol-value list-var)))
	(if list
	(setcdr (last list) elements)
	  (set list-var elements)))
  (symbol-value list-var))

(defun jj/append-to-list-no-duplicates (list to-add &optional to-back)
  "Adds multiple items to LIST.
Allows for adding a sequence of items to the same list, rather
than having to call `add-to-list' multiple times.
If `to-back' is t then add to back of list."
  (interactive)
  (dolist (item to-add)
	(add-to-list list item (or to-back nil))))

(defun jj/evil-scroll-down-15-lines ()
  (interactive)
  (evil-scroll-line-down 15))

(defun jj/evil-scroll-up-15-lines ()
  (interactive)
  (evil-scroll-line-up 15))

(defun jj/org-next-item-at-ident (&optional n)
  (interactive "^p")
  (let ((sentence-end-double-space t) searchTo wordEnd2 checkBoxAt unordList ordList charBeg lineEnd)
	(let ((item (org-in-item-p))
	  (org-special-ctrl-a/e 'reversed))
	  (cond ((not item)
		 (end-of-line n))
		(t
		 (org-next-item)
		 (save-excursion
		   (setq charBeg (point))
		   (end-of-visual-line)
		   (setq lineEnd (point))
		   (beginning-of-visual-line)
		   (save-excursion
		 (re-search-forward "\\s-\\w" lineEnd t)
		 (re-search-forward "\\s-\\w" lineEnd t)
		 (setq wordEnd2 (point)))
		   (if (eq wordEnd2 charBeg)
		   (setq searchTo lineEnd)
		 (setq searchTo wordEnd2))
		   (save-excursion
		 (re-search-forward "\\[[X\\|\\ ]\\]" searchTo t)
		 (setq checkBoxAt (point)))
		   (save-excursion
		 (re-search-forward "\\s-*\d*\\." searchTo t)
		 (setq ordList (point)))
		   (save-excursion
		 (re-search-forward "\\s-*\\([+*]\\|-\\)" searchTo t)
		 (setq unordList (point))))
		 (cond
		  ((not (eq checkBoxAt charBeg))
		   (if (>= (+ checkBoxAt 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  checkBoxAt 1))))
		  ((not (eq ordList charBeg))
		   (if (>= (+ ordList 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  ordList 1))))
		  ((not (eq unordList charBeg))
		   (if (>= (+ unordList 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  unordList 1))))
		  ;; ((eq wordEnd1 lineEnd)
		  ;;  (end-of-visual-line))
		  ;; ((eq wordEnd2 lineEnd)
		  ;;  (end-of-visual-line)
		  ;;  (org-backward-sentence))
		  ;; ((eq wordEnd1 wordEnd2)
		  ;;  (end-of-visual-line))
		  ;; ((eq wordEnd2 charBeg)
		  ;;  (end-of-visual-line)
		  ;;  (org-backward-sentence))
		  ;; ((>= (+ wordEnd2 1) lineEnd)
		  ;;  (end-of-visual-line)
		  ;;  (org-backward-sentence))
		  ;; (t (goto-char (+ wordEnd2 1))
		  ;;		(org-backward-sentence))
		  )
		 ;; (message "CharBeg: %d. Checkboxat: %d Linend: %d. unordList: %d WordEnd: %d wordend2: %d" charBeg checkBoxAt lineEnd unordList wordEnd1 wordEnd2)
		 )))))
(defun jj/org-previous-item-at-ident (&optional n)
  (interactive "^p")
  (let ((sentence-end-double-space t) wordEnd2 searchTo checkBoxAt unordList ordList charBeg lineEnd)
	(let ((item (org-in-item-p))
	  (org-special-ctrl-a/e 'reversed))
	  (cond ((not item)
		 (beginning-of-line n))
		(t
		 (org-previous-item)
		 (save-excursion
		   (setq charBeg (point))
		   (end-of-visual-line)
		   (setq lineEnd (point))
		   (beginning-of-visual-line)
		   (save-excursion
		 (re-search-forward "\\s-\\w" lineEnd t)
		 (re-search-forward "\\s-\\w" lineEnd t)
		 (setq wordEnd2 (point)))
		   (if (eq wordEnd2 charBeg)
		   (setq searchTo lineEnd)
		 (setq searchTo wordEnd2))
		   (save-excursion
		 (re-search-forward "\\[[X\\|\\ ]\\]" searchTo t)
		 (setq checkBoxAt (point)))
		   (save-excursion
		 (re-search-forward "\\s-*\d*\\." searchTo t)
		 (setq ordList (point)))
		   (save-excursion
		 (re-search-forward "\\s-*\\([+*]\\|-\\)" searchTo t)
		 (setq unordList (point))))
		 (cond
		  ((not (eq checkBoxAt charBeg))
		   (if (>= (+ checkBoxAt 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  checkBoxAt 1))))
		  ((not (eq ordList charBeg))
		   (if (>= (+ ordList 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  ordList 1))))
		  ((not (eq unordList charBeg))
		   (if (>= (+ unordList 1) lineEnd)
		   (end-of-visual-line)
		 (goto-char (+  unordList 1))))
		  )
		 ;; (message "CharBeg: %d. Checkboxat: %d Linend: %d. unordList: %d WordEnd: %d wordend2: %d" charBeg checkBoxAt lineEnd unordList wordEnd1 wordEnd2)
		 )))))
;; NOTE: These don't work right because forward-element works in funky way
;; (defun jj/org-forward-element-at-ident ()
;;   (interactive)
;;   (let ((sentence-end-double-space t))
;;     (org-forward-element)
;;     (forward-char 30)
;;     (org-backward-sentence)
;;     ))
;; (defun jj/org-backward-element-at-ident ()
;;   (interactive)
;;   (let ((sentence-end-double-space t))
;;     (org-backward-element)
;;     (forward-char 25)
;;     (org-backward-sentence)
;;     ))

;; Org functions to create bullet points at the correct location
(defun jj/org-metaleft-next-line-previous-item ()
  (interactive)
  (scimax/org-return)
  (org-metaleft))
(defun jj/org-metaleft-next-line-beginning-item ()
	   (interactive)
	   (scimax/org-return)
	   (org-metaleft)
	   (org-metaleft)
	   (org-metaleft)
	   (org-metaleft))
(defun jj/org-move-headline-next-top-level ()
	   (interactive)
	   (scimax/org-return)
	   (org-metaright)
	   (org-cycle-list-bullet 5))
(defun jj/org-move-headline-next-second-level ()
  (interactive)
  (scimax/org-return)
  (org-metaright)
  (org-cycle-list-bullet 1))

;; Function as stated below
(defun jj/org-show-just-me (&rest _)
  "Fold all other trees, then show entire current subtree."
  (interactive)
  (org-overview)
  (org-reveal)
  (org-show-subtree))

(defun jj/org-babel-remove-result-all-blocks ()
  "Call org-babel-remove-result-one-or-many with prefix arg to remove
all blocks in document."
  (interactive)
  (org-babel-remove-result-one-or-many '(4)))

(defun jj/org-show-todo-tree-then-remove-occur-highlights (arg)
  "Run org-show-todo-tree then org-remove-occur-highlights to remove the highlights."
  (interactive "P")
  (save-excursion (org-show-todo-tree arg))
  (beginning-of-visual-line)
  (org-remove-occur-highlights))

(defun jj/org-table-wrap-to-width (width)
  "Wrap current column to WIDTH."
  (interactive (list (read-number "Enter column width: ")))
  (org-table-check-inside-data-field)
  (org-table-align)
  (let (cline
	(ccol (org-table-current-column))
	new-row-count
	(created-new-row-at-bottom nil)
	(orig-line (org-table-current-line))
	(more t))
	(org-table-goto-line 1)
	(org-table-goto-column ccol)
	(while more
	  (setq cline (org-table-current-line))
	  ;; Cut current field (sets org-table-clip)
	  (org-table-copy-region (point) (point) 'cut)
	  ;; Justify for width
	  (ignore-errors
	(setq org-table-clip
		  (mapcar 'list (org-wrap (caar org-table-clip) width nil))))
	  ;; Add new lines and fill
	  (setq new-row-count (1- (length org-table-clip)))
	  (org-table-goto-line cline)
	  (if (> new-row-count 0)
	  (setq created-new-row-at-bottom (jj/org-table-insert-n-row-below new-row-count)))
	  (org-table-goto-line cline)
	  (org-table-goto-column ccol)
	  (org-table-paste-rectangle)
	  (org-table-goto-line (+ cline new-row-count))
	  ;; Move to next line
	  (setq more (org-table-goto-line (+ cline new-row-count 1)))
	  (org-table-goto-column ccol))
	(when created-new-row-at-bottom
	  (org-shiftmetaup))
	(org-table-goto-line orig-line)
	(org-table-goto-column ccol)))

(defun jj/org-table-insert-n-row-below (n)
  "Insert N new lines below the current."
  (let (created-new-row-at-bottom)
	(dotimes (_ n)
	  (setq line (buffer-substring (point-at-bol) (point-at-eol)))
	  (forward-line 1)
	  (when (looking-at "^ *$")
	(insert (org-table-clean-line line))
	(setq created-new-row-at-bottom t))
	  (org-shiftmetadown))
	created-new-row-at-bottom))

(defun jj/org-table-column-wrap-to-point ()
  "Wrap text in current column to current point as rightmost
boundary."
  (interactive)
  (let (begin
	(end (point))
	cell-contents-to-point
	width
	cline
	(ccol (org-table-current-column))
	new-row-count
	(created-new-row-at-bottom nil)
	(orig-line (org-table-current-line))
	(more t))
	(save-excursion
	  (search-backward-regexp "|")
	  (forward-char 1)
	  (setq begin (point))
	  (setq cell-contents-to-point (buffer-substring begin end))
	  (setq width (length cell-contents-to-point)))
	(org-table-check-inside-data-field)
	(org-table-align)
	(org-table-goto-line 1)
	(org-table-goto-column ccol)
	(while more
	  (setq cline (org-table-current-line))
	  ;; Cut current field (sets org-table-clip)
	  (org-table-copy-region (point) (point) 'cut)
	  ;; Justify for width
	  (ignore-errors
	(setq org-table-clip
		  (mapcar 'list (org-wrap (caar org-table-clip) width nil))))
	  ;; Add new lines and fill
	  (setq new-row-count (1- (length org-table-clip)))
	  (org-table-goto-line cline)
	  (if (> new-row-count 0)
	  (setq created-new-row-at-bottom (jj/org-table-insert-n-row-below new-row-count)))
	  (org-table-goto-line cline)
	  (org-table-goto-column ccol)
	  (org-table-paste-rectangle)
	  (org-table-goto-line (+ cline new-row-count))
	  ;; Move to next line
	  (setq more (org-table-goto-line (+ cline new-row-count 1)))
	  (org-table-goto-column ccol))
	(when created-new-row-at-bottom
	  (org-shiftmetaup))
	(org-table-goto-line orig-line)
	(org-table-goto-column ccol)))

(defun jj/other-window-kill-buffer ()
  "Kill the buffer in the other window"
  (interactive)
  ;; Window selection is used because point goes to a different window
  ;; if more than 2 windows are present
  (let ((win-curr (selected-window))
	(win-other (next-window)))
	(select-window win-other)
	(kill-this-buffer)
	(select-window win-curr)))

(defvar jj/help-window-names
  '(
	;; Ubiquitous help buffers
	"*Help*"
	"*Apropos*"
	"*Messages*"
	"*Completions*"
	;; Other general buffers
	"*Command History*"
	"*Compile-Log*"
	"*disabled command*")
  "Names of buffers that `jj/quit-help-windows' should quit.")

(defun jj/quit-help-windows (&optional kill frame)
  "Quit all windows with help-like buffers.

Call `quit-windows-on' for every buffer named in
`jj/help-windows-name'.  The optional parameters KILL and FRAME
are just as in `quit-windows-on', except FRAME defaults to t (so
that only windows on the selected frame are considered).

Note that a nil value for FRAME cannot be distinguished from an
omitted parameter and will be ignored; use some other value if
you want to quit windows on all frames."
  (interactive)
  (let ((frame (or frame t)))
	(dolist (name jj/help-window-names)
	  (ignore-errors
	(quit-windows-on name kill frame)))))

(defun jj/current-buffer-to-other-windoww-display-previous-buffer ()
  "Throw current buffer to other window, display previous buffer
in this window."
  (interactive)
  (save-selected-window
	(switch-to-buffer-other-window (current-buffer)))
  (switch-to-buffer (other-buffer)))

(defun jj/delete-other-windows-switch-other-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (jj/switch-to-previous-buffer)
  (delete-other-windows)
  (recenter-top-bottom))

(defun jj/split-window-below-and-balance (&optional wenshan-number)
  "Split the current window into `wenshan-number' windows"
  (interactive "P")
  (setq wenshan-number (if wenshan-number
			   (prefix-numeric-value wenshan-number)
			 2))
  (while (> wenshan-number 1)
	(split-window-below)
	(setq wenshan-number (- wenshan-number 1)))
  (set-window-buffer (next-window) (other-buffer))
  (balance-windows))

(defun jj/split-window-right-and-balance (&optional wenshan-number)
  "Split the current window into `wenshan-number' windows"
  (interactive "P")
  (setq wenshan-number (if wenshan-number
			   (prefix-numeric-value wenshan-number)
			 2))
  (while (> wenshan-number 1)
	(split-window-right)
	(setq wenshan-number (- wenshan-number 1)))
  (set-window-buffer (next-window) (other-buffer))
  (balance-windows))

(defun jj/split-window-4-delete-others ()
  "Splite window into 4 sub-window"
  (interactive)
  (if (not (= 1 (length (window-list))))
	  (delete-other-windows))
  (progn (split-window-vertically)
	 (set-window-buffer (next-window) (other-buffer))
	 (split-window-horizontally)
	 (set-window-buffer (next-window) (other-buffer))
	 (other-window 2)
	 (split-window-horizontally)
	 (set-window-buffer (next-window) (other-buffer))
	 (balance-windows)))

(defun jj/split-window-4-here ()
  "Splite window into 4 sub-window"
  (interactive)
  (progn (split-window-vertically)
	 (set-window-buffer (next-window) (other-buffer))
	 (split-window-horizontally)
	 (set-window-buffer (next-window) (other-buffer))
	 (other-window 2)
	 (split-window-horizontally)
	 (set-window-buffer (next-window) (other-buffer))))

(defun change-split-type (split-fn &optional arg)
  "Change 3 window style from horizontal to vertical and vice-versa"
  (let ((bufList (mapcar 'window-buffer (window-list))))
	(select-window (get-largest-window))
	(funcall split-fn arg)
	(mapcar* 'set-window-buffer (window-list) bufList)))

(defun jj/change-window-split-type-2 (&optional arg)
  "Changes splitting from vertical to horizontal and vice-versa"
  (interactive "P")
  (let ((split-type (lambda (&optional arg)
			  (delete-other-windows-internal)
			  (if arg (split-window-vertically)
			(split-window-horizontally)))))
	(change-split-type split-type arg)))

(defun jj/window-split-toggle-horizontal-vertical ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
	  (error "Can't toggle with more than 2 windows!")
	(let ((func (if (window-full-width-p)
			#'split-window-horizontally
		  #'split-window-vertically)))
	  (delete-other-windows)
	  (funcall func)
	  (save-selected-window
	(other-window 1)
	(switch-to-buffer (other-buffer))))))

;;; record two different file's last change. cycle them
(defvar jj/last-change-pos1 nil)
(defvar jj/last-change-pos2 nil)

(defun jj/swap-last-changes ()
  (when jj/last-change-pos2
	(let ((tmp jj/last-change-pos2))
	  (setf jj/last-change-pos2 jj/last-change-pos1
		jj/last-change-pos1 tmp))))

;; TODO: Update to ignore certain buffers (eg. COMMIT-MSG buffers)
(defun jj/goto-last-change-across-buffers ()
  (interactive)
  (when jj/last-change-pos1
	(let* ((buffer (find-file-noselect (car jj/last-change-pos1)))
	   (win (get-buffer-window buffer)))
	  (if win
	  (select-window win)
	(switch-to-buffer-other-window buffer))
	  (goto-char (cdr jj/last-change-pos1))
	  (jj/swap-last-changes))))

(defun jj/insert-brackets (&optional arg)
  "Enclose following ARG sexps in brackets [].
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\[ ?\]))
(defun jj/insert-brackets-alt (&optional arg)
  "Enclose following ARG sexps in brackets {}.
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\{ ?\}))
(defun jj/insert-dollar-sign (&optional arg)
  "Enclose following ARG sexps in dollar signs $$.
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\$ ?\$))
(defun jj/insert-double-dollar-dollar-sign (&optional arg)
  "Enclose following ARG sexps in dollar signs $$$$.
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (save-mark-and-excursion
	(insert-pair arg ?\$ ?\$))
  (let (( parens-require-spaces nil))
	(insert-pair arg ?\$ ?\$))
  (forward-char))
(defun jj/insert-double-quotes (&optional arg)
  "Enclose following ARG sexps in dollar signs \"\".
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\" ?\"))
(defun jj/insert-double-quotes (&optional arg)
  "Enclose following ARG sexps in dollar signs \"\".
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\" ?\"))
(defun jj/insert-single-quotes (&optional arg)
  "Enclose following ARG sexps in dollar signs ''.
Leave point after open-paren.
A negative ARG encloses the preceding ARG sexps instead.
No argument is equivalent to zero: just insert `()' and leave point between.
If `parens-require-spaces' is non-nil, this command also inserts a space
before and after, depending on the surrounding characters.
If region is active, insert enclosing characters at region boundaries.

This command assumes point is not in a string or comment."
  (interactive "P")
  (insert-pair arg ?\' ?\'))

(defun jj/insert-upward-v-exponential ()
  "Insert one ^ into text"
  (interactive) (insert-char '94))

(defvar jj/save-place-last-checksum nil)
(defun jj/save-place-alist-to-file (&optional auto-save)
  (interactive)
  (let ((file (expand-file-name save-place-file))
	(coding-system-for-write 'utf-8))
	(with-current-buffer (get-buffer-create " *Saved Places*")
	  (delete-region (point-min) (point-max))
	  (when save-place-forget-unreadable-files
	(save-place-forget-unreadable-files))
	  (insert (format ";;; -*- coding: %s -*-\n"
			  (symbol-name coding-system-for-write)))
	  (let ((print-length nil)
		(print-level nil))
	(pp save-place-alist (current-buffer)))
	  (let ((version-control
		 (cond
		  ((null save-place-version-control) nil)
		  ((eq 'never save-place-version-control) 'never)
		  ((eq 'nospecial save-place-version-control) version-control)
		  (t
		   t))))
	(condition-case nil
		;; Don't use write-file; we don't want this buffer to visit it.
		;; If autosaving, avoid writing if nothing has changed since the
		;; last write.
		(let ((checksum (md5 (current-buffer) nil nil 'no-conversion)))
		  (unless (and auto-save (equal checksum jj/save-place-last-checksum))
		;; Set file-precious-flag when saving the buffer because we
		;; don't want a half-finished write ruining the entire
		;; history.  Remember that this is run from a timer and from
		;; kill-emacs-hook, and also that multiple Emacs instances
		;; could write to this file at once.
		(let ((file-precious-flag t)
			  (coding-system-for-write 'utf-8))
		  (write-region (point-min) (point-max) file nil
				(unless (called-interactively-p 'interactive) 'quiet)))
		(setq jj/save-place-last-checksum checksum)))
	  (file-error (message "Saving places: can't write %s" file)))
	(kill-buffer (current-buffer))))))

(defvar jj/recentf-last-checksum nil)
(defun jj/recentf-save-list (&optional auto-save)
  "Save the recent list.
Write data into the file specified by `recentf-save-file'."
  (interactive)
  (let ((file (expand-file-name recentf-save-file))
	(coding-system-for-write recentf-save-file-coding-system))
	(with-temp-buffer
	  (erase-buffer)
	  (set-buffer-file-coding-system recentf-save-file-coding-system)
	  (insert (format-message recentf-save-file-header
				  (current-time-string)))
	  (recentf-dump-variable 'recentf-list recentf-max-saved-items)
	  (recentf-dump-variable 'recentf-filter-changer-current)
	  (insert "\n\n;; Local Variables:\n"
		  (format ";; coding: %s\n" recentf-save-file-coding-system)
		  ";; End:\n")
	  (condition-case nil
	  (let ((checksum (md5 (current-buffer) nil nil 'no-conversion)))
		(unless (and auto-save (equal checksum jj/recentf-last-checksum))
		  ;; Set file-precious-flag when saving the buffer because we
		  ;; don't want a half-finished write ruining the entire
		  ;; history.  Remember that this is run from a timer and from
		  ;; kill-emacs-hook, and also that multiple Emacs instances
		  ;; could write to this file at once.
		  (let ((file-precious-flag t)
			(coding-system-for-write recentf-save-file-coding-system))
		(write-region (point-min) (point-max) file nil
				  (unless (called-interactively-p 'interactive) 'quiet))
		(setq jj/recentf-last-checksum checksum)))
		(when recentf-save-file-modes
		  (set-file-modes recentf-save-file recentf-save-file-modes)))
	(file-error (message "Can't write recentf file to: %s" file))
	;; (warn "recentf mode: %s" (error-message-string error))))
	;; (write-file (expand-file-name recentf-save-file))
	))))

(defun jj/save-place-recentf-to-file ()
  (interactive)
  ;; not needed as included in the package
  ;; (savehist-autosave)
  ;; has checksum to see if need to save when passed t into these functions
  (jj/recentf-save-list t)
  ;; use this the function will always auto-save because things added to list everytime
  ;; only new items added when buffers closed normally
  ;; (save-places-to-alist)
  (jj/save-place-alist-to-file t))
(defun jj/save-places-to-alist ()
  (interactive)
  (save-places-to-alist))

(defun jj/buffer-change-hook (beg end len)
  (let ((bfn (buffer-file-name))
	(file (car jj/last-change-pos1)))
	(when bfn
	  (if (or (not file) (equal bfn file)) ;; change the same file
	  (setq jj/last-change-pos1 (cons bfn end))
	(progn (setq jj/last-change-pos2 (cons bfn end))
		   (jj/swap-last-changes))))))

(defun jj/revert-buffers-all ()
  "Iterate through the list of buffers and revert them, e.g. after a
	new branch has been checked out."
  (interactive)
  (when (yes-or-no-p "Are you sure - any changes in open buffers will be lost! ")
	(let ((frm1 (selected-frame)))
	  (make-frame)
	  (let ((frm2 (next-frame frm1)))
	(select-frame frm2)
	(make-frame-invisible)
	(dolist (x (buffer-list))
	  (let ((test-buffer (buffer-name x)))
		(when (not (string-match "\*" test-buffer))
		  (when (not (file-exists-p (buffer-file-name x)))
		(select-frame frm1)
		(when (yes-or-no-p (concat "File no longer exists (" (buffer-name x) "). Close buffer? "))
		  (kill-buffer (buffer-name x)))
		(select-frame frm2))
		  (when (file-exists-p (buffer-file-name x))
		(switch-to-buffer (buffer-name x))
		(revert-buffer t t t)))))
	(select-frame frm1)
	(delete-frame frm2)
	))))

(defun jj/revert-buffer-no-confirm ()
	"Revert buffer without confirmation."
	(interactive) (revert-buffer t t))

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

;; TODO: switch to using ivy so it ignores help windows
(defun jj/switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
;; (defun jj/switch-to-previous-buffer ()
;;   "Switch to previously open buffer.
;; Repeated invocations toggle between the two most recently open buffers."
;;   (interactive)
;;   (if (not (string-match "*Help*" (buffer-name (other-buffer (current-buffer)))))
;;       (switch-to-buffer (other-buffer (current-buffer) 1))
;;     (switch-to-buffer (other-buffer (other-buffer (current-buffer) 1)) )))

(fset 'jj/dired-kill-subdir-pop-mark
	  [?\s-\C-\M-4 ?\s-\[])

(defun jj/kill-buffer-immediately ()
  "Kill the current buffer immediately"
  (interactive)
  (kill-buffer nil))

(defun jj/emacs-lock-mode ()
  "Lock the current buffer from being able to be killed"
  (interactive)
  (if (not emacs-lock-mode)
	  (emacs-lock-mode 'kill)
	(emacs-lock-mode -1)
	))

(defun jj/emacs-lock-mode-kill ()
  "Lock the current buffer from being able to be killed"
  (interactive)
  (emacs-lock-mode 'kill))

(defun jj/emacs-lock-mode-all ()
  "Lock the current buffer from being able to be killed"
  (interactive)
  (emacs-lock-mode 'all))

(defun jj/emacs-lock-mode-no-exit ()
  "Lock the current buffer from being killed and emacs can't exit until it us unprotected"
  (interactive)
  (if (not emacs-lock-mode)
	  (emacs-lock-mode 'all)
	(emacs-lock-mode -1)
	))

(defun jj/emacs-lock-mode-off ()
  "Lock the current buffer from being killed and emacs can't exit until it us unprotected"
  (interactive)
  (emacs-lock-mode -1))

(defun jj/find-open-last-killed-file ()
  (interactive)
  (let ((active-files (loop for buf in (buffer-list)
				when (buffer-file-name buf) collect it)))
	(loop for file in recentf-list
	  unless (member file active-files) return (find-file file))))

(defun jj/find-alternative-file-with-sudo ()
  (interactive)
  (let ((fname (or buffer-file-name
		   dired-directory)))
	(when fname
	  (if (string-match "^/sudo:root@localhost:" fname)
	  (setq fname (replace-regexp-in-string
			   "^/sudo:root@localhost:" ""
			   fname))
	(setq fname (concat "/sudo:root@localhost:" fname)))
	  (find-alternate-file fname))))

(defvar jj/find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `jj/find-file-root'.")

(when (not (fboundp 'jj/find-file-root-history))
  (defvar jj/find-file-root-history nil
	"History list for files found using `jj/find-file-root'."))

(defvar jj/find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

(defun jj/find-file-root ()
  "*Open a file as the root user.
   Prepends `jj/find-file-root-prefix' to the selected file name so that it
   maybe accessed via the corresponding tramp method."

  (interactive)
  (require 'tramp)
  (let* ( ;; We bind the variable `file-name-history' locally so we can
	 ;; use a separate history list for "root" files.
	 (file-name-history jj/find-file-root-history)
	 (name (or buffer-file-name default-directory))
	 (tramp (and (tramp-tramp-file-p name)
			 (tramp-dissect-file-name name)))
	 path dir file)

	;; If called from a "root" file, we need to fix up the path.
	(when tramp
	  (setq path (tramp-file-name-localname tramp)
		dir (file-name-directory path)))

	(when (setq file (read-file-name "Find file (UID = 0): " dir path))
	  (find-file (concat jj/find-file-root-prefix file))
	  ;; If this all succeeded save our new history list.
	  (setq jj/find-file-root-history file-name-history)
	  ;; allow some user customization
	  (run-hooks 'jj/find-file-root-hook))))

(defface jj/find-file-root-header-face
  '((t (:foreground "white" :background "red3")))
  "*Face use to display header-lines for files opened as root.")

(defun jj/find-file-root-header-warning ()
  "*Display a warning in header line of the current buffer.
   This function is suitable to add to `jj/find-file-root-hook'."
  (let* ((warning "WARNING: EDITING FILE AS ROOT!")
	 (space (+ 6 (- (window-width) (length warning))))
	 (bracket (make-string (/ space 2) ?-))
	 (warning (concat bracket warning bracket)))
	(setq header-line-format
	  (propertize  warning 'face 'jj/find-file-root-header-face))))

(defun jj/find-file-hook-root-header-warning ()
  (when (and buffer-file-name (string-match "root@localhost" buffer-file-name))
	(jj/find-file-root-header-warning)))

;; open recent directory, requires ivy (part of swiper)
;; borrows from http://stackoverflow.com/questions/23328037/in-emacs-how-to-maintain-a-list-of-recent-directories
(defun jj/ivy-dired-recent-dirs ()
  "Present a list of recently used directories and open the selected one in dired"
  (interactive)
  (let ((recent-dirs
	 (delete-dups
	  (mapcar (lambda (file)
			(if (file-directory-p file) file (file-name-directory file)))
		  recentf-list))))

	(let ((dir (ivy-read "Directory: "
			 recent-dirs
			 :re-builder #'ivy--regex
			 :sort nil
			 :initial-input nil)))
	  (dired dir))))

(defun create-new-file (file-list)
  (defun exsitp-untitled-x (file-list cnt)
	(while (and (car file-list) (not (string= (car file-list) (concat "untitled~~" (number-to-string cnt) ".qqq"))))
	  (setq file-list (cdr file-list)))
	(car file-list))

  (defun exsitp-untitled (file-list)
	(while (and (car file-list) (not (string= (car file-list) "untitled~~.qqq")))
	  (setq file-list (cdr file-list)))
	(car file-list))

  (if (not (exsitp-untitled file-list))
	  "untitled~~.qqq"
	(let ((cnt 2))
	  (while (exsitp-untitled-x file-list cnt)
	(setq cnt (1+ cnt)))
	  (concat "untitled~~" (number-to-string cnt) ".qqq")
	  )
	)
  )
(defun jj/dired-create-file (file)
  (interactive
   (list (read-file-name "Create file: " (concat (dired-current-directory) (create-new-file (directory-files (dired-current-directory))))))
   )
  (write-region "" nil (expand-file-name file) t)
  (dired-add-file file)
  (revert-buffer)
  (dired-goto-file (expand-file-name file))
  )

(defun jj/ivy-kill-buffer (buf)
  (interactive)
  (if (get-buffer buf)
	  (kill-buffer buf)
	(setq recentf-list (delete (cdr (assoc buf ivy--virtual-buffers)) recentf-list))))

(defun jj/delete-other-windows-or-winner-undo-max-pane ()
  (interactive)
  (cond ((one-window-p)
	 (winner-undo))
	((string-equal last-command "winner-undo")
	 (winner-undo))
	((string-equal last-command "jj/delete-other-windows-or-winner-undo-max-pane")
	 (winner-undo))
	(t (delete-other-windows))
	))

(defun jj/dired-go-up-directory-same-buffer ()
  (interactive)
  (find-alternate-file ".."))

;; Same as `dired-up-directory', except for wrapping with `file-truename'.
(defun jj/dired-up-directory-follow-symlink-up (&optional other-window)
  "Run Dired on parent directory of current directory.
Follows symlinks for current directory.
Find the parent directory either in this buffer or another buffer.
Creates a buffer if necessary.
If OTHER-WINDOW (the optional prefix arg), display the parent
directory in another window."
  (interactive "P")
  (let* ((dir  (file-truename (dired-current-directory)))
	 (up   (file-name-directory (directory-file-name dir))))
	(or (dired-goto-file (directory-file-name dir))
	;; Only try dired-goto-subdir if buffer has more than one dir.
	(and (cdr dired-subdir-alist)  (dired-goto-subdir up))
	(progn (if other-window (dired-other-window up) (dired up))
		   (dired-goto-file dir)))))

(defun jj/dired-find-file-following-symlinks ()
  "In Dired, visit the file or directory on the line, following symlinks"
  (interactive)
  (let ((find-file-visit-truename t))
	(dired-find-file)))

(defun jj/dired-find-alternate-file-following-symlinks ()
  "In Dired, visit the file or directory on the line, following symlinks"
  (interactive)
  (let ((find-file-visit-truename t))
	(dired-find-alternate-file)))

(defun jj/dired-advertised-find-file-following-symlinks ()
  "In Dired, visit the file or directory on the line, following symlinks"
  (interactive)
  (let ((find-file-visit-truename t))
	(dired-advertised-find-file)))

(defun jj/dired-view-file-following-symlinks ()
  "In Dired, visit the file or directory on the line, following symlinks"
  (interactive)
  (let ((find-file-visit-truename t))
	(dired-view-file)))

;; setup a varibale to remember omit mode across buffers
(defvar v-dired-omit t
	 "If dired-omit-mode enabled by default. Don't setq me.")
(defun dired-omit-switch ()
	 "This function is a small enhancement for `dired-omit-mode', which will
   \"remember\" omit state across Dired buffers."
	 (interactive)
	 (if (eq v-dired-omit t)
	 (setq v-dired-omit nil)
	   (setq v-dired-omit t))
	 (dired-omit-caller)
	 (revert-buffer))

(defun jj/dired-do-shell-unmount-device ()
	(interactive)
	(save-window-excursion
	  (dired-do-async-shell-command
	   "diskutil unmount" current-prefix-arg
	   (dired-get-marked-files t current-prefix-arg))))

(defun dired-omit-caller ()
	 (if v-dired-omit
	 (setq dired-omit-mode t)
	   (setq dired-omit-mode nil)))

(defcustom dired-list-of-switches
  '("-a -F -lGhHAv  --group-directories-first"  "-a -F -lGhHAv -L  --group-directories-first" "-a -F -lGhHA  --group-directories-first")
  "List of ls switches for dired to cycle among.")

(defun jj/dired-cycle-switches ()
  "Cycle through the list `dired-list-of-switches' of switches for ls"
  (interactive)
  (setq dired-list-of-switches
	(append (cdr dired-list-of-switches)
		(list (car dired-list-of-switches))))
  (dired-sort-other (car dired-list-of-switches))
  (dired-sort-set-mode-line))

(defun jj/dired-sort-by-time-switch-toggle ()
  "Sort by time not putting directories first"
  (interactive)
  (cond ((string= dired-actual-switches "-a -F -lGhHAv -t")
	 (dired-sort-other "-a -F -lGhHAv  --group-directories-first"))
	((string= dired-actual-switches "-a -F -lGhHA -v")
	 (dired-sort-other "-a -F -lGhHAv  --group-directories-first"))
	(t
	 (dired-sort-other "-a -F -lGhHAv -t")))
  (dired-sort-set-mode-line))

(defun jj/remove-elc-on-save ()
  "If you're saving an Emacs Lisp file, likely the .elc is no longer valid."
  (add-hook 'after-save-hook
		(lambda ()
		  (if (file-exists-p (concat buffer-file-name "c"))
		  (delete-file (concat buffer-file-name "c"))))
		nil
		t))

(defun jj/brc-functions-file ()
  "Recompile the functions file to hook on exit emacs if updated"
  (interactive)
  (if (eq system-type 'darwin)
	  (progn
	(byte-recompile-file (expand-file-name "~/Dropbox/Programs/emacs/user/functions.el") nil 0)
	(byte-recompile-file (expand-file-name "~/Dropbox/Programs/emacs/user/settings.el") nil 0))))

(defun jj/ivy-switch-buffer-use-virtual ()
  (interactive)
  (let ((ivy-use-virtual-buffers t))
	(ivy-switch-buffer)))

(defun jj/move-file-here ()
  "Move file from somewhere else to here.
The file is taken from a start directory set by `jj/move-file-here-start-dir' and moved to the current directory if invoked in dired, or else the directory containing current buffer. The user is presented with a list of files in the start directory, from which to select the file to move, sorted by most recent first."
  (interactive)
  (let (file-list target-dir file-list-sorted start-file start-file-full)
	;; clean directories from list but keep times
	(setq file-list
	  (-remove (lambda (x) (nth 1 x))
		   (directory-files-and-attributes jj/move-file-here-start-dir)))

	;; get target directory
	;; http://ergoemacs.org/emacs/emacs_copy_file_path.html
	(setq target-dir
	  (if (equal major-mode 'dired-mode)
		  (expand-file-name default-directory)
		(if (null (buffer-file-name))
		(user-error "ERROR: current buffer is not associated with a file.")
		  (file-name-directory (buffer-file-name)))))

	;; sort list by most recent
	;;http://stackoverflow.com/questions/26514437/emacs-sort-list-of-directories-files-by-modification-date
	(setq file-list-sorted
	  (mapcar #'car
		  (sort file-list
			#'(lambda (x y) (time-less-p (nth 6 y) (nth 6 x))))))

	;; use ivy to select start-file
	(setq start-file (ivy-read
			  (concat "Move selected file to " target-dir ":")
			  file-list-sorted
			  :re-builder #'ivy--regex
			  :sort nil
			  :initial-input nil))

	;; add full path to start file and end-file
	(setq start-file-full
	  (expand-file-name start-file jj/move-file-here-start-dir))
	(setq end-file
	  (expand-file-name (file-name-nondirectory start-file) target-dir))
	(rename-file start-file-full end-file)
	(kill-new start-file)
	(gui-set-selection 'PRIMARY start-file)
	(message "moved %s to %s" start-file-full end-file)))

(defun jj/find-next-file-in-current-directory (&optional backward)
  "Find the next file (by name) in the current directory.

With prefix arg, find the previous file."
  (interactive "P")
  (when buffer-file-name
	(let* ((file (expand-file-name buffer-file-name))
	   (files (cl-remove-if (lambda (file) (cl-first (file-attributes file)))
				(sort (directory-files (file-name-directory file) t nil t) 'string<)))
	   (pos (mod (+ (cl-position file files :test 'equal) (if backward -1 1))
			 (length files))))
	  (find-file (nth pos files)))))

(defun jj/open-iterm-terminal-here ()
  (interactive)
  (dired-smart-shell-command "open -a iTerm $PWD" nil nil))
(defun jj/open-in-terminal ()
  "Open the current dir in a new terminal window.
URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2017-10-09"
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
	(message "Microsoft Windows not supported. File a bug report or pull request."))
   ((string-equal system-type "darwin")
	(let ((process-connection-type nil))
	  (start-process "" nil "/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal" default-directory)))
   ((string-equal system-type "gnu/linux")
	(let ((process-connection-type nil))
	  (start-process "" nil "x-terminal-emulator"
			 (concat "--working-directory=" default-directory))))))

(defun jj/show-in-path-finder ()
  "Show current file in desktop.
 (Mac Finder, Windows Explorer, Linux file manager)
 This command can be called when in a file or in `dired'.

URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2018-09-29"
  (interactive)
  (let (($path (if (buffer-file-name) (buffer-file-name) default-directory )))
	(cond
	 ((string-equal system-type "windows-nt")
	  (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" $path t t)))
	 ((string-equal system-type "darwin")
	  (if (eq major-mode 'dired-mode)
	  (let (($files (dired-get-marked-files )))
		(if (eq (length $files) 0)
		(progn
		  (shell-command
		   (concat "open " default-directory)))
		  (progn
		(shell-command
		 (concat "open -R " (shell-quote-argument (car (dired-get-marked-files ))))))))
	(shell-command
	 (concat "open -R " $path))))
	 ((string-equal system-type "gnu/linux")
	  (let (
		(process-connection-type nil)
		(openFileProgram (if (file-exists-p "/usr/bin/gvfs-open")
				 "/usr/bin/gvfs-open"
				   "/usr/bin/xdg-open")))
	(start-process "" nil openFileProgram $path))
	  ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. eg with nautilus
	  ))))

(defun jj/show-in-finder-for-dropbox ()
  "Show current file in desktop.
 (Mac Finder, Windows Explorer, Linux file manager)
 This command can be called when in a file or in `dired'.

URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2018-09-29"
  (interactive)
  (let (($path (if (buffer-file-name) (buffer-file-name) default-directory )))
	(cond
	 ((string-equal system-type "darwin")
	  (if (eq major-mode 'dired-mode)
	  (let (($files (dired-get-marked-files nil t nil nil)))
		(if (eq (length $files) 0)
		(progn
		  (shell-command
		   (concat "open -a Finder " default-directory)))
		  (let* ((x (car $files))
			 (dired-rename-file-split (f-split x))
			 (just-directory (apply 'f-join (nbutlast dired-rename-file-split))))
		(progn
		  (shell-command
		   (concat "open -a Finder " just-directory))))))
	(shell-command
	 (concat "open -a Finder " default-directory)))))))

(defun jj/toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
	 (set-window-dedicated-p window (not (window-dedicated-p window))))
	   "%s: Can't touch this!"
	 "%s is up for grabs.")
   (current-buffer)))

;; ;; Stick/Lock buffer to window
;; (defvar sticky-buffer-previous-header-line-format)
;; (define-minor-mode sticky-buffer-mode
;;   "Make the current window always display this buffer."
;;   nil " sticky" nil
;;   (if sticky-buffer-mode
;;       (progn
;;         (set (make-local-variable 'sticky-buffer-previous-header-line-format)
;;              header-line-format)
;;         (set-window-dedicated-p (selected-window) sticky-buffer-mode))
;;     (set-window-dedicated-p (selected-window) sticky-buffer-mode)
;;     (setq header-line-format sticky-buffer-previous-header-line-format)))

;; kill-line and its subroutines.

(defcustom jj/delete-whole-line nil
  "If non-nil, `delete-line' with no arg at start of line kills the whole line."
  :type 'boolean
  :group 'killing)

(defun jj/delete-line (&optional arg)
  "Delete the rest of the current line; if no nonblanks there, delete thru newline.
With prefix argument ARG, delete that many lines from point.
Negative arguments delete lines backward.
With zero argument, deletes the text before point on the current line.

When calling from a program, nil means \"no arg\",
a number counts as a prefix arg.

To delete a whole line, when point is not at the beginning, type \
\\[move-beginning-of-line] \\[delete-line] \\[delete-line].

If `show-trailing-whitespace' is non-nil, this command will just
delete the rest of the current line, even if there are no nonblanks
there.

If option `delete-whole-line' is non-nil, then this command deletes the whole line
including its terminating newline, when used at the beginning of a line
with no argument.  As a consequence, you can always delete a whole line
by typing \\[move-beginning-of-line] \\[delete-line].

If you want to append the deleteed line to the last deleteed text,
use \\[append-next-delete] before \\[delete-line].

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the delete ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `delete-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive "P")
  (delete-region (point)
		   ;; It is better to move point to the other end of the delete
		   ;; before deleteing.  That way, in a read-only buffer, point
		   ;; moves across the text that is copied to the delete ring.
		   ;; The choice has no effect on undo now that undo records
		   ;; the value of point from before the command was run.
		   (progn
		 (if arg
			 (forward-visible-line (prefix-numeric-value arg))
		   (if (eobp)
			   (signal 'end-of-buffer nil))
		   (let ((end
			  (save-excursion
				(end-of-visible-line) (point))))
			 (if (or (save-excursion
				   ;; If trailing whitespace is visible,
				   ;; don't treat it as nothing.
				   (unless show-trailing-whitespace
				 (skip-chars-forward " \t" end))
				   (= (point) end))
				 (and jj/delete-whole-line (bolp)))
			 (forward-visible-line 1)
			   (goto-char end))))
		 (point))))

(defun jj/delete-whole-line (&optional arg)
  "Delete current line.
With prefix ARG, kill that many lines starting from the current line.
If ARG is negative, kill backward.  Also kill the preceding newline.
\(This is meant to make \\[repeat] work well with negative arguments.)
If ARG is zero, delete current line but exclude the trailing newline."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
	  (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
	  (signal 'beginning-of-buffer nil))
  ;; (unless (eq last-command 'delete-region)
  ;;   (delete-new "")
  ;;   (setq last-command 'delete-region))
  (cond ((zerop arg)
	 ;; We need to delete in two steps, because the previous command
	 ;; could have been a delete command, in which case the text
	 ;; before point needs to be prepended to the current delete
	 ;; ring entry and the text after point appended.  Also, we
	 ;; need to use save-excursion to avoid copying the same text
	 ;; twice to the delete ring in read-only buffers.
	 (save-excursion
	   (delete-region (point) (progn (forward-visible-line 0) (point))))
	 (delete-region (point) (progn (end-of-visible-line) (point))))
	((< arg 0)
	 (save-excursion
	   (delete-region (point) (progn (end-of-visible-line) (point))))
	 (delete-region (point)
			  (progn (forward-visible-line (1+ arg))
				 (unless (bobp) (backward-char))
				 (point))))
	(t
	 (save-excursion
	   (delete-region (point) (progn (forward-visible-line 0) (point))))
	 (delete-region (point)
			  (progn (forward-visible-line arg) (point))))))

(defun jj/visual-fill-column-center-text-toggle ()
  (interactive)
  (if (not (symbol-value visual-fill-column-center-text))
	  (progn
	(setq visual-fill-column-center-text t)
	(redraw-frame)
	(redisplay t)
	)
	(progn
	  (setq visual-fill-column-center-text nil)
	  (redraw-frame)
	  (redisplay t)
	  )))

(defun jj/save-new-file-before-kill ()
  (when (and (not (buffer-file-name))
		 is-new-file-buffer
		 (yes-or-no-p
		  "New file has not been saved. Would you like to save before closing?"))
	(call-interactively 'save-buffer)))

(defun jj/new-file (dir)
  (interactive "DCreate New File In: ")
  (let ((buffer (generate-new-buffer "<Unsaved File>")))
	(switch-to-buffer buffer)
	(setq-local default-directory dir)
	(setq-local is-new-file-buffer t)))

(defun jj/increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
	(save-match-data
	  (let (inc-by field-width answer)
	(setq inc-by (if arg arg 1))
	(skip-chars-backward "0123456789")
	(when (re-search-forward "[0-9]+" nil t)
	  (setq field-width (- (match-end 0) (match-beginning 0)))
	  (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
	  (when (< answer 0)
		(setq answer (+ (expt 10 field-width) answer)))
	  (replace-match (format (concat "%0" (int-to-string field-width) "d")
				 answer)))))))

(defun jj/delete-kill-process-at-point ()
  (interactive)
  (let ((process (get-text-property (point) 'tabulated-list-id)))
	(cond ((and process
		(processp process))
	   (delete-process process)
	   (revert-buffer))
	  (t
	   (error "no process at point!")))))

(defun jj/decrement-number-decimal (&optional arg)
  (interactive "p*")
  (jj/increment-number-decimal (if arg (- arg) -1)))

(defun jj/set-tab-stop-width (width)
  "Set all tab stops to WIDTH in current buffer.

	This updates `tab-stop-list', but not `tab-width'.

	By default, `indent-for-tab-command' uses tabs to indent, see
	`indent-tabs-mode'."
  (interactive "nTab width: ")
  (let* ((max-col (car (last tab-stop-list)))
	 ;; If width is not a factor of max-col,
	 ;; then max-col could be reduced with each call.
	 (n-tab-stops (/ max-col width)))
	(set (make-local-variable 'tab-stop-list)
	 (mapcar (lambda (x) (* width x))
		 (number-sequence 1 n-tab-stops)))
	;; So preserve max-col, by adding to end.
	(unless (zerop (% max-col width))
	  (setcdr (last tab-stop-list)
		  (list max-col)))))

(defun jj/dired-rename-space-to-hyphen ()
  "In dired, rename current or marked files by replacing space to hyphen -.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match " " just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string " " "-" just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-space-to-underscore ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match " " just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string " " "_" just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-underscore-to-hyphen ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match "_" just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string "_" "-" just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-hyphen-to-underscore ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match "-" just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string "-" "_" just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-hyphen-or-underscore-to-space ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match "[\-|_]" just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string "[\-|_]" " " just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-hyphen-to-space ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match "-" just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string "-" " " just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/dired-rename-underscore-to-space ()
  "In dired, rename current or marked files by replacing space to underscore _.
If not in `dired', do nothing.
URL `http://ergoemacs.org/emacs/elisp_dired_rename_space_to_underscore.html'
Version 2016-12-22"
  (interactive)
  (if (equal major-mode 'dired-mode)
	  (progn
	(let ((string-not-matched t)
		  (new-names '())
		  (p (point))
		  (number-marked-files (length (dired-get-marked-files nil nil nil t))))
	  (mapc (lambda (x)
		  (let* ((dired-rename-file-split (f-split x))
			 (just-file-name (car (last dired-rename-file-split))))
			(when (string-match "_" just-file-name)
			  ;; replace last element in file-name-split with the replaced regex
			  (setcar (last dired-rename-file-split) (replace-regexp-in-string "_" " " just-file-name))
			  ;; rejoin the file-name-split with / and the new file name
			  (dired-rename-file x (apply 'f-join dired-rename-file-split)  nil)
			  (push (apply 'f-join dired-rename-file-split) new-names)
			  ;; if filename matched won't go forward line as already does this
			  (setq string-not-matched nil))))
		(dired-get-marked-files))
	  (revert-buffer)
	  (when (not (eql 1 number-marked-files))
		(loop for f in new-names do
		  (dired-goto-file f)
		  (dired-mark nil)))
	  ;; move forward one line if dired didn't do rename (this is done automatically if rename was performed)
	  ;; only do the below when length of marked files is 1 or doesn't make sense to move forward by lines
	  (goto-char p)
	  (when (eql 1  number-marked-files)
		(dired-next-line 1))))
	(user-error "Not in dired")))

(defun jj/hyphen-underscore-space-cycle-region-sexp-or-line ( &optional @begin @end )
  "Cycle {underscore, space, hypen} chars in selection or inside quote/bracket or line.
When called repeatedly, this command cycles the {“_”, “-”, “ ”} characters, in that order.

The region to work on is by this order:
 ① if there's active region (text selection), use that.
 ② If cursor is string quote or any type of bracket, and is within current line, work on that region.
 ③ else, work on current line.

URL `http://ergoemacs.org/emacs/elisp_change_space-hyphen_underscore.html'
Version 2017-01-27"
  (interactive)
  ;; this function sets a property 「'state」. Possible values are 0 to length of -charArray.
  (let ($p1 $p2)
	(if (and @begin @end)
	(progn (setq $p1 @begin $p2 @end))
	  (if (use-region-p)
	  (setq $p1 (region-beginning) $p2 (region-end))
	(if (nth 3 (syntax-ppss))
		(save-excursion
		  (skip-chars-backward "^\"")
		  (setq $p1 (point))
		  (skip-chars-forward "^\"")
		  (setq $p2 (point)))
	  (let (
		($skipChars
		 (if (boundp 'xah-brackets)
			 (concat "^\"" xah-brackets)
		   "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）")))
		(skip-chars-backward $skipChars (line-beginning-position))
		(setq $p1 (point))
		(skip-chars-forward $skipChars (line-end-position))
		(setq $p2 (point))
		(set-mark $p1)))))
	(let* (
	   ($charArray ["_" "-" " "])
	   ($length (length $charArray))
	   ($regionWasActive-p (region-active-p))
	   ($nowState
		(if (equal last-command this-command )
		(get 'jj/hyphen-underscore-space-cycle-region-sexp-or-line 'state)
		  0 ))
	   ($changeTo (elt $charArray $nowState)))
	  (save-excursion
	(save-restriction
	  (narrow-to-region $p1 $p2)
	  (goto-char (point-min))
	  (while
		  (re-search-forward
		   (elt $charArray (% (+ $nowState 2) $length))
		   ;; (concat
		   ;;  (elt -charArray (% (+ -nowState 1) -length))
		   ;;  "\\|"
		   ;;  (elt -charArray (% (+ -nowState 2) -length)))
		   (point-max)
		   "NOERROR")
		(replace-match $changeTo "FIXEDCASE" "LITERAL"))))
	  (when (or (string= $changeTo " ") $regionWasActive-p)
	(goto-char $p2)
	(set-mark $p1)
	(setq deactivate-mark nil))
	  (put 'jj/hyphen-underscore-space-cycle-region-sexp-or-line 'state (% (+ $nowState 1) $length)))))

(defun jj/space-to-underscore-region (@begin @end)
  "Change underscore char to space.
URL `http://ergoemacs.org/emacs/elisp_change_space-hyphen_underscore.html'
Version 2017-01-11"
  (interactive "r")
  (save-excursion
	(save-restriction
	  (narrow-to-region @begin @end)
	  (goto-char (point-min))
	  (while
	  (re-search-forward " " (point-max) "NOERROR")
	(replace-match "_" "FIXEDCASE" "LITERAL")))))

(defun jj/space-to-no-space-region (@begin @end)
  "Change underscore char to space.
URL `http://ergoemacs.org/emacs/elisp_change_space-hyphen_underscore.html'
Version 2017-01-11"
  (interactive "r")
  (save-excursion
	(save-restriction
	  (narrow-to-region @begin @end)
	  (goto-char (point-min))
	  (while
	  (re-search-forward " " (point-max) "NOERROR")
	(replace-match "" "FIXEDCASE" "LITERAL")))))

(defun jj/xah-clean-whitespace ()
  "Delete trailing whitespace, and replace repeated blank lines to just 1.
Only space and tab is considered whitespace here.
Works on whole buffer or text selection, respects `narrow-to-region'.

URL `http://ergoemacs.org/emacs/elisp_compact_empty_lines.html'
Version 2017-09-22"
  (interactive)
  (let ($begin $end)
	(if (region-active-p)
	(setq $begin (region-beginning) $end (region-end))
	  (setq $begin (point-min) $end (point-max)))
	(save-excursion
	  (save-restriction
	(narrow-to-region $begin $end)
	(progn
	  (goto-char (point-min))
	  (while (re-search-forward "[ \t]+\n" nil "move")
		(replace-match "\n")))
	(progn
	  (goto-char (point-min))
	  (while (re-search-forward "\n\n\n+" nil "move")
		(replace-match "\n\n")))
	(progn
	  (goto-char (point-max))
	  (while (equal (char-before) 32) ; char 32 is space
		(delete-char -1))))
	  (message "white space cleaned"))))

(defun jj/TeX-command-run-all-auto-save (arg)
  "Runs TeX-command-run-all but saving first if modified."
  (interactive "P")
  (let ((TeX-save-query nil))
	(TeX-command-run-all arg)))

(defun jj/TeX-LaTeX-auctex-latexmk-compile-view ()
  "Compile, view *.pdf, and clean (maybe)."
  (interactive)
  (let ((TeX-PDF-mode t)
	(TeX-source-correlate-mode t)
	(TeX-source-correlate-method 'synctex)
	(TeX-source-correlate-start-server nil))
	(when (buffer-modified-p)
	  (save-buffer))
	(set-process-sentinel
	 (TeX-command "latexmk" 'TeX-master-file)
	 (lambda (p e)
	   (when (not (= 0 (process-exit-status p)))
	 (TeX-next-error t) )
	   (when (= 0 (process-exit-status p))
	 (TeX-command "View" 'TeX-active-master 0))))
	))

(defun jj/TeX-LaTeX-auctex-xelatexmk-compile-view ()
  "Compile, view *.pdf, and clean (maybe)."
  (interactive)
  (let ((TeX-PDF-mode t)
	(TeX-source-correlate-mode t)
	(TeX-source-correlate-method 'synctex)
	(TeX-source-correlate-start-server nil))
	(when (buffer-modified-p)
	  (save-buffer))
	(set-process-sentinel
	 (TeX-command "Xelatexmk" 'TeX-master-file)
	 (lambda (p e)
	   (when (not (= 0 (process-exit-status p)))
	 (TeX-next-error t) )
	   (when (= 0 (process-exit-status p))
	 (TeX-command "View" 'TeX-active-master 0))))
	))

(defun jj/TeX-LaTeX-auctex-lualatex-compile-view ()
  "Compile and view *.pdf for lualatex files"
  (interactive)
  (let ((TeX-PDF-mode t)
	(TeX-source-correlate-mode t)
	(TeX-source-correlate-method 'synctex)
	(TeX-source-correlate-start-server nil))
	(when (buffer-modified-p)
	  (save-buffer))
	(set-process-sentinel
	 (TeX-command "Lualatexmk" 'TeX-master-file)
	 (lambda (p e)
	   (when (not (= 0 (process-exit-status p)))
	 (TeX-next-error t) )
	   (when (= 0 (process-exit-status p))
	 (TeX-command "View" 'TeX-active-master 0))))
	))

;; TODO: Get Latex running correctly because sometimes gets passed in resume.pdf.pdf instead of resume.pdf
;; I think can maybe fix by calling view a second time or figure out where the error is occurring in auctex
(defun jj/TeX-LaTeX-auctex-latexmk-compile-view-twice ()
  (interactive)
  (jj/TeX-LaTeX-auctex-latexmk-compile-view)
  (let ((TeX-PDF-mode t)
	(TeX-source-correlate-mode t)
	(TeX-source-correlate-method 'synctex)
	(TeX-source-correlate-start-server nil))
	(TeX-command "View" 'TeX-active-master 0)
	))

(defun jj/TeX-LaTeX-auctex-regular-compile-view-clean ()
  "Compile, view *.pdf, and clean (maybe)."
  (interactive)
  (let ((TeX-PDF-mode t)
	(TeX-source-correlate-mode t)
	(TeX-source-correlate-method 'synctex)
	(TeX-source-correlate-start-server nil)
	(TeX-clean-confirm nil)
	;; TODO: These don't work for some reason and are overridden by the defaults
	(TeX-clean-default-intermediate-suffixes
	 '("\\.aux" "\\.bbl" "\\.blg" "\\.brf" "\\.fot" "\\.glo" "\\.gls"
	   "\\.idx" "\\.ilg" "\\.ind" "\\.lof" "\\.log" "\\.lot" "\\.nav"
	   "\\.out" "\\.snm" "\\.toc" "\\.url" "\\.bcf"
	   "\\.run\\.xml" "\\.fls" "-blx\\.bib" "\\.fdb.latexmk"))
	(LaTeX-clean-intermediate-suffixes
	 '("\\.aux" "\\.bbl" "\\.blg" "\\.brf" "\\.fot" "\\.glo" "\\.gls"
	   "\\.idx" "\\.ilg" "\\.ind" "\\.lof" "\\.log" "\\.lot" "\\.nav"
	   "\\.out" "\\.snm" "\\.toc" "\\.url" "\\.bcf"
	   "\\.run\\.xml" "\\.fls" "-blx\\.bib" "\\.acn" "\\.acr" "\\.alg"
	   "\\.glg" "\\.ist" "\\.fdb.latexmk")))
	(when (buffer-modified-p)
	  (save-buffer))
	(set-process-sentinel
	 (TeX-command "LaTeX" 'TeX-master-file)
	 (lambda (p e)
	   (when (not (= 0 (process-exit-status p)))
	 (TeX-next-error t) )
	   (when (= 0 (process-exit-status p))
	 (TeX-command "View" 'TeX-active-master 0)
	 ;; `set-process-sentinel` cannot be used on Windows XP for post-view cleanup,
	 ;; because Emacs treats SumatraPDF as an active process until SumatraPDF exits.
	 (let ((major-mode 'latex-mode))
	   (with-current-buffer TeX-command-buffer
		 (TeX-command "Clean" 'TeX-master-file))))))))

;;; --------------------------------------------------- adding words to flyspell
;; If ispell-personal-dictionary variable not set this won't work correctly
(defun jj/ispell-append-word (new-word)
  (let ((header "hunspell_personal_dic: Total word count is ")
	(file-name (symbol-value 'ispell-personal-dictionary))
	(read-words (lambda (file-name)
			  (let ((all-lines (with-temp-buffer
					 (insert-file-contents file-name)
					 (split-string (buffer-string) "\n" t))))
			(if (null all-lines)
				""
			  (split-string (mapconcat 'identity (cdr all-lines) "\n")
					nil
					t))))))
	(cond ((equal ispell-program-name (executable-find "aspell"))
	   (setq header "personal_ws-1.1 en ")))
	(when (file-readable-p file-name)
	  (let* ((cur-words (eval (list read-words file-name)))
		 (all-words (delq header (cons new-word cur-words)))
		 (words (delq nil (remove-duplicates all-words :test 'string=))))
	(with-temp-file file-name
	  (insert (concat header
			  (number-to-string (length words))
			  "\n"
			  (mapconcat 'identity (sort words #'string<) "\n") "\n")))))
	(unless (file-readable-p file-name)
	  (with-temp-file file-name
	(insert (concat header " en 1\n" new-word "\n")))))
  ;; wrapped to supress starting hunspell message can also use with-suppressed-message
  (let ((inhibit-message t)) (ispell-kill-ispell))
  (flyspell-mode)
  (flyspell-mode))

(defun jj/ispell-append-current-and-sort ()
  "Add current word to ispell personal dictionary"
  (interactive)
  (jj/ispell-append-word (thing-at-point 'word)))

;; Bothe followin gdo the same thing in different ways
;; In emacs25+ can just wrap with   (let ((inhibit-message t)) (function))
(defmacro no-message (&rest body)
  "Eval BODY, with `message' doing nothing."
  `(cl-letf (((symbol-function 'message)
		  (lambda (&rest args)
		nil)))
	 (progn ,@body)))

(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (let ((message-log-max nil))
	`(with-temp-message (or (current-message) "") ,@body)))

(defun jj/counsel-imenu-comments ()
  "Imenu display comments."
  (interactive)
  (let* ((imenu-create-index-function 'evilnc-imenu-create-index-function))
	(counsel-imenu)))

(defun jj/infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
	(tab-count (how-many "^\t" (point-min) (point-max))))
	(if (> space-count tab-count) (setq indent-tabs-mode nil))
	(if (> tab-count space-count) (setq indent-tabs-mode t))))

(defvar jj/ratio-dict
  '((1 . 1.61803398875)
	(2 . 2)
	(3 . 3)
	(4 . 4)
	(5 . 0.61803398875))
  "The ratio dictionary.")

(defun jj/split-window-horizontally (&optional ratio)
  "Split window horizontally and resize the new window.
Always focus bigger window."
  (interactive "P")
  (let* (ratio-val)
	(cond
	 (ratio
	  (setq ratio-val (cdr (assoc ratio jj/ratio-dict)))
	  (split-window-horizontally (floor (/ (window-body-width)
					   (1+ ratio-val)))))
	 (t
	  (split-window-horizontally)))
	(set-window-buffer (next-window) (other-buffer))
	(if (or (not ratio-val)
		(>= ratio-val 1))
	(windmove-right))))

(defun jj/split-window-vertically (&optional ratio)
  "Split window vertically and resize the new window.
Always focus bigger window."
  (interactive "P")
  (let* (ratio-val)
	(cond
	 (ratio
	  (setq ratio-val (cdr (assoc ratio jj/ratio-dict)))
	  (split-window-vertically (floor (/ (window-body-height)
					 (1+ ratio-val)))))
	 (t
	  (split-window-vertically)))
	;; open another window with other-buffer
	(set-window-buffer (next-window) (other-buffer))
	;; move focus if new window bigger than current one
	(if (or (not ratio-val)
		(>= ratio-val 1))
	(windmove-down))))

(defun jj/eyebrowse-close-window-config-switch-to-2 ()
  (interactive)
  (eyebrowse-close-window-config)
  ;; TODO: Modify to switch to last-window-config instead of always to #2
  (eyebrowse-switch-to-window-config-2))

(defun eyebrowse-switch-to-window-config-11 ()
  "Switch to window configuration 11."
  (interactive)
  (eyebrowse-switch-to-window-config 11))
(defun eyebrowse-switch-to-window-config-12 ()
  "Switch to window configuration 12."
  (interactive)
  (eyebrowse-switch-to-window-config 12))
(defun eyebrowse-switch-to-window-config-13 ()
  "Switch to window configuration 13."
  (interactive)
  (eyebrowse-switch-to-window-config 13))
(defun eyebrowse-switch-to-window-config-14 ()
  "Switch to window configuration 14."
  (interactive)
  (eyebrowse-switch-to-window-config 14))
(defun eyebrowse-switch-to-window-config-15 ()
  "Switch to window configuration 15."
  (interactive)
  (eyebrowse-switch-to-window-config 15))
(defun eyebrowse-switch-to-window-config-16 ()
  "Switch to window configuration 16."
  (interactive)
  (eyebrowse-switch-to-window-config 16))
(defun eyebrowse-switch-to-window-config-17 ()
  "Switch to window configuration 17."
  (interactive)
  (eyebrowse-switch-to-window-config 17))
(defun eyebrowse-switch-to-window-config-18 ()
  "Switch to window configuration 18."
  (interactive)
  (eyebrowse-switch-to-window-config 18))
(defun eyebrowse-switch-to-window-config-19 ()
  "Switch to window configuration 19."
  (interactive)
  (eyebrowse-switch-to-window-config 19))
(defun eyebrowse-switch-to-window-config-20 ()
  "Switch to window configuration 20."
  (interactive)
  (eyebrowse-switch-to-window-config 20))
(defun eyebrowse-switch-to-window-config-21 ()
  "Switch to window configuration 21."
  (interactive)
  (eyebrowse-switch-to-window-config 21))
(defun eyebrowse-switch-to-window-config-22 ()
  "Switch to window configuration 22."
  (interactive)
  (eyebrowse-switch-to-window-config 22))
(defun test-blinking ()
  (interactive)
  (beacon-blink))
;; Forces so will always open in background if set
(defun jj/osx-browse-url (url &optional new-window browser focus)
  "Open URL in an external browser on OS X.

When called interactively, `browse-url-dwim-get-url' is used
to detect URL from the edit context and prompt for user input
as needed.

Optional NEW-WINDOW is not currently respected.

Optional BROWSER requests a specific browser, using an Apple
bundle ID, eg \"com.apple.Safari\" or application name, eg
\"Webkit.app\".  When BROWSER is not set, the customizable
variable `osx-browse-prefer-browser' is consulted, and if that
value is nil, the system default is used.

Optional FOCUS can be set to 'foreground or 'background to
control whether the external process changes the focus.  If
BACKGROUND is not set, the customizable variable
`osx-browse-prefer-background' is consulted.

When called interactively, specifying a negative prefix argument
is equivalent to setting FOCUS to 'background.  Any other prefix
argument is equivalent to setting FOCUS to 'foreground."
  (interactive (osx-browse-interactive-form))
  (unless (stringp url)
	(error "No valid URL"))
  (let ((args (list url))
	(proc nil))
	(when browser
	  (callf2 append (list (if (osx-browse-bundle-name-p browser) "-b" "-a") browser) args))
	(when (eq osx-browse-prefer-background 'background)
	  (push "-g" args))
	(setq proc (apply 'start-process "osx-browse-url" nil osx-browse-open-command args))
	(set-process-query-on-exit-flag proc nil))
  (let ((width (- (frame-width) 25)))
	(when (and (eq focus 'background)
		   (not osx-browse-less-feedback)
		   (>= width 10))
	  (message "opened in background: %s" (osx-browse-truncate-url url width)))))

(defun jj/osx-browse-url-safari (url &optional new-window browser focus)
  "Open URL in Safari on OS X.

BROWSER defaults to \"com.apple.Safari\".

URL, NEW-WINDOW, and FOCUS are as documented for
`osx-browse-url'."
  (interactive (osx-browse-interactive-form))
  (callf or browser "com.apple.Safari")
  (jj/osx-browse-url url new-window browser focus))

(defun jj/google-this-noconfirm-background (prefix)
  "Decide what the user wants to google and go without confirmation.
Exactly like `google-this' or `google-this-search', but don't ask
for confirmation.
PREFIX determines quoting."
  (interactive "P")
  (let ((google-this-browse-url-function 'jj/osx-browse-url-safari))
	(google-this prefix 'noconfirm)))

(defun jj/google-this-word-background (prefix)
  "Google the current word.
PREFIX determines quoting."
  (interactive "P")
  (let ((google-this-browse-url-function 'jj/osx-browse-url-safari))
	(google-this-string prefix (thing-at-point 'word) t)))

(defun jj/google-this-background (prefix &optional noconfirm)
  "Decide what the user wants to google (always something under point).
Unlike `google-this-search' (which presents an empty prompt with
\"this\" as the default value), this function inserts the query
in the minibuffer to be edited.
PREFIX argument determines quoting.
NOCONFIRM goes without asking for confirmation."
  (interactive "P")
  (let ((google-this-browse-url-function 'jj/osx-browse-url-safari))
	(cond
	 ((region-active-p) (google-this-region prefix noconfirm))
	 ((thing-at-point 'symbol) (google-this-string prefix (thing-at-point 'symbol) noconfirm))
	 ((thing-at-point 'word) (google-this-string prefix (thing-at-point 'word) noconfirm))
	 (t (google-this-line prefix noconfirm)))))

(defun jj/google-this-forecast-background (prefix)
  "Search google for \"weather\".
With PREFIX, ask for location."
  (interactive "P")
  (let ((google-this-browse-url-function 'jj/osx-browse-url-safari))
	(if (not prefix) (google-this-parse-and-search-string "weather" nil)
	  (google-this-parse-and-search-string
	   (concat "weather " (read-string "Location: " nil nil "")) nil))))

(defun jj/myfunc-color-identifiers-mode-hook ()
  (interactive)
  (let ((faces '(font-lock-comment-face font-lock-comment-delimiter-face font-lock-constant-face font-lock-type-face font-lock-function-name-face font-lock-variable-name-face font-lock-keyword-face font-lock-string-face font-lock-builtin-face font-lock-preprocessor-face font-lock-warning-face font-lock-doc-face font-lock-negation-char-face font-lock-regexp-grouping-construct font-lock-regexp-grouping-backslash)))
	(dolist (face faces)
	  (face-remap-add-relative face '((:foreground "" :weight normal :slant normal)))))
  (face-remap-add-relative 'font-lock-keyword-face '((:weight bold)))
  (face-remap-add-relative 'font-lock-comment-face '((:slant italic)))
  (face-remap-add-relative 'font-lock-builtin-face '((:weight bold)))
  (face-remap-add-relative 'font-lock-preprocessor-face '((:weight bold)))
  (face-remap-add-relative 'font-lock-function-name-face '((:slant italic)))
  (face-remap-add-relative 'font-lock-string-face '((:slant italic)))
  (face-remap-add-relative 'font-lock-constant-face '((:weight bold))))

;; These need to be set after desktop-read is run
;; TODO: Make this into a for loop with all the buffers in a defvar list
;; Possible to put in a function that is hooked into desktop-after-read-hook
(defun jj/lock-my-dired-emacs-buffers ()
  (interactive)
  (progn
	(when (get-buffer "Downloads")
	  (progn
	(with-current-buffer "Downloads"
	  (interactive)
	  (jj/emacs-lock-mode-all))))
	(when (get-buffer "*scratch*")
	  (progn
	(with-current-buffer "*scratch*"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "FinishedTor")
	  (progn
	(with-current-buffer "FinishedTor"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "K")
	  (progn
	(with-current-buffer "K"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "user.el")
	  (progn
	(with-current-buffer "user.el"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "bindings.el")
	  (progn
	(with-current-buffer "bindings.el"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "settings.el")
	  (progn
	(with-current-buffer "settings.el"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	(when (get-buffer "functions.el")
	  (progn
	(with-current-buffer "functions.el"
	  (interactive)
	  (jj/emacs-lock-mode-kill))))
	))

(defun jj/quit-window-kill ()
  "Uses quit-window with prefix arg to kill the buffer and return to previous-window.
Useful in dired-mode and other modes that launch new windows like magit."
  (interactive)
  (quit-window t))

(defun jj/magit-mode-kill-buffer ()
  "Uses magit-mode-bury-buffer with prefix arg to kill the buffer and return to magit-status."
  (interactive)
  (magit-mode-bury-buffer '(4)))

;; Still runs with using s-x
(defadvice kill-ring-save (before slick-copy-line activate compile)
  "When called interactively with no region, copy the word or line

Calling it once without a region will copy the current word.
Calling it a second time will copy the current line."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
	 (if (eq last-command 'kill-ring-save)
	 (progn
	   ;; Uncomment to only keep the line in the kill ring
	   (kill-new "" t)
	   (message "Copied line")
	   (list (line-beginning-position)
		 (line-beginning-position 2)))
	   (save-excursion
	 (forward-char)
	 (backward-word)
	 (mark-word)
	 (message "Copied word")
	 (list (mark) (point)))))))

;; *** Kill word/line without selecting
(defadvice kill-region (before slick-cut-line first activate compile)
  "When called interactively kill the current word or line.

Calling it once without a region will kill the current word.
Calling it a second time will kill the current line."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
	 (if (eq last-command 'kill-region)
	 (progn
	   ;; Return the previous kill to rebuild the line
	   (yank)
	   ;; Add a blank kill, otherwise the word gets appended.
	   ;; Change to (kill-new "" t) to remove the word and only
	   ;; keep the whole line.
	   (kill-new "" t)
	   (message "Killed Line")
	   (list (line-beginning-position)
		 (line-beginning-position 2)))
	   (save-excursion
	 (forward-char)
	 (backward-word)
	 (mark-word)
	 (message "Killed word")
	 (list (mark) (point)))))))

(defun jj/sml/total-lines-append-mode-line ()
  "Appends the total lines after the current line to the mode-line after sml/setup.
Can be changed to include (or not) the percentage and current column."
  (setq-default mode-line-front-space
				;; (append mode-line-front-space '((12 "/" (:eval (format "%d" total-lines ))))))
				;; (append mode-line-front-space '((12 "/" (:eval (format "%d" total-lines )) ":" (-3 "%p")))))
				(append mode-line-front-space '((12  "::" (-3 "%p")))))
  ;; (append mode-line-front-space '((12 "/" (:eval (format "%d" total-lines)) "//" "%p" (:eval (format "::%2d" (1+ (current-column))))))))
  )

(define-minor-mode sensitive-mode
  "For sensitive files like password lists.
It disables backup creation and auto saving.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sens"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
	  (progn
		;; disable backups
		(set (make-local-variable 'backup-inhibited) t)
		;; disable auto-save
		(if auto-save-default
			(auto-save-mode -1)))
										;resort to default value of backup-inhibited
	(kill-local-variable 'backup-inhibited)
										;resort to default auto save setting
	(if auto-save-default
		(auto-save-mode 1))))

(defun jj/org-insert-heading-respect-content-and-delete-current-line ()
  "Delete line and insert heading at same level respecting the content"
  (interactive)
  (org-insert-heading-respect-content)
  (previous-line)
  (jj/delete-whole-line)
  (end-of-visible-line))

(defun jj/load-theme-leuven ()
  "Delete all themes, load theme leuven, setup smart-mode-line, and set the mode-line font"
  (interactive)
  (when (display-graphic-p)
	(set-face-attribute 'minibuffer-prompt nil :foreground nil :background nil)
	(set-face-attribute 'org-level-1 nil :background nil :foreground nil :bold t :height 1.3 :box t :overline t)
	(set-face-attribute 'org-level-2 nil :background nil :foreground nil :bold t :height 1.0 :box t :overline t)
	(set-face-attribute 'org-level-3 nil :foreground nil :bold nil :overline t)
	(set-face-attribute 'org-latex-and-related nil :foreground nil)
	(set-face-attribute 'org-verbatim nil :foreground nil)
	(set-face-attribute 'org-code nil :foreground nil)
	(set-face-attribute 'dired-ignored nil :foreground nil :background nil :strike-through nil)
	(set-face-attribute 'font-lock-comment-delimiter-face nil :foreground nil)
	(set-face-attribute 'font-lock-comment-face nil :foreground nil)
	(set-face-attribute 'dired-flagged nil :foreground nil :background nil)
	(set-face-attribute 'dired-warning nil :foreground nil :background nil :bold t)
	(set-face-attribute 'dired-symlink nil :foreground nil :background nil :bold nil)
	(set-face-attribute 'dired-header nil :foreground nil :background nil :bold t)
	(set-face-attribute 'dired-directory nil :foreground nil :background nil :bold t)
	(set-face-attribute 'dired-marked nil :foreground nil :background nil :bold t)
	(set-face-attribute 'dired-mark nil :foreground nil :background nil :bold t)
	(set-face-attribute 'region nil :foreground nil :background nil)
	(set-face-attribute 'secondary-selection nil :foreground nil :background nil)
	(set-face-attribute 'helm-selection nil :foreground nil :background nil)
	(set-face-attribute 'Man-overstrike nil :inherit 'bold :foreground "firebrick3")
	(set-face-attribute 'Man-underline nil :inherit 'underline :foreground "green3")
	(counsel-load-theme-action nil)
	(load-theme 'leuven)
	(sml/setup)
	(sml/apply-theme 'light)
	(jj/light-theme-set-visible-mark-faces)
	(set-face-attribute 'mode-line nil :font "Lucida Grande-13")))
(defun jj/sml/dark ()
  "Set sml to dark and set mode-line font to Lucida Grande"
  (interactive)
  (sml/setup)
  (sml/apply-theme 'dark)
  (set-face-attribute 'mode-line nil :font "Lucida Grande-13"))
(defun jj/sml/light ()
  "Set sml to light and set mode-line font to Lucida Grande"
  (interactive)
  (sml/setup)
  (sml/apply-theme 'dark)
  (set-face-attribute 'mode-line nil :font "Lucida Grande-13"))
(defun jj/load-reset-fonts-for-themes ()
  "Reset many font face attributes for proper loading of themes"
  (interactive)
  (set-face-attribute 'org-level-1 nil :background nil :foreground nil :bold nil :height 1 :box nil)
  (set-face-attribute 'org-level-2 nil :background nil :foreground nil :bold nil :height 1 :box nil)
  (set-face-attribute 'org-level-3 nil :foreground nil :bold nil)
  (set-face-attribute 'org-latex-and-related nil :foreground nil)
  (set-face-attribute 'org-verbatim nil :foreground nil)
  (set-face-attribute 'org-code nil :foreground nil)
  (set-face-attribute 'org-latex-and-related nil :foreground nil)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground nil)
  (set-face-attribute 'font-lock-comment-face nil :foreground nil)
  (set-face-attribute 'minibuffer-prompt nil :foreground nil :background nil)
  (set-face-attribute 'dired-ignored nil :foreground nil :background nil)
  (set-face-attribute 'dired-flagged nil :foreground nil :background nil)
  (set-face-attribute 'dired-warning nil :foreground nil :background nil)
  (set-face-attribute 'dired-symlink nil :foreground nil :background nil)
  (set-face-attribute 'dired-header nil :foreground nil :background nil)
  (set-face-attribute 'dired-directory nil :foreground nil :background nil)
  (set-face-attribute 'dired-marked nil :foreground nil :background nil)
  (set-face-attribute 'dired-mark nil :foreground nil :background nil)
  (set-face-attribute 'region nil :foreground nil :background nil)
  (set-face-attribute 'secondary-selection nil :foreground nil :background nil)
  (set-face-attribute 'helm-selection nil :foreground nil :background nil))

(defun jj/save-buffers-kill-terminal ()
  (interactive)
  (when (get-buffer "Downloads")
	(progn
	  (with-current-buffer "Downloads"
	(interactive)
	(jj/emacs-lock-mode-off))))
  (save-buffers-kill-terminal))

(defun dired-kill-tree (dirname &optional remember-marks kill-root)
  "Kill all proper subdirs of DIRNAME, excluding DIRNAME itself.
Interactively, you can kill DIRNAME as well by using a prefix argument.
In interactive use, the command prompts for DIRNAME.

When called from Lisp, if REMEMBER-MARKS is non-nil, return an alist
of marked files.  If KILL-ROOT is non-nil, kill DIRNAME as well."
  (interactive "DKill tree below directory: \ni\nP")
  (setq dirname (file-name-as-directory (expand-file-name dirname)))
  (let ((s-alist dired-subdir-alist) dir m-alist)
	(while s-alist
	  (setq dir (car (car s-alist))
		s-alist (cdr s-alist))
	  (and (or kill-root (not (string-equal dir dirname)))
	   (dired-in-this-tree dir dirname)
	   (dired-goto-subdir dir)
	   (setq m-alist (nconc (dired-kill-subdir remember-marks) m-alist))))
	m-alist))

(defun jj/dired-kill-tree (dirname &optional remember-marks kill-root)
  "Kill all proper subdirs of DIRNAME, excluding DIRNAME itself.
Interactively, you can kill DIRNAME as well by using a prefix argument.
In interactive use, the command prompts for DIRNAME.

When called from Lisp, if REMEMBER-MARKS is non-nil, return an alist
of marked files.  If KILL-ROOT is non-nil, kill DIRNAME as well."
  (interactive "DKill tree below directory: \ni\nP")
  (setq dirname (file-name-as-directory (expand-file-name dirname)))
  (let ((s-alist dired-subdir-alist) dir m-alist)
	(while s-alist
	  (setq dir (car (car s-alist))
		s-alist (cdr s-alist))
	  (and (or kill-root (not (string-equal dir dirname)))
	   (dired-in-this-tree dir dirname)
	   (dired-goto-subdir dir)
	   (setq m-alist (nconc (dired-kill-subdir remember-marks) m-alist))))
	m-alist)
  (jj/dired-beginning-of-subdir))

(defun jj/delete-backward-char-or-bracket-text ()
  "Delete backward 1 character, but if it's a \"quote\" or bracket ()[]{}【】「」 etc, delete bracket and the inner text, push the deleted text to `kill-ring'.

What char is considered bracket or quote is determined by current syntax table.

If `universal-argument' is called first, do not delete inner text.

URL `http://ergoemacs.org/emacs/emacs_delete_backward_char_or_bracket_text.html'
Version 2017-07-02"
  (interactive)
  (if (and delete-selection-mode (region-active-p))
	  (delete-region (region-beginning) (region-end))
	(cond
	 ((looking-back "\\s)" 1)
	  (if current-prefix-arg
	  (jj/delete-backward-bracket-pair)
	(jj/delete-backward-bracket-text)))
	 ((looking-back "\\s(" 1)
	  (progn
	(backward-char)
	(forward-sexp)
	(if current-prefix-arg
		(jj/delete-backward-bracket-pair)
	  (jj/delete-backward-bracket-text))))
	 ((looking-back "\\s\"" 1)
	  (if (nth 3 (syntax-ppss))
	  (progn
		(backward-char )
		(jj/delete-forward-bracket-pairs (not current-prefix-arg)))
	(if current-prefix-arg
		(jj/delete-backward-bracket-pair)
	  (jj/delete-backward-bracket-text))))
	 (t
	  (delete-char -1)))))

(defun jj/delete-backward-bracket-text ()
  "Delete the matching brackets/quotes to the left of cursor, including the inner text.

This command assumes the left of point is a right bracket, and there's a matching one before it.

What char is considered bracket or quote is determined by current syntax table.

URL `http://ergoemacs.org/emacs/emacs_delete_backward_char_or_bracket_text.html'
Version 2017-07-02"
  (interactive)
  (progn
	(forward-sexp -1)
	(mark-sexp)
	(kill-region (region-beginning) (region-end))))

(defun jj/delete-backward-bracket-pair ()
  "Delete the matching brackets/quotes to the left of cursor.

After the command, mark is set at the left matching bracket position, so you can `exchange-point-and-mark' to select it.

This command assumes the left of point is a right bracket, and there's a matching one before it.

What char is considered bracket or quote is determined by current syntax table.

URL `http://ergoemacs.org/emacs/emacs_delete_backward_char_or_bracket_text.html'
Version 2017-07-02"
  (interactive)
  (let (( $p0 (point)) $p1)
	(forward-sexp -1)
	(setq $p1 (point))
	(goto-char $p0)
	(delete-char -1)
	(goto-char $p1)
	(delete-char 1)
	(push-mark (point) t)
	(goto-char (- $p0 2))))

(defun jj/delete-forward-bracket-pairs ( &optional @delete-inner-text-p)
  "Delete the matching brackets/quotes to the right of cursor.
If *delete-inner-text-p is true, also delete the inner text.

After the command, mark is set at the left matching bracket position, so you can `exchange-point-and-mark' to select it.

This command assumes the char to the right of point is a left bracket or quote, and have a matching one after.

What char is considered bracket or quote is determined by current syntax table.

URL `http://ergoemacs.org/emacs/emacs_delete_backward_char_or_bracket_text.html'
Version 2017-07-02"
  (interactive)
  (if @delete-inner-text-p
	  (progn
	(mark-sexp)
	(kill-region (region-beginning) (region-end)))
	(let (($pt (point)))
	  (forward-sexp)
	  (delete-char -1)
	  (push-mark (point) t)
	  (goto-char $pt)
	  (delete-char 1))))

(defun jj/counsel-rg-in-project ()
  "Use `ffip' and `counsel-ag' for quick project-wide text searching."
  (interactive)
  (let ((project-root (ffip-project-root)))
	;; if ffip could not find project-root, it will already have
	;; shown an error message. We only have to check for non-nil.
	(if project-root
	(counsel-rg nil project-root nil
			(format "Search in PRJ %s" project-root)))))

(defun jj/counsel-ag-in-project ()
  "Use `ffip' and `counsel-ag' for quick project-wide text searching."
  (interactive)
  (let ((project-root (ffip-project-root)))
	;; if ffip could not find project-root, it will already have
	;; shown an error message. We only have to check for non-nil.
	(if project-root
	(counsel-rg nil project-root nil
			(format "Search in PRJ %s" project-root)))))

(defun jj/ivy-return-recentf-index (dir)
  (when (and (boundp 'recentf-list)
		 recentf-list)
	(let ((files-list
	   (cl-subseq recentf-list
			  0 (min (- (length recentf-list) 1) 20)))
	  (index 0))
	  (while files-list
	(if (string-match-p dir (car files-list))
		(setq files-list nil)
	  (setq index (+ index 1))
	  (setq files-list (cdr files-list))))
	  index)))

(defun jj/ivy-sort-file-function (x y)
  (let* ((x (concat ivy--directory x))
	 (y (concat ivy--directory y))
	 (x-mtime (nth 5 (file-attributes x)))
	 (y-mtime (nth 5 (file-attributes y))))
	(if (file-directory-p x)
	(if (file-directory-p y)
		(let ((x-recentf-index (jj/ivy-return-recentf-index x))
		  (y-recentf-index (jj/ivy-return-recentf-index y)))
		  (if (and x-recentf-index y-recentf-index)
		  ;; Directories is sorted by `recentf-list' index
		  (< x-recentf-index y-recentf-index)
		(string< x y)))
	  t)
	  (if (file-directory-p y)
	  nil
	;; Files is sorted by mtime
	(time-less-p y-mtime x-mtime)))))

(defun jj/ivy-sort-file-by-mtime (x y)
  (let* ((x (concat ivy--directory x))
	 (y (concat ivy--directory y))
	 (x-mtime (nth 5 (file-attributes x)))
	 (y-mtime (nth 5 (file-attributes y))))
	(if (file-directory-p x)
	(if (file-directory-p y)
		(time-less-p y-mtime x-mtime)
	  t)
	  (if (file-directory-p y)
	  nil
	(time-less-p y-mtime x-mtime)))))

;; Only use ws-butler in buffers where whitespace-cleanup-mode isn't turned on
(defun jj/ws-butler-mode-if-whitespace-initially-not-clean ()
  (interactive)
  (if (not whitespace-cleanup-mode-initially-clean)
	  (ws-butler-mode)))

;; NOTE: Rewrote hl-todo--setup in hl-todo.el to highlight hl-todo-highlight-punctuation before keywords (not just after)
;; Further modified hl-todo so to insert keywords with a colon and always a space after the colon
;; no space before comment on a new line (and double comments in emacs-lisp)
(defun hl-todo-insert-keyword (keyword)
  "Insert TODO or similar keyword.
If point is not inside a string or comment, then insert a new
comment.  If point is at the end of the line, then insert the
comment there, otherwise insert it as a new line before the
current line."
  (interactive
   (list (completing-read
	  "Insert keyword: "
	  (mapcar (pcase-lambda (`(,keyword . ,face))
			(propertize keyword 'face
				(if (stringp face)
					(list :inherit 'hl-todo :foreground face)
				  face)))
		  hl-todo-keyword-faces))))
  (cond
   ((hl-todo--inside-comment-or-string-p)
	(insert (concat (and (not (memq (char-before) '(?\s ?\t))) " ")
			keyword
			":"
			;; NOTE: Removed ?\n in '(?\s ?\t))) so always puts a space even at end of line
			(and (not (memq (char-after) '(?\s ?\t))) " "))))
   ((eolp)
	;; NOTE: Removed (and (not (memq (char-before) '(?\s ?\t))) " ") because puts space before
	(insert (concat
		 (format "%s %s: "
			 (if (derived-mode-p 'lisp-mode 'emacs-lisp-mode)
			 (format "%s%s" comment-start comment-start)
			   comment-start)
			 keyword)
		 (and (not (memq (char-after) '(?\s ?\t))) " ")))
	(backward-char))
   (t
	(goto-char (line-beginning-position))
	(insert (format "%s %s: \n"
			(if (derived-mode-p 'lisp-mode 'emacs-lisp-mode)
			(format "%s%s" comment-start comment-start)
			  comment-start)
			keyword))
	(backward-char)
	(indent-region (line-beginning-position) (line-end-position)))))

;;requires frame-cmds package
(defvar jj/wttrin-frame-changed nil
  "If wttrin is entered changing the frame, set to t to exit in returning to the previous frame and window state.")
(defun jj/wttrin-save-frame ()
  "Save frame and window configuration and then expand frame for wttrin."
  ;;save window arrangement to a register
  (window-configuration-to-register :pre-wttrin)
  (delete-other-windows)
  ;;save frame setup and resize
  (save-frame-config)
  (set-frame-width (selected-frame) 130)
  (set-frame-height (selected-frame) 48)
  )
;; (advice-add 'wttrin :before #'jj/wttrin-save-frame)
(defun jj/wttrin-restore-frame ()
  "Restore frame and window configuration saved prior to launching wttrin."
  (interactive)
  (if (equal jj/wttrin-frame-changed t)
	  (progn
	(jump-to-frame-config-register)
	(jump-to-register :pre-wttrin)
	(setq jj/wttrin-frame-changed nil)
	)
	;; (message "Did not enter wttrin changing the frame.")
	))
(advice-add 'wttrin-exit :after #'jj/wttrin-restore-frame)

;; function to open wttrin with first city on list
(defun jj/weather-default-wttrin ()
  "Open `wttrin' without prompting, using first city in `wttrin-default-cities'"
  (interactive)
  ;; save window arrangement to register
  (jj/wttrin-save-frame)
  ;; call wttrin
  (wttrin-query (car wttrin-default-cities))
  ;; set that the frame was changed for exit
  (setq jj/wttrin-frame-changed t)
  )
(defun jj/weather-wttrin (city)
  "Open `wttrin' without prompting, using first city in `wttrin-default-cities'"
  (interactive
   (list
	(completing-read "City name: " wttrin-default-cities nil nil
			 (when (= (length wttrin-default-cities) 1)
			   (car wttrin-default-cities)))))
  ;; save window arrangement to register
  (jj/wttrin-save-frame)
  (wttrin-query city)
  ;; set that the frame was changed for exit
  (setq jj/wttrin-frame-changed t)
  )

(defun jj/backup-each-save-filter (filename)
  (let ((ignored-filenames
		 '("^/tmp" "semantic.cache$" "\\.gpg$" "\\.snes$" "\\.pdf$" "\\places$" "\\abbrev_defs$" "\\bookmarks$" "\\emacs_workgroups$"
		   "smex-items$" "\\recentf$" "\\.recentf$" "\\tramp$"
		   "\\.mc-lists.el$" "\\.emacs.desktop$" "\\history$" ".newsrc\\(\\.eld\\)?"))
		(matched-ignored-filename nil))
	(mapc
	 (lambda (x)
	   (when (string-match x filename)
		 (setq matched-ignored-filename t)))
	 ignored-filenames)
	(not matched-ignored-filename)))

(defun jj/backup-each-save-dired-jump ()
  (interactive)
  (let* (
	 (filename (buffer-file-name))
	 (containing-dir (file-name-directory filename))
	 (basename (file-name-nondirectory filename))
	 (backup-container
	  (format "%s/%s"
		  backup-each-save-mirror-location
		  containing-dir))
	 )
	(when (file-exists-p backup-container)
	  (find-file backup-container)
	  (goto-char (point-max))
	  (search-backward basename)
	  )))

(defun jj/projectile-kill-non-project-buffers (&optional kill-special)
  "Kill buffers that do not belong to a `projectile' project.

With prefix argument (`C-u'), also kill the special buffers."
  (interactive "P")
  (let ((bufs (buffer-list (selected-frame))))
	(dolist (buf bufs)
	  (with-current-buffer buf
	(let ((buf-name (buffer-name buf)))
	  (when (or (null (projectile-project-p))
			(and kill-special
			 (string-match "^\*" buf-name)))
		;; Preserve buffers with names starting with *scratch or *Messages
		(unless (string-match "^\\*\\(\\scratch\\|Messages\\)" buf-name)
		  (message "Killing buffer %s" buf-name)
		  (kill-buffer buf))))))))

(defmacro jj/special-beginning-of-buffer (mode &rest forms)
  "Define a special version of `beginning-of-buffer' in MODE.

The special function is defined such that the point first moves
to `point-min' and then FORMS are evaluated.  If the point did
not change because of the evaluation of FORMS, jump
unconditionally to `point-min'.  This way repeated invocations
toggle between real beginning and logical beginning of the
buffer."
  (declare (indent 1))
  (let ((fname (intern (concat "jj/" (symbol-name mode) "-beginning-of-buffer")))
	(mode-map (intern (concat (symbol-name mode) "-mode-map")))
	(mode-hook (intern (concat (symbol-name mode) "-mode-hook"))))
	`(progn
	   (defun ,fname ()
	 (interactive)
	 (let ((p (point)))
	   (goto-char (point-min))
	   ,@forms
	   (when (= p (point))
		 (goto-char (point-min)))))
	   (add-hook ',mode-hook
		 (lambda ()
		   (define-key ,mode-map
			 [remap beginning-of-buffer] ',fname))))))

(defmacro jj/special-end-of-buffer (mode &rest forms)
  "Define a special version of `end-of-buffer' in MODE.

The special function is defined such that the point first moves
to `point-max' and then FORMS are evaluated.  If the point did
not change because of the evaluation of FORMS, jump
unconditionally to `point-max'.  This way repeated invocations
toggle between real end and logical end of the buffer."
  (declare (indent 1))
  (let ((fname (intern (concat "jj/" (symbol-name mode) "-end-of-buffer")))
	(mode-map (intern (concat (symbol-name mode) "-mode-map")))
	(mode-hook (intern (concat (symbol-name mode) "-mode-hook"))))
	`(progn
	   (defun ,fname ()
	 (interactive)
	 (let ((p (point)))
	   (goto-char (point-max))
	   ,@forms
	   (when (= p (point))
		 (goto-char (point-max)))))
	   (add-hook ',mode-hook
		 (lambda ()
		   (define-key ,mode-map
			 [remap end-of-buffer] ',fname))))))

(defun jj/dired-beginning-of-subdir ()
  "Move to the first line in the current subdirectory.
TODO: If on the first line of directory already, move to previous directory.
"
  (interactive)
  (dired-previous-line 1)
  (if (not (ignore-errors (dired-get-filename)))
	  (progn
	(dired-next-line 1)
	(dired-prev-subdir 1))
	(dired-prev-subdir 0)
	)
  (let ((num 0))
	(while (and (not (ignore-errors (dired-get-filename))) (< num 3))
	  (dired-next-line 1)
	  (setq num (1+ num)))
	(if (eq num 3)
	(dired-prev-subdir 1))))

(defun jj/insert-space-in-front (arg)
  (interactive "P")
  (save-excursion
	(if (eq arg nil)
	(self-insert-command 2 ?\s)
	  (self-insert-command (prefix-numeric-value arg) ?\s))))

(defun current-line-empty-p ()
  (save-excursion
	(beginning-of-line)
	(looking-at "[[:space:]]*$")))

(defun jj/dired-kill-subdir ()
  "Kill subdir and go to first line of previous subdirectory."
  (interactive)
  (let ((eob nil))
	(if (eq (dired-subdir-max) (point-max))
	(setq eob t))
	(dired-kill-subdir)
	(if (eq eob nil)
	(jj/dired-prev-subdir)
	  (progn
	(dired-previous-line 1)
	(if (not (ignore-errors (dired-get-filename)))
		(dired-prev-subdir 0)
	  (progn
		(dired-next-line 1)
		(jj/dired-beginning-of-subdir)))))))

(defun jj/dired-prev-subdir ()
  "Move to the first line in the previous subdir."
  (interactive)
  (dired-prev-subdir 1)
  (let ((num 0))
	(while (and (not (ignore-errors (dired-get-filename))) (< num 3))
	  (dired-next-line 1)
	  (setq num (1+ num)))
	(if (eq num 3)
	(dired-prev-subdir 1))))

(defun jj/dired-next-subdir ()
  "Move to the first line in the next subdirectory."
  (interactive)
  (let ((num 0)
	(eob nil))
	(dired-next-subdir 1)
	(if (eq (dired-subdir-max) (point-max))
	(setq eob t))
	(while (and (not (ignore-errors (dired-get-filename))) (< num 3))
	  (dired-next-line 1)
	  (setq num (1+ num)))
	(if (eq num 3)
	(dired-prev-subdir 1))
	(if (eq eob t)
	(dired-next-subdir 1))))

(defun jj/dired-next-line (&optional arg)
  "Move to the next line using dired-hacks-next-file unless it's
the end of the buffer then use diredp-next-line so it wraps
around to the top."
  (interactive "p")
  (unless arg (setq arg 1))
  (if (eq (dired-subdir-max) (point-max))
	  (diredp-next-line arg)
	(dired-hacks-next-file arg)))

(defun jj/dired-previous-line (&optional arg)
  "Move to the previous line using dired-hacks-previous-file unless it's
the beginning of the buffer then use diredp-previous-line so it wraps
around to the bottom."
  (interactive "p")
  (unless arg (setq arg 1))
  (if (eq (dired-subdir-min) (point-min))
	  (diredp-previous-line arg)
	(dired-hacks-previous-file arg)))

(defun jj/dired-tree-down ()
  "Move to the previous subdirMove to the first line in the current subdirectory."
  (interactive)
  (let ((num 0)
	(eob nil))
	(dired-tree-down)
	(if (eq (dired-subdir-max) (point-max))
	(setq eob t))
	(while (and (not (ignore-errors (dired-get-filename))) (< num 3))
	  (dired-next-line 1)
	  (setq num (1+ num)))
	(if (eq num 3)
	(dired-prev-subdir 1))
	(if (eq eob t)
	(dired-next-subdir 1))))

(defun jj/dired-tree-up ()
  "Move to the first line in the current subdirectory."
  (interactive)
  (dired-tree-up 1)
  (let ((num 0))
	(while (and (not (ignore-errors (dired-get-filename))) (< num 3))
	  (dired-next-line 1)
	  (setq num (1+ num)))
	(if (eq num 3)
	(dired-prev-subdir 1))))

(defun jj/backup-every-save ()
  "Backup files every time they are saved.

Files are backed up to `jj/backup-location' in subdirectories \"per-session\" once per Emacs session, and \"per-save\" every time a file is saved.

Files whose names match the REGEXP in `jj/backup-exclude-regexp' are copied to `jj/backup-trash-dir' instead of the normal backup directory.

Files larger than `jj/backup-file-size-limit' are not backed up."

  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
	;;
	;; Override the default parameters for per-session backups.
	;;
	(let ((backup-directory-alist
	   `(("." . ,(expand-file-name "per-session" jj/backup-location))))
	  (kept-new-versions 3))
	  ;;
	  ;; add trash dir if needed
	  ;;
	  (if jj/backup-exclude-regexp
	  (add-to-list
	   'backup-directory-alist
	   `(,jj/backup-exclude-regexp . ,jj/backup-trash-dir)))
	  ;;
	  ;; is file too large?
	  ;;
	  (if (<= (buffer-size) jj/backup-file-size-limit)
	  (progn
		(message "Made per session backup of %s" (buffer-name))
		(backup-buffer))
	(message "WARNING: File %s too large to backup - increase value of jj/backup-file-size-limit" (buffer-name)))))
  ;;
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  ;;
  (let ((buffer-backed-up nil))
	;;
	;; is file too large?
	;;
	(if (<= (buffer-size) jj/backup-file-size-limit)
	(progn
	  (message "Made per save backup of %s" (buffer-name))
	  (backup-buffer))
	  (message "WARNING: File %s too large to backup - increase value of jj/backup-file-size-limit" (buffer-name)))))

(defun jj/wg-workgroups-mode-switch ()
  (interactive)
  (let (group-names selected-group)
	(unless (featurep 'workgroups2)
	  (require 'workgroups2))
	(setq group-names
	  (mapcar (lambda (group)
			;; re-shape list for the ivy-read
			(cons (wg-workgroup-name group) group))
		  (wg-session-workgroup-list (read (f-read-text (file-truename wg-session-file))))))
	(ivy-read "work groups" group-names
		  :action (lambda (group)
			(wg-find-session-file wg-default-session-file)
			(wg-switch-to-workgroup group)))))

(eval-after-load 'workgroups2
  '(progn
	 ;; make sure wg-create-workgroup always success
	 (defadvice wg-create-workgroup (around wg-create-workgroup-hack activate)
	   (unless (file-exists-p (wg-get-session-file))
	 (wg-reset t)
	 (wg-save-session t))

	   (unless wg-current-session
	 ;; code extracted from `wg-open-session'.
	 ;; open session but do NOT load any workgroup.
	 (let ((session (read (f-read-text (file-truename wg-session-file)))))
	   (setf (wg-session-file-name session) wg-session-file)
	   (wg-reset-internal (wg-unpickel-session-parameters session))))
	   ad-do-it
	   ;; save the session file in real time
	   (wg-save-session t))

	 (defadvice wg-reset (after wg-reset-hack activate)
	   (wg-save-session t))

	 ;; I'm fine to to override the original workgroup
	 (defadvice wg-unique-workgroup-name-p (around wg-unique-workgroup-name-p-hack activate)
	   (setq ad-return-value t))))

(defun jj/dired-sort-by-size-switch-toggle ()
  "Sort by time not putting directories first"
  (interactive)
  (cond ((string= dired-actual-switches "-a -F -lGhHAv -L")
	 (dired-sort-other "-a -F -lGhHAv  --group-directories-first"))
	((string= dired-actual-switches "-a -F -lGhHAv -L -S")
	 (dired-sort-other "-a -F -lGhHAv  --group-directories-first"))
	(t
	 (dired-sort-other "-a -F -lGhHAv -L -S")))
  (force-mode-line-update))

(defun jj/dired-sort-toggle-reverse-switch ()
  "Toggle ls -r switch and update buffer.
Does not affect other sort switches."
  (interactive)
  (let (case-fold-search)
	(setq dired-actual-switches
	  (if (string-match "-r " dired-actual-switches)
		  (replace-match "" t t dired-actual-switches)
		(concat "-r " dired-actual-switches)))
	(dired-sort-set-mode-line)
	(revert-buffer)))

(defun jj/dired-sort-remove-classify-switch ()
  "Remove -F switch.
TODO: Change to using regex to remove any -F or --classify switches."
  (interactive)
  (let (case-fold-search)
	(setq dired-actual-switches
	  (if (string-match "-F " dired-actual-switches)
		  (replace-match "" t t dired-actual-switches)
		(concat dired-actual-switches)))
	;; Don't need as doesn't change the mode-line currently
	;; (dired-sort-set-mode-line)
	(revert-buffer)))

(defun jj/dired-sort-add-classify-switch ()
  "Add -F switch after -a.
TODO: change to using regex"
  (interactive)
  (let (case-fold-search)
	(cond ((string-match "-F " dired-actual-switches))
	  (t
	   (setq dired-actual-switches
		 (if (string-match "-a " dired-actual-switches)
			 (replace-match "-a -F " t t dired-actual-switches)
		   (concat dired-actual-switches)))
	   ))
	(revert-buffer)))

(defvar-local jj/wdired-classify-enabled nil)
(defun jj/wdired-before-start-advice ()
  "Execute when switching from `dired' to `wdired'."
  ;; TODO: Change to save current dired-switches if the add and remove functions use regex
  (setq jj/wdired-classify-enabled
	(if (string-match "-F " dired-actual-switches)
		t nil))
  (when (string-match "-F " dired-actual-switches)
	(jj/dired-sort-remove-classify-switch)))
(defun jj/wdired-after-finish-advice ()
  "Execute when switching from `wdired' to `dired'"
  (when (eq jj/wdired-classify-enabled t)
	;; can save the current switches in defvar-local and set here instead
	(jj/dired-sort-add-classify-switch)
	(setq jj/wdired-classify-enabled nil)))
(advice-add 'wdired-change-to-wdired-mode :before #'jj/wdired-before-start-advice)
(advice-add 'wdired-change-to-dired-mode :after #'jj/wdired-after-finish-advice)

;; set these up to combine jj/dired-cycle-switches and jj/dired-sort-*-toggle
;; keep this function below because works on all OS's but modify to be relevant for linux/mac
(defun jj/dired-sort-choose ()
  "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2018-12-23"
  (interactive)
  (let ($sort-by $arg)
	(setq $sort-by (ido-completing-read "Sort by:" '( "date" "size" "name" )))
	(cond
	 ((equal $sort-by "name") (setq $arg "-a -Al "))
	 ((equal $sort-by "date") (setq $arg "-a -Al -t"))
	 ((equal $sort-by "size") (setq $arg "-a -Al -S"))
	 ;; ((equal $sort-by "dir") (setq $arg "-a -l --group-directories-first"))
	 (t (error "logic error 09535" )))
	(dired-sort-other $arg ))
  (dired-sort-set-mode-line))

(defun dired-sort-toggle ()
  "This is a redefinition of the fn from dired.el. Normally,
dired sorts on either name or time, and you can swap between them
with the s key.  This function one sets sorting on name, size,
time, and extension. Cycling works the same.
"
  (setq dired-actual-switches
	(let (case-fold-search)
	  (cond
	   ((string-match " " dired-actual-switches) ;; contains a space
		;; New toggle scheme: add/remove a trailing " -t" " -S",
		;; or " -U"
		;; -t = sort by time (date)
		;; -S = sort by size
		;; -X = sort by extension

		(cond

		 ((string-match " -t\\'" dired-actual-switches)
		  (concat
		   (substring dired-actual-switches 0 (match-beginning 0))
		   " -X"))

		 ((string-match " -X\\'" dired-actual-switches)
		  (concat
		   (substring dired-actual-switches 0 (match-beginning 0))
		   " -S"))

		 ((string-match " -S\\'" dired-actual-switches)
		  (substring dired-actual-switches 0 (match-beginning 0)))

		 (t
		  (concat dired-actual-switches " -t"))))

	   (t
		;; old toggle scheme: look for a sorting switch, one of [tUXS]
		;; and switch between them. Assume there is only ONE present.
		(let* ((old-sorting-switch
			(if (string-match (concat "[t" dired-ls-sorting-switches "]")
					  dired-actual-switches)
			(substring dired-actual-switches (match-beginning 0)
				   (match-end 0))
			  ""))

		   (new-sorting-switch
			(cond
			 ((string= old-sorting-switch "t") "X")
			 ((string= old-sorting-switch "X") "S")
			 ((string= old-sorting-switch "S") "")
			 (t "t"))))
		  (concat
		   "-l"
		   ;; strip -l and any sorting switches
		   (dired-replace-in-string (concat "[-lt"
						dired-ls-sorting-switches "]")
					""
					dired-actual-switches)
		   new-sorting-switch))))))

  (dired-sort-set-mode-line)
  (revert-buffer))

(defun jj/dired-hide-all-but-this-dir ()
  "Hide all directories but the one the current line is on."
  (interactive)
  (let ((num 0)
	(eob nil))
	(if (eq (dired-subdir-max) (point-max))
	(setq eob t))
	(dired-hide-all)
	(dired-hide-subdir 1)
	(cond ((eq eob t)
	   (while (and (not (ignore-errors (dired-get-filename))) (< num 3))
		 (dired-next-line 1)
		 (setq num (1+ num))))
	  (t
	   (jj/dired-prev-subdir))
	  )))

(defun jj/dired-sort-set-mode-line ()
  (interactive)
  (dired-sort-set-mode-line))
(defun dired-sort-set-mode-line ()
  "This is a redefinition of the fn from `dired.el'. This one
properly provides the modeline in dired mode, supporting the new
search modes defined in the new `dired-sort-toggle'.
"
  ;; Set modeline display according to dired-actual-switches.
  ;; Modeline display of "by name" or "by date" guarantees the user a
  ;; match with the corresponding regexps.  Non-matching switches are
  ;; shown literally.
  (when (eq major-mode 'dired-mode)
	(setq mode-name
	  (let (case-fold-search)
		(cond
		 ((string-match "^-[^t]*t[^t]*$" dired-actual-switches)
		  "Ɖ:time")
		 ((string-match "^-[^X]*X[^X]*$" dired-actual-switches)
		  "Ɖ:ext")
		 ((string-match "^-[^S]*S[^S]*$" dired-actual-switches)
		  "Ɖ:sz")
		 ((string-match "-t$" dired-actual-switches)
		  "Ɖ:time")
		 ((string-match "-[^SXUt]$" dired-actual-switches)
		  "Ɖ:name")
		 (t
		  ;; (concat "Ɖ " dired-actual-switches)))))
		  (concat "Ɖ:name")))
		))
	(let ((case-fold-search nil))
	  (if (string-match "group-directories-first" dired-actual-switches)
	  (setq mode-name (concat mode-name ":dir"))
	(setq mode-name (concat mode-name ":file")))
	  (if (string-match "v" dired-actual-switches)
	  (setq mode-name (concat mode-name ":v")))
	  (if (string-match "L" dired-actual-switches)
	  (setq mode-name (concat mode-name ":L")))
	  (if (string-match "-r" dired-actual-switches)
	  (setq mode-name (concat mode-name ":Ř"))))
	(force-mode-line-update)))

(defun package-upgrade-all ()
  "Upgrade all packages automatically without showing *Packages* buffer."
  (interactive)
  (package-refresh-contents)
  (let (upgrades)
	(cl-flet ((get-version (name where)
			   (let ((pkg (cadr (assq name where))))
				 (when pkg
				   (package-desc-version pkg)))))
	  (dolist (package (mapcar #'car package-alist))
	(let ((in-archive (get-version package package-archive-contents)))
	  (when (and in-archive
			 (version-list-< (get-version package package-alist)
					 in-archive))
		(push (cadr (assq package package-archive-contents))
		  upgrades)))))
	(if upgrades
	(when (yes-or-no-p
		   (message "Upgrade %d package%s (%s)? "
			(length upgrades)
			(if (= (length upgrades) 1) "" "s")
			(mapconcat #'package-desc-full-name upgrades ", ")))
	  (save-window-excursion
		(dolist (package-desc upgrades)
		  (let ((old-package (cadr (assq (package-desc-name package-desc)
						 package-alist))))
		(package-install package-desc)
		(package-delete  old-package)))))
	  (message "All packages are up to date"))))

;; Not used but can reset checkboxes and narrow subtree when all are checked
(defun jj/org-reset-checkbox-state-subtree ()
  "Simplified version of org-list builtin"
  ;; Begin copy from org-reset-checkbox-subtree
  (org-narrow-to-subtree)
  (org-show-subtree)
  (goto-char (point-min))
  (let ((end (point-max)))
	(while (< (point) end)
	  (when (org-at-item-checkbox-p)
	(replace-match "[ ]" t t nil 1))
	  (beginning-of-line 2)))
  (org-update-checkbox-count-maybe 'all)
  ;; End copy from org-reset-checkbox-subtree
  )

(defun jj/org-checkbox-todo ()
  "Switch header TODO state to DONE when all checkboxes are ticked, to TODO otherwise"
  (let ((todo-state (org-get-todo-state)) beg end)
	(unless (not todo-state)
	  (save-excursion
	(org-back-to-heading t)
	(setq beg (point))
	(end-of-line)
	(setq end (point))
	(goto-char beg)
	(if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
				   end t)
		(if (match-end 1)
		(if (equal (match-string 1) "100%")
			(unless (string-equal todo-state "DONE")
			  ;; (jj/org-reset-checkbox-state-subtree)
			  (org-todo 'done))
		  (unless (string-equal todo-state "TODO")
			(org-todo 'todo)))
		  (if (and (> (match-end 2) (match-beginning 2))
			   (equal (match-string 2) (match-string 3)))
		  (unless (string-equal todo-state "DONE")
			;; (jj/org-reset-checkbox-state-subtree)
			(org-todo 'done))
		(unless (string-equal todo-state "TODO")
		  (org-todo 'todo)))))))))

(defun jj/htop-view-processes ()
  (interactive)
  (if (get-buffer "*htop*")
	  (switch-to-buffer "*htop*")
	(ansi-term "/bin/bash" "htop")
	(comint-send-string "*htop*" "htop\n")))

;; Make the compilation window automatically disappear - from enberg on #emacs
;; (setq compilation-finish-functions
;;       (lambda (buf str)
;;	(if (null (string-match ".*exited abnormally.*" str))
;;		;;no errors, make the compilation window go away in a few seconds
;;		(progn
;;		  (run-at-time
;;		   "2 sec" nil 'delete-windows-on
;;		   (get-buffer-create "*compilation*"))
;;		  (message "No Compilation Errors!")))))

;; (defun jj/bury-compile-buffer-if-successful (buffer string)
;;   "Bury a compilation buffer if succeeded without warnings "
;;   (if (and
;;        (string-match "compilation" (buffer-name buffer))
;;        (string-match "finished" string)
;;        (not
;;         (with-current-buffer buffer
;;           **(goto-char 1)**
;;           (search-forward "warning" nil t))))
;;       (run-with-timer 1 nil
;;                       (lambda (buf)
;;                         (bury-buffer buf)
;;                         (switch-to-prev-buffer (get-buffer-window buf) 'kill))
;;                       buffer)))
;; (add-hook 'compilation-finish-functions 'jj/bury-compile-buffer-if-successful)

(defalias 'word-count 'count-words)

;; remove comments from org document for use with export hook
;; https://emacs.stackexchange.com/questions/22574/orgmode-export-how-to-prevent-a-new-line-for-comment-lines
(defun delete-org-comments (backend)
  (loop for comment in (reverse (org-element-map (org-element-parse-buffer)
					'comment 'identity))
	do
	(setf (buffer-substring (org-element-property :begin comment)
				(org-element-property :end comment))
		  "")))

(defun jj/next-user-buffer ()
  "Switch to the next user buffer.
“user buffer” is determined by `jj/user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
	(while (< i 20)
	  (if (not (jj/user-buffer-q))
	  (progn (next-buffer)
		 (setq i (1+ i)))
	(progn (setq i 100))))))

(defun jj/previous-user-buffer ()
  "Switch to the previous user buffer.
“user buffer” is determined by `jj/user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
	(while (< i 20)
	  (if (not (jj/user-buffer-q))
	  (progn (previous-buffer)
		 (setq i (1+ i)))
	(progn (setq i 100))))))

(defun jj/user-buffer-q ()
  "Return t if current buffer is a user buffer, else nil.
Typically, if buffer name starts with *, it's not considered a user buffer.
This function is used by buffer switching command and close buffer command, so that next buffer shown is a user buffer.
You can override this function to get your idea of “user buffer”. Excludes *, magit, and dired.
version 2016-06-18"
  (interactive)
  (if (string-equal "*" (substring (buffer-name) 0 1))
	  nil
	(if (string-equal "magit" (substring (buffer-name) 0 5))
	nil
	  ;; NOTE: Remove below if want to include dired buffers
	  (if (string-equal major-mode "dired-mode")
	  nil
	t
	))))

(defun jj/next-emacs-buffer ()
  "Switch to the next emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
	(while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
	  (setq i (1+ i)) (next-buffer))))

(defun jj/previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
	(while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
	  (setq i (1+ i)) (previous-buffer))))

(defun jj/visible-mark-mode-enable (prefix)
  "Enable visible mark mode or with prefix disable it."
  (interactive "P")
  (visible-mark-mode 0)
  (cond ((equal prefix nil)
	 (visible-mark-mode))))
(defun jj/global-visible-mark-mode-enable (prefix)
  "Enable global visible mark mode or with prefix disable it."
  (interactive "P")
  (global-visible-mark-mode 0)
  (cond ((equal prefix nil)
	 (global-visible-mark-mode 1))))

(defcustom jj/dired-keep-marker-version ?V
  "Controls marking of versioned files.
If t, versioned files are marked if and as the corresponding original files were.
If a character, copied files are unconditionally marked with that character."
  :type '(choice (const :tag "Keep" t)
		 (character :tag "Mark"))
  :group 'dired-mark)

(defun jj/dired-version-file (from to ok-flag)
  (dired-handle-overwrite to)
  (dired-copy-file-recursive from to ok-flag dired-copy-preserve-time t
				 dired-recursive-copies))

(defun jj/dired-do-version (&optional arg)
  "Search for numeric pattern in file name and create a version of that file
with that number incremented by one, or, in case such file already exists,
will search for a file with the similar name, incrementing the counter each
time by one.
Additionally, if called with prefix argument, will prompt for number format.
The formatting is the same as is used with `format' function."
  (interactive "P")
  (let ((fn-list (dired-get-marked-files nil nil)))
	(dired-create-files
	 (function jj/dired-version-file) "Version" fn-list
	 (function
	  (lambda (from)
	(let (new-name (i 0) (fmt (if arg (read-string "Version format: " "%d") "%d")))
	  (while (or (null new-name) (file-exists-p new-name))
		(setq new-name
		  (if (string-match  "^\\([^0-9]*\\)\\([0-9]+\\)\\(.*\\)$" from)
			  (concat (match-string 1 from)
				  (format fmt
					  (+ (string-to-number (match-string 2 from)) (1+ i)))
				  (match-string 3 from))
			(concat from (format (concat "." fmt) i)))
		  i (1+ i))) new-name)))
	 jj/dired-keep-marker-version)))

(defun jj/org-refile-in-current ()
  "refile current item in current buffer"
  (interactive)
  (let ((org-refile-use-outline-path t)
	(org-refile-targets '((nil . (:maxlevel . 5)))))
	(org-refile)))

(defun jj/markdown-html (buffer)
  (princ (with-current-buffer buffer
	   (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
	 (current-buffer)))

(defun jj/markdown-github-html (buffer)
  (princ (with-current-buffer buffer
	   (format "<!DOCTYPE html><html><script src=\"https://cdnjs.cloudflare.com/ajax/libs/he/1.1.1/he.js\"></script><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/github-e6bb18b320358b77abe040d2eb46b547.css\"><link rel=\"stylesheet\" href=\"https://assets-cdn.github.com/assets/frameworks-95aff0b550d3fe338b645a4deebdcb1b.css\"><title>Impatient Markdown</title><div id=\"markdown-content\" style=\"display:none\">%s</div><div class=\"markdown-body\" style=\"max-width:968px;margin:0 auto;\"></div><script>fetch('https://api.github.com/markdown', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ \"text\": document.getElementById('markdown-content').innerHTML, \"mode\": \"gfm\", \"context\": \"knit-pk/homepage-nuxtjs\"}) }).then(response => response.text()).then(response => {document.querySelector('.markdown-body').innerHTML = he.decode(response)}).then(() => { fetch(\"https://gist.githubusercontent.com/FieryCod/b6938b29531b6ec72de25c76fa978b2c/raw/\").then(response => response.text()).then(eval)});</script></html>"
		   (buffer-substring-no-properties (point-min) (point-max))))
	 (current-buffer)))

(defun jj/markdown-github-preview-impatient-mode ()
  (interactive)
  (impatient-mode 1)
  (setq imp-user-filter #'jj/markdown-github-html)
  (cl-incf imp-last-state)
  (imp--notify-clients))

(defun jj/markdown-preview-impatient-mode ()
  (interactive)
  (impatient-mode 1)
  (setq imp-user-filter #'jj/markdown-html)
  (cl-incf imp-last-state)
  (imp--notify-clients))

(defun jj/markdown-preview-impatient-mode-httpd-start ()
  (interactive)
  (httpd-start)
  (impatient-mode 1)
  (setq imp-user-filter #'jj/markdown-html)
  (cl-incf imp-last-state)
  (imp--notify-clients))

(defun jj/markdown-preview-impatient-mode-httpd-stop ()
  (interactive)
  (impatient-mode 0)
  (httpd-stop))

(defun jj/grip-mode-disable ()
  (interactive)
  (grip-mode 0))

(defun jj/my-setup-odt-org-convert-process-to-docx ()
  (interactive)
  (let ((cmd "/Applications/LibreOffice.app/Contents/MacOS/soffice"))
	(when (and (eq system-type 'darwin) (file-exists-p cmd))
	  ;; org v7
	  (setq org-export-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i")))
	  ;; org v8
	  (setq org-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i"))))
	))

(defun jj/counsel-rg-ignore-tests-swiper ()
  (interactive)
  (let ((search-str (ivy--input)))
	(ivy-quit-and-run
	  (counsel-rg search-str (projectile-project-root) "--iglob '!test*'"))))

(defun jj/counsel-rg-swiper ()
  (interactive)
  (let ((search-str (ivy--input)))
	(ivy-quit-and-run
	  (counsel-rg search-str (projectile-project-root) ""))))

(defun jj/counsel-rg-ignore-tests ()
  (interactive)
  (let ((search-str (ivy--input)))
	(ivy-quit-and-run
	  (counsel-rg "" (projectile-project-root) "--iglob '!test*'"))))

;; TODO: Add to preload.el so loads properly
;; https://github.com/jkitchin/scimax/issues/312
(defun jj/org-ob-babel-reset-scimax-bindings ()
  "Reset scimax bindings for org-babel so doesn't override my bindings."
  ;; My defined bindings get overridden so set to nil then redefine
  (interactive)
  (scimax-define-src-key ipython "s-<return>" #'nil)
  (scimax-define-src-key ipython "s" #'nil)
  (scimax-define-src-key ipython "M-s-<return>" #'nil)
  (scimax-define-src-key ipython "s-k" #'nil)
  (scimax-define-src-key ipython "s-K" #'nil)
  (scimax-define-src-key ipython "s-s" #'nil)
  ;; (scimax-define-src-key ipython "s-w" #'nil)
  ;; ("s-<return>" . #'scimax-ob-ipython-restart-kernel-execute-block)
  ;; ("M-s-<return>" . #'scimax-restart-ipython-and-execute-to-point)
  ;; ("s-i" . #'org-babel-previous-src-block)
  ;; ("s-k" . #'org-babel-next-src-block)
  ;; ("s-w" . #'scimax-ob-move-src-block-up)
  ;; ("s-s" . #'scimax-ob-move-src-block-down)
  (scimax-define-src-key ipython "C-s-n" #'org-babel-next-src-block)
  (scimax-define-src-key ipython "C-s-p" #'org-babel-previous-src-block))

(defun jj/goto-last-change-reverse ()
  "Fix goto-last-change-reverse code that doesn't work properly"
  (interactive)
  ;; Make 'goto-last-change-reverse' look like 'goto-last-change'
  (cond ((eq last-command this-command)
	 (setq last-command 'goto-last-change)))
  (setq this-command 'goto-last-change)
  ;; FIXME: Fix so can pass in any number of previous argument
  (goto-last-change '-1))

(defun jj/goto-last-change-back-to-first ()
  "Fix goto-last-change-reverse code that doesn't work properly"
  (interactive)
  (goto-last-change 1))

(defun jj/beginning-or-indentation-or-previous-line (&optional n)
  "Move cursor to beginning of this line or to its indentation. If at indentation position of this line, move to beginning of line.
  If at beginning of line, move to beginning of previous line.
  Else, move to indentation position of this line.
  With arg N, move backward to the beginning of the Nth previous line.
  Interactively, N is the prefix arg."
  (interactive "P")
  (cond ((or (bolp) n)
	 (forward-line (- (prefix-numeric-value n))))
	((save-excursion (skip-chars-backward " \t") (bolp)) ; At indentation.
	 (forward-line 0))
	(t (back-to-indentation))))

(defun jj/beginning-or-indentation-of-visual-line ()
  (interactive)
  (let ((pos (point))
	(indent (save-excursion
		  (beginning-of-visual-line)
		  (skip-chars-forward " \t\r")
		  (point))))
	(cond ((or (> pos indent) (= pos (line-beginning-position)))
	   (goto-char indent))
	  ((<= pos indent)
	   (beginning-of-visual-line)))))

(defun jj/beginning-or-indentation-of-visual-line-then-back-to-indentation-whole-line ()
  (interactive)
  (let ((pos (point))
	(indent (save-excursion
		  (beginning-of-visual-line)
		  (skip-chars-forward " \t\r")
		  (point)))
	(beg-vl (save-excursion
		  (beginning-of-visual-line)
		  (point))))
	(cond ((> pos indent)
	   (goto-char indent))
	  ((= pos beg-vl)
	   (back-to-indentation))
	  ((<= pos indent)
	   (beginning-of-visual-line)))))

(defun jj/lispy-move-beginning-of-visual-line ()
  "Forward to `move-beginning-of-line'.
Reveal outlines."
  (interactive)
  (lispy--ensure-visible)
  (jj/beginning-or-indentation-of-visual-line-then-back-to-indentation-whole-line))

(defun jj/org-beginning-of-line (&optional n)
  "Go to the beginning of the current visible line.

If this is a headline, and `org-special-ctrl-a/e' is not nil or
symbol `reversed', on the first attempt move to where the
headline text starts, and only move to beginning of line when the
cursor is already before the start of the text of the headline.

If `org-special-ctrl-a/e' is symbol `reversed' then go to the
start of the text on the second attempt.

With argument N not nil or 1, move forward N - 1 lines first."
  (interactive "^p")
  (let ((pos (point))
	(beg-l (save-excursion
		 (beginning-of-line)
		 (point)))
	(beg-vl (save-excursion
		  (beginning-of-visual-line)
		  (point))))
	(cond ((and (= pos beg-vl) (not (= beg-vl beg-l)))
	   ;; NOTE: Could change this to always go to beginning of line then call org-beginning-of-line again to go after the *** or 1.
	   (org-end-of-line)
	   (previous-line)
	   (org-beginning-of-line n))
	  (t
	   (org-beginning-of-line n)))))

(defun jj/end-of-visual-line-then-to-end-of-line (&optional n)
  (interactive "^p")
  (let ((pos (point))
	(end (save-excursion
		   (end-of-line)
		   (point)))
	(end-vl (save-excursion
		  (end-of-visual-line)
		  (point))))
	(cond ((= pos end-vl)
	   (end-of-line n))
	  (t
	   (end-of-visual-line n)))))

(defun jj/org-end-of-line (&optional n)
  "Go to the end of the line, but before ellipsis, if any.

If this is a headline, and `org-special-ctrl-a/e' is not nil or
symbol `reversed', ignore tags on the first attempt, and only
move to after the tags when the cursor is already beyond the end
of the headline.

If `org-special-ctrl-a/e' is symbol `reversed' then ignore tags
on the second attempt.

With argument N not nil or 1, move forward N - 1 lines first."
  (interactive "^p")
  (let ((pos (point))
	(end (save-excursion
		   (end-of-line)
		   (point)))
	(end-vl (save-excursion
		  (end-of-visual-line)
		  (point))))
	(cond ((and (= pos end-vl) (not (= end-vl end)))
	   ;; NOTE: Could change this to always go to beginning of line then call org-beginning-of-line again to go after the *** or 1.
	   (org-beginning-of-line)
	   (next-line)
	   (org-end-of-line n))
	  (t
	   (org-end-of-line n)))))

;; TODO: Make this work when in a sub-directory (also d-comp
(defun jj/dired-do-compress-marked-files-to-zip (zip-file)
  "Create a zip archive containing the marked files. Won't work when in a subdirectory."
  (interactive "sEnter name of zip file: ")

  ;; create the zip file
  (let ((zip-file (if (string-match ".zip$" zip-file) zip-file (concat zip-file ".zip"))))
	(shell-command
	 (concat "zip "
		 zip-file
		 " "
		 (string-join
		  (mapcar
		   '(lambda (filename)
		  (file-name-nondirectory filename))
		   (dired-get-marked-files)) " "))))
  (revert-buffer))

(defun jj/whitespace-cleanup ()
  "Turn off ws-butler-mode before running whitespace-cleanup."
  (interactive)
  (ws-butler-mode 0)
  (whitespace-cleanup))

(defalias 'jj/ws-butler-mode-off-whitespace-cleanup 'jj/whitespace-cleanup)

(defun jj/kill-current-buffer-and-window ()
  "Kill the current buffer and then kill the window."
  (interactive)
  (kill-current-buffer)
  (delete-window))

(defun jj/set-key-to-nil ()
  "Display a message because will change this key, but the muscle memory is still there."
  (interactive)
  (message "Don't use this key anymore!!"))

(defun jj/dired-ranger-reset-copy-ring ()
  "Reset the `dired-ranger-copy-ring` to nil."
  (interactive)
  (when (require 'dired-ranger nil 'noerror)
	(setq dired-ranger-copy-ring (make-ring dired-ranger-copy-ring-size))))

(defun jj/dired-copy-filename-as-kill-absolute-path ()
  "Kill the files marked passing in the 0 argument for absolute path to `dired-copy-filename-as-kill`"
  (interactive)
  (dired-copy-filename-as-kill 0))

(defun jj/delete-blank-lines ()
  "Removes all blank lines from buffer or region"
  (interactive)
  (save-excursion
	(let (min max)
	  (if (equal (region-active-p) nil)
		  (mark-whole-buffer))
	  (setq min (region-beginning) max (region-end))
	  (flush-lines "^ *$" min max t))))

(defun jj/collapse-blank-lines ()
  "Collapse multiple blank lines from buffer or region into a single blank line"
  (interactive)
  (save-excursion
	(let (min max)
	  (if (equal (region-active-p) nil)
		  (mark-whole-buffer))
	  (setq min (region-beginning) max (region-end))
	  (replace-regexp "^\n\\{2,\\}" "\n" nil min max))))

(defun jj/collapse-blank-lines-query ()
  "Collapse multiple blank lines from buffer or region into a single blank line"
  (interactive)
  (save-excursion
	(let (min max)
	  (if (equal (region-active-p) nil)
		  (mark-whole-buffer))
	  (setq min (region-beginning) max (region-end))
	  (query-replace-regexp "^\n\\{2,\\}" "\n" nil min max))))

(defun jj/load-theme-sanityinc-tomorrow-eighties ()
  "Delete all themes, load theme eighties, setup smart-mode-line, and set the mode-line font"
  (interactive)
  (when (display-graphic-p)
	(set-face-attribute 'minibuffer-prompt nil :foreground nil :background nil)
	(counsel-load-theme-action nil)
	(load-theme 'sanityinc-tomorrow-eighties t)
	(sml/setup)
	(sml/apply-theme 'dark)
	(jj/sml/total-lines-append-mode-line)
	;; Made font to try to match magenta in sublime
	(set-face-attribute 'font-lock-keyword-face nil :foreground "#80E021")
	;; (set-face-attribute 'font-lock-string-face nil :foreground "#59D3DB")
	(set-face-attribute 'font-lock-string-face nil :foreground "#55CDD5")
	(set-face-attribute 'font-lock-constant-face nil :foreground "#A16DEA")
	(set-face-attribute 'font-lock-type-face nil :foreground "#8490FF")
	;; TODO: Check if this is still working
	(set-face-attribute 'Man-overstrike nil :inherit 'bold :foreground "firebrick3")
	(set-face-attribute 'Man-underline nil :inherit 'underline :foreground "green3")
	;; (set-face-attribute 'font-python-builtin-face nil :foreground "#F26FC1")
	(eval-after-load "font-latex"
	  '(progn
		 (font-latex-update-sectioning-faces)
		 (set-face-attribute 'font-latex-sedate-face nil :foreground "#38CAD4")
		 (set-face-attribute 'font-latex-string-face nil :foreground "#B1B8F4")
		 (set-face-attribute 'font-latex-bold-face nil :foreground "#B1CFB1" :bold t)
		 (set-face-attribute 'font-latex-italic-face nil :foreground "#C3E4C3" :italic t)
		 (set-face-attribute 'font-latex-sectioning-1-face nil :foreground "#E7D7B5"  :bold t)
		 (set-face-attribute 'font-latex-sectioning-2-face nil :foreground "#E7D7B5"  :bold t)
		 (set-face-attribute 'font-latex-sectioning-3-face nil :foreground "#E7D7B5"  :bold t)
		 (set-face-attribute 'font-latex-sectioning-4-face nil :foreground "#E7D7B5"  :bold t)
		 (set-face-attribute 'font-latex-sectioning-5-face nil :foreground "#E7D7B5"  :bold t)
		 ;; Original math-face below
		 ;; (set-face-attribute 'font-latex-math-face nil :foreground "#cc99cc")
		 ))
	(add-hook 'LaTeX-mode-hook
			  (lambda ()
				;; TODO: Doesn't work because this text set to two text properties...
				;; (font-lock-keyword-face font-latex-sedate-face) so post to stacko
				(make-face 'font-latex-keyword-face)
				(set-face-attribute 'font-latex-keyword-face nil :foreground "#ee30a7")
				(set (make-local-variable 'font-lock-keyword-face) 'font-latex-keyword-face)))
	(set-face-attribute 'dired-marked nil :foreground "white" :background "cc0000" :bold t)
	(make-face 'font-python-builtin-face)
	(set-face-attribute 'font-python-builtin-face nil :foreground "#5CD3DB")
	(make-face 'font-python-keyword-face)
	(set-face-attribute 'font-python-keyword-face nil :foreground "#ee30a7" :italic t)
	(make-face 'font-python-keyword-face-no-italic)
	(set-face-attribute 'font-python-keyword-face-no-italic nil :foreground "#ee30a7")
	(make-face 'font-python-constant-face)
	(set-face-attribute 'font-python-constant-face nil :foreground "#A56EF2")
	(make-face 'font-python-function-name-face)
	(set-face-attribute 'font-python-function-name-face nil :foreground "#8BEA2E")
	(make-face 'font-python-type-face)
	(set-face-attribute 'font-python-type-face nil :foreground "#5CD3DB" :bold t :height 1.0)
	(add-hook 'python-mode-hook
			  (lambda ()
				;; More editing can be done to change specific keywords using the link below
				;; https://emacs.stackexchange.com/questions/33675/python-mode-custom-syntax-highlighting
				(highlight-numbers-mode)
				(set-face-attribute 'highlight-numbers-number nil :foreground "#A56EF2")
				(set (make-local-variable 'font-lock-function-name-face) 'font-python-function-name-face)
				(set (make-local-variable 'font-lock-keyword-face) 'font-python-keyword-face)
				(set (make-local-variable 'font-lock-string-face) 'font-lock-variable-name-face)
				(set (make-local-variable 'font-lock-variable-name-face) 'font-lock-function-name-face)
				(set (make-local-variable 'font-lock-builtin-face) 'font-python-builtin-face)
				(set (make-local-variable 'font-lock-constant-face) 'font-python-constant-face)
				(set (make-local-variable 'highlight-numbers-number) 'font-python-constant-face)
				(set (make-local-variable 'font-lock-type-face) 'font-python-type-face)
				))
	(set-face-attribute 'org-block nil :background "gray16")
	(set-face-attribute 'org-block-python nil :background "gray16")
	(set-face-attribute 'org-block-ipython nil :background "gray16")
	;; (set-face-attribute 'org-block-python nil :background "gray19")
	(set-face-attribute 'org-block-begin-line nil :background "#420C0C")
	(set-face-attribute 'org-block-begin-line nil :background "#814545" :foreground "#E5E5E5")
	(set-face-attribute 'secondary-selection nil :foreground nil :background "#2E22A6")
	;; (set-face-attribute 'secondary-selection nil :foreground nil :background "#4d2092")
	(set-face-attribute 'helm-selection nil :foreground nil :background "#2E22A6")
	(setq beacon-color "#B194CB")
	;; (set-face-attribute 'secondary-selection nil :foreground nil :background "#4d4d4d")
	(set-face-attribute 'org-level-1 nil :background "#A9C5FF" :foreground "#213974" :bold t :height 1.3 :box t :overline t)
	(set-face-attribute 'org-level-2 nil :background "#BF95D8" :foreground "#551A78" :bold t :height 1.1 :box t :overline t)
	(set-face-attribute 'org-level-3 nil :foreground "#66cccc" :bold t :overline t)
	(set-face-attribute 'org-latex-and-related nil :foreground "SkyBlue1")
	(eval-after-load "markdown-mode"
	  '(progn
		 ;; (set-face-attribute 'markdown-header-face-1 nil :foreground "#f99157" :height 1.2)
		 (set-face-attribute 'markdown-header-delimiter-face nil :inherit 'markdown-markup-face :foreground "Tomato3" :height 1.1 :bold t)
		 ;; Default value below (shadow color)
		 ;; (set-face-attribute 'markdown-header-delimiter-face nil :inherit 'markdown-markup-face :foreground nil)
		 ))
	(set-face-attribute 'org-verbatim nil :foreground "SkyBlue1")
	(set-face-attribute 'org-code nil :foreground "SpringGreen3")
	(set-face-attribute 'org-todo nil :foreground "brown1" :background "dark red" :box t)
	(set-face-attribute 'org-done nil :foreground "SpringGreen3" :background "dark green" :box t)
	(setq org-src-block-faces '(("emacs-lisp" (:background "#EEE2FF"))
								("python" (:background "#4d2092"))))
	(set-face-attribute 'font-lock-comment-delimiter-face nil :foreground "gray53")
	(set-face-attribute 'font-lock-comment-face nil :foreground "gray49")
	(set-face-attribute 'dired-ignored nil :foreground "#ff3300" :background nil :strike-through t)
	(set-face-attribute 'dired-flagged nil :foreground "#ff3300" :background nil)
	(set-face-attribute 'dired-warning nil :foreground "#ff3300" :background nil :bold t)
	(set-face-attribute 'dired-symlink nil :foreground "#47d147" :background nil :bold nil)
	(set-face-attribute 'dired-header nil :foreground "ice" :background "#272727" :bold t)
	(set-face-attribute 'dired-directory nil :foreground "ice" :background "#282828" :bold t)
	(set-face-attribute 'dired-marked nil :foreground "white" :background "#cc0000" :bold t)
	(set-face-attribute 'dired-mark nil :foreground "white" :background "#cc0000" :bold t)
	(set-face-attribute 'dired-flagged nil :foreground "#ff3300" :background nil)
	;; (set-face-attribute 'dired-directory nil :foreground "ice" :background nil :bold t)
	(eval-after-load "dired+"
	  '(progn
		 (set-face-attribute 'diredp-symlink nil :foreground "#47d147" :background nil :bold nil)
		 (set-face-attribute 'diredp-dir-name nil :foreground "ice" :background "#282828" :bold t)
		 (set-face-attribute 'diredp-dir-heading nil :foreground "ice" :background "#272727" :bold t)
		 (set-face-attribute 'diredp-ignored-file-name nil :foreground "#ff3300" :background nil :strike-through t)
		 (set-face-attribute 'diredp-omit-file-name nil :foreground "salmon"  :italic t :box t :strike-through nil)
		 (set-face-attribute 'diredp-flag-mark-line nil :foreground "white" :background "#cc0000" :bold t)
		 (set-face-attribute 'diredp-flag-mark nil :foreground "white" :background "#cc0000" :bold t)
		 (set-face-attribute 'diredp-compressed-file-suffix nil :foreground "#F5DAA1")
		 (set-face-attribute 'diredp-executable-tag nil :foreground "#A16DEA" :bold t)
		 (set-face-attribute 'diredp-exec-priv nil :foreground "#AD6FD6" :italic t :bold t)
		 (set-face-attribute 'diredp-read-priv nil :foreground "#E37E54")
		 (set-face-attribute 'diredp-write-priv nil :foreground "#5A95DC" :bold t)
		 (set-face-attribute 'diredp-no-priv nil :foreground "white")
		 (set-face-attribute 'diredp-dir-priv nil :foreground "white")
		 (set-face-attribute 'diredp-date-time nil :foreground "#DCDCC6")
		 (set-face-attribute 'diredp-mode-line-flagged nil :foreground "#ff3300" :background nil)
		 (set-face-attribute 'diredp-mode-line-marked nil :foreground "white" :background "#cc0000" :bold t)
		 (set-face-attribute 'diredp-number nil :foreground "#ACB2E4")
		 (set-face-attribute 'diredp-compressed-file-name nil :foreground "#F5DAA1")
		 (set-face-attribute 'diredp-deletion-file-name nil :foreground "#ff3300" :background nil)
		 (set-face-attribute 'diredp-deletion nil :foreground "#ff3300" :background nil)
		 ))
	;; NOTE: if you set a foreground color overwrites all font colors. Value is inherited from show-paren-match
	(set-face-attribute 'show-paren-match-expression nil :foreground nil :background "#592136")
	;; Color of top one is magenta and pink
	;; (set-face-attribute 'show-paren-match nil :foreground nil :background "#E769E7")
	(set-face-attribute 'show-paren-match nil :foreground nil :background "#C3025B")
	(make-face 'font-ibuffer-marked-face)
	(set-face-attribute 'font-ibuffer-marked-face nil :foreground "white" :background "cc0000" :bold t)
	(make-face 'font-ibuffer-deletion-face)
	(set-face-attribute 'font-ibuffer-deletion-face nil :foreground "#ff3300" :background nil)
	(setq ibuffer-marked-face 'font-ibuffer-marked-face)
	(setq ibuffer-deletion-face 'font-ibuffer-deletion-face)
	(jj/dark-theme-set-visible-mark-faces)
	(set-face-attribute 'mode-line nil :font "Lucida Grande-13")))
