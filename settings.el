;; -*- mode: Emacs-Lisp -*-
;; Set the font sizesS
(setq-default line-spacing 0.17)
;; (setq-default indent-tabs-mode nil)
;; Or set the below in hooks for major modes
;; (setq indent-tabs-mode nil)
;; (jj/infer-indentation-style)
;; should start putting double spaces after periods so don't need this command
;; sentence-navigation replaced forward backward but still used for kills
(setq sentence-end-double-space nil)
(setq recentf-max-menu-items 20)
(setq recentf-max-saved-items nil)
(setq history-length 750)
(setq helm-ff-history-max-length 500)
(setq ivy-dired-history-max 999)
(setq helm-dired-history-max 999)
(setq buffers-menu-max-size 20)
(setq kill-whole-line t)
(setq kill-read-only-ok t)
(setq-default tab-width 4)
(setq column-number-mode t)
(setq ns-auto-hide-menu-bar t)
(if (featurep 'scroll-bar) (toggle-scroll-bar -1))
(setq mark-ring-max 32)
(setq global-mark-ring-max 6)
(setq set-mark-command-repeat-pop t)
(setq winner-ring-size 500)
;; (add-to-list 'savehist-additional-variables 'winner-ring-alist)
;; (setq winner-dont-bind-my-keys t)
(setq enable-recursive-minibuffers t)
(setq inferior-lisp-program "/usr/local/bin/sbcl")
;; Removed slime so don't need the following line
;; (setq slime-contribs '(slime-fancy))

(setq recentf-save-file (expand-file-name "~/Programs/scimax/user/recentf"))
;; (run-with-timer (* 60 60) (* 60 60) 'recentf-save-list)
(setq recentf-exclude (append recentf-exclude  '(".*projectile-bookmarks.eld$" ".*user/recentf$" ".*user/history$" ".*user/abbrev_defs$" ".*user/ac-comphist.dat$" ".*user/bookmarks$" ".*mp3$" ".*mp4$" ".*elc$" ".*\\.el\\.gz$" ".*mkv$" ".*avi$" ".*wmv$" ".*dmg$" ".*pkg$" ".*png$" ".*\\.r[0-9a][0-9r]" ".*/FinishedTor/.*$" ".*/To_Delete/K/.*$" ".*/scimax/elpa/.*$")))
;; ".*\\.pdf$"
;; disable recentf-cleanup on Emacs start, because it can cause
;; problems with remote files
;; (recentf-auto-cleanup 'never)

;; Possibly use this if using network filed systems because checks every file on emacs exit
;; (setq save-place-forget-unreadable-files nil)
;; (setq save-place-file (locate-user-emacs-file "places" ".emacs-places"))
(setq save-place-limit 2000)
(setq save-place-ignore-files-regexp "\\(?:COMMIT_EDITMSG\\|hg-editor-[[:alnum:]]+\\.txt\\|svn-commit\\.tmp\\|recentf\\|bzr_log\\.[[:alnum:]]+\\)$")

;; (run-with-timer (* 60 120) (* 60 120) 'save-place-alist-to-file)
(defvar save-place-timer nil)
;; removed because added save-place-alist to savehist
;; Don't need this since have the timer above but if added savehist
;; has to be loaded after save-place=mode so the variable loaded in later
;; (add-to-list 'savehist-additional-variables 'save-place-alist)
(save-place-mode 1)
;; untitled~~.tmp files will open into text-mode (
(add-to-list 'auto-mode-alist '("\\.qqq\\'" . text-mode))
;; symlinks under version control are followed to there real directory
;; only necessary if using emacs for controlling git (possibly remove later)
(setq vc-follow-symlinks t)
;; Can use but post command hooks can't be expensive operations
;; (defun vc-state-refresh-post-command-hook ()
;;   "Check if command in `this-command' was executed, then run `vc-refresh-state'"
;;   (when (memq this-command '(other-window kill-buffer ido-kill-buffer ido-switch-buffer))
;;     (vc-refresh-state)))
;; (add-hook 'post-command-hook #'vc-state-refresh-post-command-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo Tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; setup later undo info
;; (setq undo-tree-auto-save-history t)
;; (setq undo-tree-history-directory-alist
;;       (quote (("" . "~/.local/var/emacs/undo_hist"))))
(setq undo-outer-limit (* 1024 1024 10))
(setq undo-strong-limit (* 1024 1024 6))
(setq undo-limit (* 1024 1024 5))
;; (with-eval-after-load "volatile-highlights-autoloads"
;;   (volatile-highlights-mode 1))

;; ;; Treat undo history as a tree.
;; (with-eval-after-load "undo-tree-autoloads"

;;   ;; Enable Global-Undo-Tree mode.
;;   (global-undo-tree-mode 1))

;; (with-eval-after-load "undo-tree"

;;   (with-eval-after-load "diminish-autoloads"
;;     (diminish 'undo-tree-mode))

;;   ;; Display times relative to current time in visualizer.
;;   (setq undo-tree-visualizer-relative-timestamps t)

;;   ;; Display time-stamps by default in undo-tree visualizer.
;;   (setq undo-tree-visualizer-timestamps t)
;;					; Toggle time-stamps display using `t'.

;;   ;; Display diff by default in undo-tree visualizer.
;;   (setq undo-tree-visualizer-diff t)  ; Toggle the diff display using `d'.

;;   (define-key undo-tree-map (kbd "C-/") nil)

;;   ;; (defalias 'redo 'undo-tree-redo)
;;   (global-set-key (kbd "C-S-z") #'undo-tree-redo)
;;   (global-set-key (kbd "<S-f11>") #'undo-tree-redo))

;; )                                       ; Chapter 7 ends here.

;; Look at adding
;; (defadvice undo-tree-make-history-save-file-name
;;     (after undo-tree activate)
;;   (setq ad-return-value (concat ad-return-value ".gz")))

;;; Shut up compile saves
(setq compilation-ask-about-save nil)

;; Fix minor mode lines that not useful
(setq beacon-lighter nil)		; beacon-mode
(setq back-button-mode-lighter nil)	; back-button-mode
(setq google-this-modeline-indicator nil) ;google-this-mode
;; couldn't figure out how to change lighter of emacs-lock-mode
(eval-after-load 'whitespace-cleanup-mode
  '(progn
	 (defun whitespace-cleanup-mode-mode-line ()
	   "Return a string for mode-line.
Use '!' to signify that the buffer was not initially clean."
	   (concat " WS"
		   (unless whitespace-cleanup-mode-initially-clean
		 "!")))))

(when (eq system-type 'darwin)
  (osx-trash-setup))
(setq delete-by-moving-to-trash t)
;; This doesn't work for Chrome but will work for safari
(setq osx-browse-prefer-background 'background)
;; For google this possibly set this and figure out how to make it run in the background
;; (setq google-this-browse-url-function 'osx-browse-url-safari)
(setq counsel-grep-base-command "grep -E -n -i -e %s %s")
;; Use to make the ivy-directories in buffer switch use full paths
;; (setq ivy-virtual-abbreviate 'full)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ivy and Counsel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ivy-use-virtual-buffers nil)
(setq ivy-height 14)
(ivy-set-actions
 'ivy-switch-buffer
 '(("k"
	(lambda (x)
	  (jj/ivy-kill-buffer x)
	  (ivy--reset-state ivy-last))
	"kill"
	)))

(setq ivy-initial-inputs-alist
	  '((org-refile . "")
	(org-agenda-refile . "^")
	(org-capture-refile . "^")
	(counsel-M-x . "")
	(counsel-describe-function . "")
	(counsel-describe-variable . "")
	(counsel-org-capture . "^")
	(Man-completion-table . "^")
	(woman . "^")))

(setq ivy-re-builders-alist
	  '((counsel-bookmark . ivy--regex-fuzzy)
	(counsel-bookmarked-directory . ivy--regex-fuzzy)
	(swiper      . ivy--regex-ignore-order)
	(counsel-recentf      . ivy--regex-plus)
	(counsel-locate      . ivy--regex-ignore-order)
	(counsel-describe-function      . ivy--regex-fuzzy)
	(counsel-find-file      . ivy--regex-fuzzy)
	(counsel-apropos      . ivy--regex-fuzzy)
	(counsel-descbinds      . ivy--regex-fuzzy)
	(counsel-info-lookup-symbol      . ivy--regex-fuzzy)
	(counsel-describe-variable      . ivy--regex-fuzzy)
	(counsel-load-library      . ivy--regex-fuzzy)
	(counsel-package      . ivy--regex-fuzzy)
	(counsel-M-x      . ivy--regex-fuzzy)
	(swiper-all      . ivy--regex-ignore-order)
	(dired-goto-file      . ivy--regex-plus)
	(counsel-git-grep      . ivy--regex-ignore-order)
	(swiper-multi      . ivy--regex-ignore-order)
	(counsel-org-goto      . ivy--regex-fuzzy)
	(counsel-org-goto-all      . ivy--regex-fuzzy)
	(counsel-grep-or-swiper      . ivy--regex-ignore-order)
	(jj/counsel-find-name-everything      . ivy--regex-ignore-order)
	(t      . ivy--regex-ignore-order)))
(add-to-list 'ivy-sort-functions-alist
		 '(read-file-name-internal . jj/ivy-sort-file-function))
;; (add-to-list 'ivy-sort-functions-alist
;;              '(read-file-name-internal . jj/ivy-sort-file-by-mtime))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Whitespace mode and ws-butler settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: Write change major-mode hook that if whitespace cleanup mode activated calls before changing
;; TODO: write mode hooks using the DEPTH attribute so can load after or before
;; hook needs to be run before whitespace-cleanup-mode hook so that is loaded first
(add-hook 'prog-mode-hook 'jj/ws-butler-mode-if-whitespace-initially-not-clean)
(add-hook 'org-mode-hook 'jj/ws-butler-mode-if-whitespace-initially-not-clean)
;; (global-whitespace-cleanup-mode)
;; modes to ignore for whitespace-cleanup-mode (useful when global-whtespace-cleanup-mode enabled)
;;
(dolist (hook '(prog-mode-hook text-mode-hook latex-mode-hook ...))
  (add-hook hook (lambda ()
		   (whitespace-cleanup-mode))))
(add-hook 'markdown-mode-hook
	  (lambda () (whitespace-cleanup-mode 0)))
(eval-after-load 'whitespace-cleanup-mode
  '(setq whitespace-cleanup-mode-ignore-modes
	 (nconc '(markdown-mode dired-mode fundamental-mode image-mode doc-view-mode archive-mode tar-mode)
		whitespace-cleanup-mode-ignore-modes)))

(add-hook 'prog-mode-hook 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'dtrt-indent-mode)
;; if using semantic might need this (removes print on opening buffer)
;; (setq dtrt-indent-verbosity 0)

;; Turn on flycheck mode to validate json and add settings
(eval-after-load "json-mode"
  '(progn
	 (add-hook 'json-mode-hook #'flycheck-mode)
	 (define-key json-mode-map "\C-c\C-n" (function flycheck-next-error))
	 (define-key json-mode-map "\C-cn" (function flycheck-previous-error))
	 (define-key json-mode-map "\C-c\C-l" (function flycheck-list-errors))
	 ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Diminish mode line settins and cyphejor mode-line settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: Replace diminish with delight (https://www.emacswiki.org/emacs/DelightedModes)
;; (don't need to call eval-after-load) also supports major-modes
;;
;; use diminish to change minor-mode line or with no argument deletes it
;; can also be used to change major-mode lines
;; (eval-after-load "dubcaps" '(diminish 'dubcaps-mode))
(eval-after-load 'emacs-lock-mode '(diminish 'org-indent-mode))
(eval-after-load "dired-filter" '(diminish 'dired-filter-mode "Filt"))
(eval-after-load "org-src" '(diminish 'org-src-mode "Ωsrc"))
(eval-after-load "dired-x" '(diminish 'dired-omit-mode "Omt"))
(eval-after-load "flycheck" '(diminish 'flycheck-mode "FC"))
(eval-after-load "flyspell" '(diminish 'flyspell-mode "FS"))
(eval-after-load "org-indent" '(diminish 'org-indent-mode ))
(eval-after-load "ws-butler" '(diminish 'ws-butler-mode " WB"))
(eval-after-load "dtrt-indent" '(diminish 'dtrt-indent-mode ""))
(add-hook 'dired-mode-hook (lambda ()
				 (eval-after-load "dired-x" '(diminish 'dired-omit-mode " Om"))))
(eval-after-load "dired-filter" '(diminish 'dired-filter-mode "Filt"))
(eval-after-load "dired-narrow" '(diminish 'dired-narrow-mode "Nrw"))
(eval-after-load "elpy" '(diminish 'elpy-mode " El"))
(eval-after-load "autorevert" '(progn (setq auto-revert-mode-text " AR")))
(eval-after-load "emacs-lock" '(diminish 'emacs-lock-mode
					 `("" (emacs-lock--try-unlocking " l:" " L:")
					   (:eval (substring (symbol-name emacs-lock-mode) 0 1) ))))
(setq
 cyphejor-rules
 '(
   ;; supposed to replace first letter to Upper but doesn't work
   ;; :upcase-replace    ; change to :upcase for just first letter of major-mode
   ("bookmark"    "→")
   ("buffer"      "β")
   ("diff"        "Δ")
   ("emacs"       "∃")
   ("fundamental" "Ⓕ")
   ("inferior"    "i" :prefix)
   ("interaction" "i" :prefix)
   ("interactive" "i" :prefix)
   ("lisp"        "λ" :postfix)
   ("menu"        "▤" :postfix)
   ("mode"        "")
   ("markdown"        "M")
   ("gfm"        "MG")
   ("package"     "↓")
   ("python"      "π")			;Ƥ
   ("org"      "Ω")			;Ⓞ
   ("org-agenda"      "ΩA")			;Ⓞ
   ("shell"       "sh" :postfix)
   ("help"       "Ήϵ")
   ("dired"       "Ɖ")			;Ⓓ
   ("text"        "Ŧ")
   ("wdired"      "𝓦Ɖ")))
(cyphejor-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'html-mode-hook (lambda () (setq-local tab-width 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setenv "WORKON_HOME" (expand-file-name "~/anaconda/envs"))
;; TODO: Switch to jupyter if bug fixed: https://github.com/jorgenschaefer/elpy/issues/1550
(setq python-shell-interpreter "ipython"
	  python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(add-hook 'elpy-mode-hook 'jj/flycheck-mode-python-setup)
(defun jj/flycheck-mode-python-setup ()
  "Custom behaviours of flycheck mode for `python-mode'."
  (setq-local flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))
  (setq-local flycheck-idle-change-delay 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Latex and Tex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scale height of section commands by 1.2
(setq font-latex-fontify-sectioning 1.2)
;; don't query user to save on running latex commands
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)
(setq TeX-source-correlate-mode t)
(setq TeX-clean-confirm t)
;; (setq TeX-source-correlate-method 'synctex)
;; Maybe change to ask then ask about allowing inverse search
(setq TeX-source-correlate-start-server nil)
(eval-after-load "tex"
  '(progn
	 ;; adding command options -b before -g below will highlight the line number in skim
	 (add-to-list 'TeX-command-list '("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -r -g %n %o %b" TeX-run-TeX nil t))
	 (add-to-list 'TeX-command-list '("latexmk" "latexmk -pdf -r ~/Programs/scimax/user/latexmkrc %s"  TeX-run-TeX nil t :help "Run latexmk on file then output to skim"))
	 (add-to-list 'TeX-command-list
		  '("Xelatexnonstop" "xelatex -no-pdf -synctex=1 -interaction=nonstopmode %s"
			TeX-run-command t t :help "Run xelatex"))

	 (add-to-list 'TeX-command-list '("Xelatex" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
	 (add-to-list 'TeX-command-list '("Xelatexmk" "latexmk -xelatex -pdfxe -r ~/Programs/scimax/user/latexmkrc %s"  TeX-run-TeX nil t :help "Run xelatexmk on file then output to skim"))
	 (add-to-list 'TeX-command-list
		  '("Lualatexnonstop" "lualatex -synctex=1 -interaction=nonstopmode %s"
			TeX-run-command t t :help "Run xelatex"))
	 (add-to-list 'TeX-command-list '("Lualatexmk" "latexmk -lualatex -pdflua -r ~/Programs/scimax/user/latexmkrc %s"  TeX-run-TeX nil t :help "Run Lualatexmk on file then output to skim"))
	 (setq TeX-view-program-selection '((output-pdf "Skim")))
	 (setq TeX-view-program-list '(("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -r -g %n %o %b")))
	 (setq-default TeX-command-default "latexmk")
	 (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
	 )
  )
;; Sample `latexmkrc` for OSX that copies the *.pdf file from the `/tmp` directory
;; to the working directory:
;;    $pdflatex = 'pdflatex -file-line-error -synctex=1 %O %S && (cp "%D" "%R.pdf")';
;;    $pdf_mode = 1;
;;    $out_dir = '/tmp';"
;; ;; The below didn't work for some reason
;; (eval-after-load
;;     "tex"
;;   '(progn
;;      (add-to-list 'TeX-view-predicate-list-builtin '(output-pdf t))
;;      (add-to-list 'TeX-expand-list '("%(tex-file-name)" (lambda () (concat "\"" (with-current-buffer TeX-command-buffer buffer-file-name) "\""))))
;;      (add-to-list 'TeX-expand-list '("%(pdf-file-name)" (lambda () (concat "\"" (car (split-string (with-current-buffer TeX-command-buffer buffer-file-name) "\\.tex")) ".pdf" "\""))))
;;      (add-to-list 'TeX-expand-list '("%(line-number)" (lambda () (format "%d" (line-number-at-pos)))))
;;      (cond
;;       ((eq system-type 'darwin)
;;        (add-to-list 'TeX-expand-list '("%(latexmkrc-osx)" (lambda () (expand-file-name "~/.latexmkrc"))))
;;        (add-to-list 'TeX-command-list '("latexmk-osx" "latexmk -pdf -r %(latexmkrc-osx) %s" TeX-run-TeX nil t))
;;        (add-to-list 'TeX-expand-list '("%(skim)" (lambda () "/Applications/Skim.app/Contents/SharedSupport/displayline")))
;;        (add-to-list 'TeX-command-list '("Skim" "%(skim) -b -g %(line-number) %(pdf-file-name) %(tex-file-name)" TeX-run-TeX nil t))
;;        (add-to-list 'TeX-view-program-list '("skim-viewer" "%(skim) -b -g %(line-number) %(pdf-file-name) %(tex-file-name)"))
;;        (setq TeX-view-program-selection '((output-pdf "skim-viewer"))))
;;       ((eq system-type 'windows-nt)
;;        (add-to-list 'TeX-expand-list '("%(latexmkrc-nt)" (lambda () "y:/scimax/users/.latexmkrc-nt")))
;;        (add-to-list 'TeX-command-list '("latexmk-nt" "latexmk -pdf -r %(latexmkrc-nt) %s" TeX-run-TeX nil t))
;;        (add-to-list 'TeX-expand-list '("%(sumatra)" (lambda () "\"c:/Program Files/SumatraPDF/SumatraPDF.exe\"")))
;;        (add-to-list 'TeX-command-list '("SumatraPDF" "%(sumatra) -reuse-instance -forward-search %(tex-file-name) %(line-number) %(pdf-file-name)" TeX-run-TeX nil t))
;;        (add-to-list 'TeX-view-program-list '("sumatra-viewer" "%(sumatra) -reuse-instance -forward-search %(tex-file-name) %(line-number) %(pdf-file-name)"))
;;        (setq TeX-view-program-selection '((output-pdf "sumatra-viewer")))))))

;; Set fill-column for fill-paragraph command. Also wraps visual-fill-column-width globally at this value
(setq fill-column 79)

;; (dolist (hook 'text-mode-hook markdown-mode-hook tex-mode-hook LaTeX-mode-hook latex-mode-hook ...)
;;   (add-hook hook (lambda ())))
(add-hook 'text-mode-hook
	  (lambda ()
		(visual-fill-column-mode)
		(setq visual-fill-column-width 91)
		(setq visual-fill-column-center-text t)))
(add-hook 'tex-mode-hook
	  (lambda ()
		(setq visual-fill-column-width 94)))
(add-hook 'org-mode-hook
	  (lambda ()
		(setq visual-fill-column-center-text nil)
		(setq visual-fill-column-width 108)
		;; Turns off TODO, DONE, NEXT, and set local so doesn't override default value
		(setq-local hl-todo-keyword-faces '(("HOLD" . "#d0bf8f")  ("T0D0" . "#cc9393")
						("TOD0" . "#cc9393") ("TODOO" . "#cc9393")
						("THEM" . "#dc8cc3") ("PROG" . "#7cb8bb") ("OKAY" . "#7cb8bb")
						("DONT" . "#5f7f5f") ("FAIL" . "#8c5353")
						("FINISHED" . "#afd8af") ("UNSURE" . "#dc8cc3") ("T000" . "#cc9393")
						("NOTE" . "#d0bf8f") ("KLUDGE" . "#d0bf8f") ("HACK" . "#d0bf8f")
						("TEMP" . "#d0bf8f") ("FIXME" . "#cc9393") ("XXX+" . "#cc9393")
						("QQQ+" . "#cc9393")
						))
		(hl-todo-mode)
		))
(add-hook 'nxml-mode-hook
	  (lambda ()
		(setq visual-fill-column-mode nil)
		(setq visual-fill-column-center-text nil)
		(setq visual-fill-column-width 108)
		))
(add-hook 'table-lood-hook
	  (lambda ()
		(setq visual-fill-column-mode nil)
		(setq visual-fill-column-center-text t)
		(setq visual-fill-column-width 200)
		))
(add-hook 'org-src-mode-hook
	  (lambda ()
		(setq visual-fill-column-center-text t)
		(setq visual-fill-column-width 200)
		(setq visual-fill-column-mode nil)
		))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hl-todo highlight todo mode settins
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq hl-todo-highlight-punctuation "\-:*/~=#<>|\\?")
;; Sets for every buffer so can run hl-todo-occur even if hl-todo-mode not enabled
(setq-default hl-todo--regexp "\\(\\<\\(HOLD\\|TODO\\|T0D0\\|NEXT\\|TOD0\\|TODOO\\|THEM\\|PROG\\|OKAY\\|DONT\\|FAIL\\|DONE\\|FINISHED\\|UNSURE\\|T000\\|NOTE\\|KLUDGE\\|HACK\\|TEMP\\|FIXME\\|XXX+\\|QQQ+\\)\\(?:\\>\\|\\>?\\)[-:*/~=#<>|\\?]*\\)")
(setq-default hl-todo-keyword-faces '(("HOLD" . "#d0bf8f") ("TODO" . "#cc9393") ("T0D0" . "#cc9393")
					  ("NEXT" . "#dca3a3") ("TOD0" . "#cc9393") ("TODOO" . "#cc9393")
					  ("THEM" . "#dc8cc3") ("PROG" . "#7cb8bb") ("OKAY" . "#7cb8bb")
					  ("DONT" . "#5f7f5f") ("FAIL" . "#8c5353") ("DONE" . "#afd8af")
					  ("FINISHED" . "#afd8af") ("UNSURE" . "#dc8cc3") ("T000" . "#cc9393")
					  ("NOTE" . "#d0bf8f") ("KLUDGE" . "#d0bf8f") ("HACK" . "#d0bf8f")
					  ("TEMP" . "#d0bf8f") ("FIXME" . "#cc9393") ("XXX+" . "#cc9393")
					  ("QQQ+" . "#cc9393")
					  ))
;; below uneccasry because hl-todo-mode is set by hl-todo-activate-in-modes
;; this defualts to (prog-mode text-mode) but not turned on in org-mode
(global-hl-todo-mode)
;; highlight todo, done, and fixme in prog-modes and latex-mode
;; (dolist (hook '(prog-mode-hook latex-mode-hook markdown-mode-hook ...))
;;   (add-hook hook (lambda ()
;;		   (hl-todo-mode))))

;; (add-hook 'text-mode-hook (lambda () (text-scale-decrease 1)))

;; Setup fonts and t
(defface doom-fixme-tasks ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:foreground "#ff3300"))) "")
(setq doom/ivy-task-tags
	  '(("TODO"  . warning)
	;; ("XXX"  . warning)
	;; ("XXXX"  . warning)
	;; ("QQQQ"  . warning)
	;; ("QQQ"  . warning)
	;; ("UNSURE"  . doom-fixme-tasks)
	("DONE" . success)
	;; ("NOTE" . success)
	;; ("FINISHED" . success)
	("CANCELED" . success)
	("FAIL" . doom-fixme-tasks)
	("FIXME" . doom-fixme-tasks)
	))
(defalias 'jj/doom/ivy-ag-rg-todos-tasks 'doom/ivy-tasks)

;; Beacon mode settings
(beacon-mode)
(setq beacon-blink-duration 0.3)
(setq beacon-blink-delay 0.1)
(setq beacon-size 35)
;; (setq beacon-color "#B194CB")
(setq beacon-blink-when-focused t)
(setq beacon-blink-when-window-changes t)
(setq beacon-blink-when-buffer-changes t)
(setq beacon-blink-when-point-moves-horizontally nil)
(setq beacon-blink-when-point-moves-vertically nil)
(setq beacon-blink-when-window-scrolls nil)
;; (jj/append-to-list-no-duplicates 'beacon-dont-blink-commands '(evil-scroll-down evil-scroll-up evil-scroll-page-up evil-scroll-page-down jj/evil-scroll-up-15-lines jj/evil-scroll-down-15-lines evil-scroll-line-up evil-scroll-line-down) t)
(add-hook 'eyebrowse-post-window-switch-hook #'beacon-blink)

;; Visible mark settings
(defface visible-mark-active ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "magenta"))) "")
(defface visible-mark-light-purple ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "#7549EC"))) "")
(defface visible-mark-light-orange ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "#BF674A"))) "")
(defface visible-mark-dark-orange ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "#AE5041"))) "")
(defface visible-mark-magenta ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "#A445A7"))) "")
(defface visible-mark-dark-teal ;; put this before (require 'visible-mark)
  '((((type tty) (class mono)))
	(t (:background "#226E68"))) "")
;; looping below to set faces to certain attributes
;; (dolist (face  '(sml/line-number sml/numbers-separator sml/col-number))
;;   (set-face-attribute face nil
;;                       :background zenburn/bg-1
;;                       :foreground zenburn/fg
;;                       :weight 'unspecified))
(global-visible-mark-mode 1)
(setq visible-mark-max 2)
(setq visible-mark-faces `(visible-mark-face1 visible-mark-face2))
;; use below for dark themes
;; (setq visible-mark-faces `(visible-mark-magenta visible-mark-dark-orange))
(setq show-paren-priority 999)
;; (setq avy-timeout-seconds 0.5)

;; Can also use fullheight, fullwidth, fullboth<-(makes it go into own space)
;; if use f11 to fullscreen into own space then new ones open in own space
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; So no gaps between emacs frames and other windows
(setq frame-resize-pixelwise t)

;; (setq magit-remote-set-if-missing nil)
;; Typing: "Fixes #" in git commit buffer will bring up all the issues in helm window
(add-hook 'git-commit-mode-hook 'git-commit-insert-issue-mode)


;; Makes it so you can't kill this buffer (but with dired can't usa a or keys that don't open new buffer
;; (with-current-buffer "Downloads"
;;   (emacs-lock-mode 'kill))
;; Themes
(setq custom-safe-themes t)
;; (when (display-graphic-p)
;;   (load-theme 'leuven t)
;;   )
(sml/setup)
(setq sml/theme 'automatic)
(jj/sml/total-lines-append-mode-line)
(setq line-number-display-limit-width 500)
;; Set for file size line number not too display
;; (setq line-number-display-limit )

;; (setq jmax-user-theme 'monokai)
;; (setq sml/theme 'dark)
;; (add-hook 'after-init-hook (lambda () (load-theme 'smart-mode-line-dark)))
(set-face-attribute 'default nil :font "Hack-14")
;; possibly set after-setting-font-hook if changing themes a lot to keep setting the mode-line
;; or since use dired a lot set in function that forces mode-line to be rewritten
(set-face-attribute 'mode-line nil :font "Lucida Grande-13")
(add-hook 'emacs-lisp-mode-hook 'jj/remove-elc-on-save)

;; this is a test does it work well I think so
(jj/load-theme-sanityinc-tomorrow-eighties)

(setq global-auto-revert-mode t)
;; refresh dired buffers when revisited
(setq dired-auto-revert-buffer t)
;; Below works by not auto reverting recursive directories (subdir)
;; (setq dired-auto-revert-buffer  (lambda (_dir) (null (cdr dired-subdir-alist))))
(setq auto-revert-verbose nil)		;; Set to nil to not generate messages
(setq dired-omit-verbose nil)
;; Uses xargs to run commands instead of passing -exec to find which makes it very slow
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))
(add-hook 'dired-mode-hook
	  (lambda ()
		(auto-revert-mode)
		(when (file-remote-p dired-directory)
		  (setq-local dired-actual-switches "-a -F -Alh"))
		(dired-omit-caller)
		(dired-hide-details-mode)
		(dired-sort-toggle-or-edit)
		(when (get-buffer "saves-*")
		  (progn
		(with-current-buffer "saves-*"
		  (interactive)
		  (setq dired-omit-mode nil)
		  (dired-hide-details-mode 0)
		  (jj/dired-sort-by-time-switch-toggle))))))

(setq dired-ranger-bookmark-reopen 'always)
;; Set up so that dired+ mode properly ignores auto-save files
;; Need to load dired+ after setting up the settings or they don't work
(jj/append-to-list 'dired-omit-extensions '("#" "##"))
(setq diredp-ignore-compressed-flag nil)
(setq diredp-omit-files-regexp "\\.#\\|\\.\\|\\.\\.\\|\\..*")
(setq dired-dwim-target t)
(setq wdired-allow-to-change-permissions t)

;; start directory
(defvar jj/move-file-here-start-dir (expand-file-name "~/Downloads"))
(defvar-local is-new-file-buffer nil)
(add-hook 'kill-buffer-hook 'jj/save-new-file-before-kill)
(add-hook 'kill-emacs-hook 'jj/brc-functions-file)

;; Setup remebering what major mode to open files with no file extension
;; Appends these to the list to open files
;; TODO: Improve this if using because seems to load the file many times
;; (add-to-list 'savehist-additional-variables 'kill-ring)
(add-to-list 'savehist-additional-variables 'jj/last-change-pos1)
(add-to-list 'savehist-additional-variables 'jj/last-change-pos2)
(add-hook 'find-file-hook 'jj/find-file-hook-root-header-warning)
;; (add-hook 'jj/find-file-root-hook 'find-file-root-header-warning)
(add-to-list 'savehist-additional-variables 'jj/find-file-root-history)
;; Needs to be defined before savehist-mode is loaded

;; Save the dired directories previously used for copy and rename and goto with ,
(add-to-list 'savehist-additional-variables 'ivy-dired-history-variable)
(add-to-list 'savehist-additional-variables 'recentf-list)
;; Out of the box desktop.el saves registers but in case of error this is backup
(add-to-list 'savehist-additional-variables 'register-alist)
;; (add-to-list 'savehist-additional-variables 'save-place-alist)
(setq savehist-autosave-interval (* 9 60))
(defvar file-name-mode-alist '())
;; (add-to-list 'savehist-additional-variables 'file-name-mode-alist)
(when (fboundp 'file-name-mode-alist)
  (setq auto-mode-alist (append auto-mode-alist file-name-mode-alist)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backup each save and emacs default backup settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-save-hook 'backup-each-save)
(setq backup-each-save-mirror-location (expand-file-name "~/.emacs_path_backups"))
;; Backup-save size limit is set to 5mb
(setq backup-each-save-size-limit (* 1024 1024 2))
(setq backup-each-save-filter-function 'jj/backup-each-save-filter)

;; https://www.emacswiki.org/emacs/BackupFiles
(setq
 backup-inhibited nil		   ; enable backups
 backup-by-copying t		   ; don't clobber symlinks
 kept-new-versions 4		   ; keep 12 latest versions
 kept-old-versions 1		   ; don't bother with old versions
 delete-old-versions t		   ; don't ask about deleting old versions
 delete-by-moving-to-trash t
 version-control t			 ; number backups
 vc-make-backup-files t) ; backup version controlled files
;; Later maybe update the backup functions above so the tramp files are stored into their own
;; per-session and per-save directories
(add-to-list 'backup-directory-alist
		 (cons tramp-file-name-regexp (expand-file-name "~/.emacs_backups/per-save")))

;; Disabling backups can be targeted to just the su and sudo methods:
;; (setq backup-enable-predicate
;;            (lambda (name)
;;              (and (normal-backup-enable-predicate name)
;;                   (not
;;                    (let ((method (file-remote-p name 'method)))
;;                      (when (stringp method)
;;                        (member method '("su" "sudo"))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup every save                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;; https://www.emacswiki.org/emacs/backup-each-save.el
(defvar jj/backup-file-size-limit (* 5 1024 1024)
  "Maximum size of a file (in bytes) that should be copied at each savepoint.

If a file is greater than this size, don't make a backup of it.
Default is 5 MB")

(defvar jj/backup-location (expand-file-name "~/.emacs_backups")
  "Base directory for backup files.")

(defvar jj/backup-trash-dir (expand-file-name "~/.Trash")
  "Directory for unwanted backups.")

(defvar jj/backup-exclude-regexp "\\.\\(vcf\\|gpg\\|pdf\\|snes\\)$"
  "Don't back up files matching this regexp.

Files whose full name matches this regexp are backed up to `jj/backup-trash-dir'. Set to nil to disable this.")

;; Default and per-save backups go here:
;; N.B. backtick and comma allow evaluation of expression
;; when forming list
(setq backup-directory-alist
	  `(("" . ,(expand-file-name "per-save" jj/backup-location))))

;; add trash dir if needed
(if jj/backup-exclude-regexp
	(add-to-list 'backup-directory-alist `(,jj/backup-exclude-regexp . ,jj/backup-trash-dir)))

;; add to save hook
(add-hook 'before-save-hook 'jj/backup-every-save)

;; If sensitive mode is turned off then the autosave file will be created
;; and the backups will go to the trash due to the settings jj/backup-every-save
;; Can also use the below to make it sensitive-minor mode
;; // -*-mode:org; mode:sensitive; fill-column:132-*-
(setq auto-mode-alist
	  (append '(("\\.gpg$" . sensitive-mode)
		;; ("\\.pdf$" . sensitive-mode)
		)
		  auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto save settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; turn off auto-save-messages
(setq auto-save-no-message t)
;; auto save often
;; save every 20 characters typed (this is the minimum)
(setq auto-save-interval 60)
;; number of seconds before auto-save when idle
(setq auto-save-timeout 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dumbjump jump settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq dumb-jump-selector 'ivy)
(setq dumb-jump-prefer-searcher 'rg)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gtags settings (helm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 helm-gtags-ignore-case nil
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-suggested-key-mapping t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go to (Special) End of Buffer for certain modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(eval-after-load 'dired '(jj/special-beginning-of-buffer dired
			   (while (not (ignore-errors (dired-get-filename)))
				 (dired-next-line 1))))
(jj/special-end-of-buffer dired
  (if (not (ignore-errors (dired-get-filename)))
	  (dired-previous-line 1)))
(jj/special-beginning-of-buffer occur
  (occur-next 1))
(jj/special-end-of-buffer occur
  (occur-prev 1))
(jj/special-beginning-of-buffer ibuffer
  (ibuffer-forward-line 1))
(jj/special-end-of-buffer ibuffer
  (ibuffer-backward-line 1))
(jj/special-beginning-of-buffer vc-dir
  (vc-dir-next-line 1))
(jj/special-end-of-buffer vc-dir
  (vc-dir-previous-line 1))
(jj/special-beginning-of-buffer bs
  (bs-down 2))
(jj/special-end-of-buffer bs
  (bs-up 1)
  (bs-down 1))
(jj/special-beginning-of-buffer recentf-dialog
  (when (re-search-forward "^  \\[" nil t)
	(goto-char (match-beginning 0))))
(jj/special-end-of-buffer recentf-dialog
  (re-search-backward "^  \\[" nil t))
(jj/special-beginning-of-buffer ag
  (compilation-next-error 1))
(jj/special-end-of-buffer ag
  (compilation-previous-error 1))
(jj/special-beginning-of-buffer org-agenda
  (org-agenda-next-item 1))
(jj/special-end-of-buffer org-agenda
  (org-agenda-previous-item 1))
(jj/special-beginning-of-buffer ag
  (compilation-next-error 1))
(jj/special-end-of-buffer ag
  (compilation-previous-error 1))
(jj/special-end-of-buffer elfeed-search
  (forward-line -2))
(jj/special-end-of-buffer elfeed-search
  (forward-line -2))

;; (savehist-mode 1)
;; not needed as above does the same thing
;; (run-with-timer (* 30 60) (* 30 60) 'savehist-save)
;; or if you use desktop-save-mode
(add-hook 'after-change-major-mode-hook
	  (lambda ()
		(when (and
		   buffer-file-name
		   (not
			(file-name-extension
			 buffer-file-name)))
		  (setq file-name-mode-alist
			(cons
			 (cons buffer-file-name major-mode)
			 file-name-mode-alist))
		  (setq auto-mode-alist
			(append auto-mode-alist
				(list (cons buffer-file-name major-mode)))))))



;; Faster pop-to-mark by if cursor in same location repeatedly pop mark
(advice-add 'pop-to-mark-command :around #'jj/multi-pop-to-mark)
(advice-add 'semantic-idle-scheduler-function :around #'ignore)

;; Sets up so going to previous place in previous buffer works correctly
(add-hook 'after-change-functions 'jj/buffer-change-hook)

(setq openwith-associations
	  '(("\\.\\(?:mpe?g\\|avi\\|wmv\\|dmg\\|pkg\\|mat\\|mkv\\|xlsx\\|mp4\\|m4a\\|mp3\\|xls\\|doc\\|docx\\|ppt\\|pptx\\|wav\\|mov\\|psd\\)\\'" "open" (file))))
;; '(("\\.avi\\'" "open" (file))))
(openwith-mode t)
;; dired won't ask unless file bigger than 100MB set to nil to completely get rid of
(setq large-file-warning-threshold 100000000)
;; Makes it so don't ask for these file types if opening bigger than 100MB
(defvar jj/ok-large-file-types
  (rx "." (or "mp4" "mkv" "avi" "mpeg" "mpg" "wmv" "mov" "m4a" "dmg") string-end)
  "Regexp matching filenames which are definitely ok to visit,
even when the file is larger than `large-file-warning-threshold'.")

(defadvice abort-if-file-too-large (around my-check-ok-large-file-types)
  "If FILENAME matches `jj/ok-large-file-types', do not abort."
  (unless (string-match-p jj/ok-large-file-types (ad-get-arg 2))
	ad-do-it))
(ad-activate 'abort-if-file-too-large)

;; Directories sorted by folder first
(setq insert-directory-program "gls" dired-use-ls-dired t)
;; -A means almost all below not including . and ..
;; (setq dired-omit-case-fold t)
(setq dired-listing-switches "-a -F -lGhHAv  --group-directories-first")
;; First is normal then group directories first and then with proper number sorting scheme -v
;; (setq dired-listing-switches "-lXGh  --group-directories-first")
;; Very dangerous to set to always below (on Mac sends to Trash so ok to set to always)
(setq dired-recursive-copies 'always)
(if (eq system-type 'darwin) (setq dired-recursive-deletes 'always)
  (setq dired-recursive-deletes 'top))
(setq dired-omit-mode t)
(setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$")
;; (setq dired-omit-files "^\\...+$")
;; Makes it so doesn't ask if I want to use the command the first time
;; (if set to t it will ask me the first time when starting emacs)

(put 'dired-find-file-other-buffer 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(setq dired-guess-shell-alist-user
	  (list
	   '("\\.dvi\\'" "xdvi" )	; preview and printing
	   '("\\.mpe?g\\'\\|\\.avi\\'\\|\\.mkv\\'\\|\\.mp4\\'" "open -a NicePlayer")
	   '("\\.ogg\\'" "open -a Clementine")
	   '("\\.mp3\\'" "open -a Clementine")
	   '("\\.gif\\'" "open -a Preview")		; view gif pictures
	   '("\\.tif\\'" "open -a Preview")
	   '("\\.png\\'" "open -a Preview")		; xloadimage 4.1 doesn't grok PNG
	   '("\\.jpe?g\\'" "open -a Preview")
	   '("\\.fig\\'" "xfig")		; edit fig pictures
	   '("\\.out\\'" "xgraph")		; for plotting purposes.
	   '("\\.tex\\'" "latex" "tex")
	   '("\\.texi\\(nfo\\)?\\'" "makeinfo" "texi2dvi")
	   '("\\.pdf\\'" "open -a Preview")
	   ))

;; Also placed in preload.el right now
(setq emacs-lock-default-locking-mode 'kill)
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))

;; different from find-alternate-file because when hit enter on file
;; keeps that directory open and opens file (find-alt will close the dired buffer)
(defadvice dired-advertised-find-file (around dired-subst-directory activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
	(filename (dired-get-filename)))
	ad-do-it
	(when (and (file-directory-p filename)
		   (not (eq (current-buffer) orig)))
	  (kill-buffer orig))))

;; (require 'savehist)
;; (add-to-list 'savehist-additional-variables 'helm-dired-history-variable)
;; (savehist-mode 1)
;; (with-eval-after-load 'dired
;;   (require 'helm-dired-history)
;;   ;; if you are using ido,you'd better disable ido for dired
;;   ;; (define-key (cdr ido-minor-mode-map-entry) [remap dired] nil) ;in ido-setup-hook
;;   (define-key dired-mode-map "[" 'dired))

;; save all buffers when you lose emacs focus
;; (add-hook 'focus-out-hook (lambda () (save-some-buffers t)))
;; auto-save all buffers when you lose emacs focus
(add-hook 'focus-out-hook (lambda () (do-auto-save t)))

;; Doesn't work because currently Fn is set to operate as Command+Alt+Shift
(setq ns-function-modifier 'hyper)  ; make Fn key do Hyper
;; open in the original frame
(setq ns-pop-up-frames nil)

;; Deals with remembering window history and go back with C-c left/right
(winner-mode 1) ;; winner-undo and winner-redo the functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set to t to go after *** first then beg of line when pressing again or 'reversed to reverse this
(setq org-special-ctrl-a/e t)
;; will show space between headings if 1 or more lines blank (default 2)
(setq org-cycle-separator-lines 2)
(setq org-support-shift-select nil)
(setq org-list-allow-alphabetical t)
(setq org-list-demote-modify-bullet
	  '(("+" . "-") ("-" . "*") ("*" . "+") ("1." . "a.") ("a." . "+") ("A." . "+") ("1)" . "a)") ("a)" . "1.") ("A)" . "1.")))
(setq org-startup-indented t)
;; sets whether todo statistics are recursive for todo and checkboxes
(setq org-hierarchical-todo-statistics t)
(setq org-checkbox-hierarchical-statistics nil)

;; Switch entry to done automatically when all subentries are done
(add-hook 'org-checkbox-statistics-hook 'jj/org-checkbox-todo)

(setq org-use-sub-superscripts '{})
(setq org-export-with-sub-superscripts '{})
(scimax-toggle-abbrevs 'scimax-month-abbreviations +1)
(scimax-toggle-abbrevs 'scimax-weekday-abbreviations +1)
(scimax-toggle-abbrevs 'scimax-chemical-formula-abbreviations -1)
(scimax-toggle-abbrevs 'scimax-misc-abbreviations 1)
(scimax-toggle-abbrevs 'scimax-contraction-abbreviations +1)
(setq scimax-autoformat-ordinals nil)
(setq scimax-autoformat-fractions t)
(setq scimax-autoformat-superscript nil)
(setq scimax-autoformat-transposed-caps nil)
(setq scimax-autoformat-sentence-capitalization nil)
;; ;; To turn them on all that time add the line below
(add-hook 'org-mode-hook 'scimax-autoformat-mode)
;; deletes comments before export so paragraphs aren't split where comments are
;; (add-hook 'org-export-before-processing-hook 'delete-org-comments)

(setq org-todo-keywords
	  '((sequence "TODO(t)" "|" "DONE(d)")
	(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
	(sequence "|" "CANCELED(c)")))

;; Make org-goto work with ivy-completion
(setq org-goto-interface 'outline-path-completion)
(setq org-outline-path-complete-in-steps nil)
;; Bibliography
(setq reftex-default-bibliography '((expand-file-name "~/Google-dr/Research/MyWork/Bibtex/library.bib")))
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes (expand-file-name "~/Google-dr/Research/MyWork/Bibtex/libraryNotes.bib")
	  org-ref-default-bibliography '((expand-file-name "~/Google-dr/Research/MyWork/Bibtex/library.bib"))
	  org-ref-pdf-directory (expand-file-name "~/Google-dr/Research/Papers/"))
;; setup when start refiling notes
;; (setq org-refile-targets
;;       '(("gtd.org" :maxlevel . 1)
;;         ("done.org" :maxlevel . 1)))

(setq org-refile-targets
	  '((nil :maxlevel . 1)
	(org-agenda-files :maxlevel . 1)
	("Machine_learning_notes.org" :maxlevel . 1)
	("Job_notes.org" :maxlevel . 1)
	("Archive_notes.org" :maxlevel . 1)
	("computer_notes.org" :maxlevel . 1)
	("done.org" :maxlevel . 2)
	))
(setq org-outline-path-complete-in-steps nil)    ; Refile in a single go
;; also seen people set use-outline-path to 'file
;; this allows refiling to the top level of a file
;; TODO: Possible change back to t instead of 'file if don't need to refile at the top level
(setq org-refile-use-outline-path 'file)             ; Show full paths for refiling
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-download-screenshot-method "screencapture -i %s")

;; Does \usepackage[margin=1in]{geometry} in latex header
(setq org-latex-packages-alist '(("margin=1in" "geometry" nil)))
;; adds new class defined below that can specify with #+LATEX_CLASS:
(add-to-list 'org-latex-classes
		 '("myarticle"
		   "\\documentclass[letter,11pt]{article}

\\usepackage[utf8]{inputenc}
\\usepackage{lmodern}
\\usepackage[T1]{fontenc}
\\usepackage[margin=1in]{geometry}
\\usepackage{graphicx}

\\usepackage{fixltx2e}

\\newcommand\\foo{bar}
		   [NO-DEFAULT-PACKAGES]
		   [NO-PACKAGES]
		   [EXTRA]"
		   ("\\section{%s}" . "\\section*{%s}")
		   ("\\subsection{%s}" . "\\subsection*{%s}")
		   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; If export to "docx" then odt can't be in openwith associations or doesn't work
(setq  org-odt-preferred-output-format "docx")
;; Used to setq certain org values to convert odt to docx
(jj/my-setup-odt-org-convert-process-to-docx)

;; Org-mode source blocks
;; If you have issues like described above, then try disable ob-ipython and see, is it help. Usually, it is enough to remove ipython from (org-babel-do-load-languages ...) list, and restart your Emacs.
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t) (latex . t) (python . t) (shell . t) (matlab . t)
   (sqlite . t) (ruby . t) (perl . t) (org . t) (dot . t) (plantuml . t)
   (R . t) (fortran . t) (C . t) (jupyter . t)))
;; overrides so when you put python it does jupyter-python
;; (org-babel-jupyter-override-src-block "python")
;; Fix error that async might cause issues
(setq ob-async-no-async-languages-alist '("jupyter-python" "jupyter-julia"))
(setq org-babel-default-header-args:jupyter-julia '((:async . "yes")
							(:session . "jl")))
(setq org-babel-default-header-args:jupyter-python '((:async . "yes")
							 (:session . "py")))
;; HACK: Append reset scimax bindings to end of org-mode hook so runs last
(add-hook 'org-mode-hook 'jj/org-ob-babel-reset-scimax-bindings 90)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; view weather wttrin package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq wttrin-default-cities '("Toronto" "Saint Louis, United States of America" "Seoul"))
;; '("Accept-Language" . "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4")
(setq wttrin-default-accept-language '("Accept-Language" . "en-US,en;q=0.8"))

;; Setup so todotxt works and initialize location of todotxt file
(setq todotxt-file (expand-file-name "~/Dropbox/Apps/Simpletask/todo.txt"))

(setq user-full-name "Jeff Spencer"
					; andrewid "jeffspencerd"
	  user-mail-address "jeffspencerd@gmail.com"
	  ;; specify how email is sent
					; send-mail-function 'smtpmail-send-it
	  ;; used in message mode
					; message-send-mail-function 'smtpmail-send-it
					; smtpmail-smtp-server "smtp.gmail.com"
					; smtpmail-smtp-service 587
	  )

(when (and (daemonp) (locate-library "edit-server"))
  (require 'edit-server)
  (require 'edit-server-htmlize)
  (edit-server-start)
  (autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
  (autoload 'edit-server-maybe-htmlize-buffer   "edit-server-htmlize" "edit-server-htmlize" t)
  (add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
  (add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
  )

(setq visible-bell t)
;; Reduce the number of times the bell rings
;; Turn off the bell for the listed functions.
;; (setq ring-bell-function 'ignore)
(setq ring-bell-function
	  (lambda ()
	(unless (memq this-command
			  '(isearch-abort
			minibuffer-keyboard-quit
			abort-recursive-edit
			exit-minibuffer
			keyboard-quit
			jj/org-metaleft-next-line-beginning-item
			jj/org-metaleft-next-line-previous-item
			previous-line
			next-line
			evil-scroll-up
			evil-scroll-down
			dired-tree-up
			dired-tree-down
			mwheel-scroll
			jj/dired-tree-up
			jj/dired-tree-down
			dired-next-subdir
			dired-prev-subdir
			jj/dired-prev-subdir
			jj/dired-next-subdir
			end-of-buffer
			scroll-down
			scroll-up
			cua-scroll-down
			cua-scroll-up))
	  (ding))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Aspell/Ispell/Flyspell settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: Aspell can detect CamelCase words using --run-together added to ispell-extra-args
;; (write function to add and remove this to change CamelCase checking on the fly)
(setq ispell-program-name (executable-find "aspell"))
(setq ispell-silently-savep t)
(setq ispell-dictionary "american")
;; TODO: Need two files because headers are different (can rewrite header depending on loaded program)
(if (equal ispell-program-name (executable-find "aspell"))
	(setq ispell-personal-dictionary (expand-file-name "~/Programs/scimax/user/aspell_personal.pws"))
  (setq ispell-personal-dictionary (expand-file-name "~/Programs/scimax/user/hunspell_personal.dic")))


(setq desktop-path (list (expand-file-name "~/Programs/scimax/user")))
;; Too low a number eg.5 doesn't seem to load workspaces correctly but maybe 30-50 better
;; (setq desktop-restore-eager 30)
(setq desktop-auto-save-timeout (* 60 5))
(add-to-list 'desktop-globals-to-save 'register-alist)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

;; prevents desktop-save from saving if all the buffers haven't reloaded yet
(defvar jj/desktop-save-if-all-buffers-read nil
  "Should I save the desktop when Emacs is shutting down?")
(add-hook 'desktop-after-read-hook
	  (lambda () (setq jj/desktop-save-if-all-buffers-read t)
		(jj/lock-my-dired-emacs-buffers)))
(advice-add 'desktop-save :around
		(lambda (fn &rest args)
		  (if (bound-and-true-p jj/desktop-save-if-all-buffers-read)
		  (apply fn args))))
;; if default-desktop-file doesn't exist set above to true so allows saving
(add-hook 'desktop-no-desktop-file-hook
	  (lambda () (setq jj/desktop-save-if-all-buffers-read t)))

(setq desktop-buffers-not-to-save
	  (concat "\\("
		  "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
		  "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
		  "\\)$"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Peep dired settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq peep-dired-max-size (* 8 1024 1024))
(setq peep-dired-ignored-extensions '("mkv" "iso" "mp4" "xls" "avi" "mpg" "mpg" "mp3" "xlsx" "wav" "psd" "ppt" "pptx" "odt" "doc" "docx" "m4a" "dmg"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Easy kill settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq easy-kill-alist '((?w word           " ")
			(?a backward-line-edge "")
			(?e forward-line-edge "")
			(?s sexp           "\n")
			(?l list           "\n")
			(?f filename       "\n")
			(?d defun          "\n\n")
			(?D defun-name     " ")
			(?b buffer-file-name)
			(?h buffer "")
			(?< buffer-before-point "")
			(?> buffer-after-point "")
			(?^ backward-line-edge "")
			(?$ forward-line-edge "")
			(?L line           "\n")
			(?z string-to-char-forward "")
			(?Z string-up-to-char-forward "")
			(?t string-to-char-backward "")
			(?T string-up-to-char-backward "")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Alternative input methods for Korean hangul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq alternative-input-methods
	  '(("korean-hangul" . [?\M-\s-\\])))
(setq default-input-method
	  (caar alternative-input-methods))
(reload-alternative-input-methods)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wg workgroups settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq wg-use-default-session-file nil)
;; don't open last workgroup automatically in `wg-open-session',
;; I only want to check available workgroups! Nothing more.
(setq wg-session-file (expand-file-name "~/Programs/scimax/user/emacs_workgroups"))
(setq wg-load-last-workgroup nil)
(setq wg-open-this-wg nil)
;;(workgroups-mode 1) ; put this one at the bottom of .emacs
;; by default, the sessions are saved in "~/.emacs_workgroups"
(autoload 'wg-create-workgroup "workgroups2" nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs startup hook and daemon settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'emacs-startup-hook
	  (lambda ()
		;; allows proper loading so doesn't overwrite the recentf file with no entries
		(recentf-mode 1)
		;; load after recentf-mode since storing recentf-list in savehist variable
		(savehist-mode 1)
		(setq save-place-timer (run-with-timer (* 60 60) (* 60 60) 'jj/save-place-recentf-to-file)))
	  90)
;; needs to be added to hook after (recentf-mode 1) so loaded first
;; if not writing to recentf, might not work properly
(add-hook 'emacs-startup-hook
	  (lambda ()
		;; so loaded after all settings because appears to mess up things if loaded before
		(require 'dired+)
		;; (interactive)
		(cond ((file-exists-p (concat (file-name-as-directory (car desktop-path))  desktop-base-lock-name))
		   (message ".emacs.desktop.lock file exists so desktop-save-mode not turned on")
		   (setq jj/desktop-save-if-all-buffers-read t)
		   (setq desktop-path (list (expand-file-name "~/Programs/scimax/user/desktops"))))
		  (t (when (not (daemonp))
			   (desktop-save-mode)
			   (desktop-read)))))
	  -90)
;; only run when .emacs.desktop.lock file doesn't exist and not in daemon-mode
;; Run an edit server in the running emacs
;; (when (locate-library "edit-server")
;;   (require 'edit-server)
;;   (setq edit-server-new-frame nil)
;;   (edit-server-start)
;; (autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
;; (autoload 'edit-server-maybe-htmlize-buffer   "edit-server-htmlize" "edit-server-htmlize" t)
;; (add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
;; (add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
;; )
