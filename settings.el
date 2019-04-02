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

(setq recentf-save-file "~/Programs/scimax/user/recentf")
;; (run-with-timer (* 60 60) (* 60 60) 'recentf-save-list)
(setq recentf-exclude (append recentf-exclude  '(".*projectile-bookmarks.eld$" ".*user/recentf$" ".*user/history$" ".*user/abbrev_defs$" ".*user/ac-comphist.dat$" ".*user/bookmarks$" ".*mp3$" ".*mp4$" ".*elc$" ".*\\.el\\.gz$" ".*mkv$" ".*avi$" ".*wmv$" ".*png$" ".*\\.r[0-9a][0-9r]" ".*/FinishedTor/.*$" ".*/To_Delete/K/.*$" ".*/scimax/elpa/.*$")))
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
(add-hook 'emacs-startup-hook
	  (lambda ()
	    ;; so loaded after all settings because appears to mess up things if loaded before
	    (require 'dired+)
	    ;; allows proper loading so doesn't overwrite the recentf file with no entries
	    (recentf-mode 1)
	    ;; load after recentf-mode since storing recentf-list in savehist variable
	    (savehist-mode 1)
	    (setq save-place-timer (run-with-timer (* 60 60) (* 60 60) 'jj/save-place-recentf-to-file))))

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
      '((org-refile . "^")
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
	(counsel-org-goto      . ivy--regex-ignore-order)
	(counsel-org-goto-all      . ivy--regex-ignore-order)
	(counsel-grep-or-swiper      . ivy--regex-ignore-order)
	(jj/counsel-find-name-everything      . ivy--regex-ignore-order)
	(t      . ivy--regex-ignore-order)))
;; Latex and tex mode settings
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
     (add-to-list 'TeX-command-list '("latexmk" "latexmk -pdf -r /Users/bigtyme/Programs/scimax/user/latexmkrc %s" TeX-run-TeX nil t :help "Run latexmk on file then output to skim"))
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
;;        (add-to-list 'TeX-expand-list '("%(latexmkrc-osx)" (lambda () "/Users/bigtyme/.latexmkrc")))
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
						("TEMP" . "#d0bf8f") ("FIXME" . "#cc9393") ("XXX" . "#cc9393")
						("XXXX" . "#cc9393") ("????" . "#cc9393") ("???" . "#cc9393")
						))
	    (hl-todo-mode)
	    ))
(setq org-startup-indented t)
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

;; (add-hook 'text-mode-hook (lambda () (text-scale-decrease 1)))
;; (setq dropbox-access-token pa8m5pql3gkAAAAAAADx6pqdfm4oOdinGLz1kQFcGyvidfq7EPrcFyPeiLnzIHE-)

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

(setq magithub-clone-default-directory "~/Downloads/")
;; (setq magit-remote-set-if-missing nil)

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
(column-number-mode 0)
(jj/sml/total-lines-append-mode-line)

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
(setq diredp-compressed-extensions '(".tar" ".taz" ".tgz" ".arj" ".lzh" ".lzma" ".xz" ".zip" ".z" ".Z"
				     ".gz" ".bz2" ".rar" ".r[0-9]+"))
(setq diredp-omit-files-regexp "\\.#\\|\\.\\|\\.\\.\\|\\..*")

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
      '(("\\.\\(?:mpe?g\\|avi\\|wmv\\|mat\\|mkv\\|xlsx\\|mp4\\|m4a\\|mp3\\|xls\\|doc\\|docx\\|ppt\\|pptx\\|wav\\|mov\\|psd\\)\\'" "open" (file))))
;; '(("\\.avi\\'" "open" (file))))
(openwith-mode t)
;; dired won't ask unless file bigger than 100MB set to nil to completely get rid of
(setq large-file-warning-threshold 100000000)
;; Makes it so don't ask for these file types if opening bigger than 100MB
(defvar jj/ok-large-file-types
  (rx "." (or "mp4" "mkv" "avi" "mpeg" "mpg" "wmv" "mov" "m4a") string-end)
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

;; Switch entry to done automatically when all subentries are done
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(scimax-toggle-abbrevs 'scimax-month-abbreviations +1)
(add-hook 'org-mode-hook 'scimax-autoformat-mode)

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)")
	(sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
	(sequence "|" "CANCELED(c)")))

;; Make org-goto work with ivy-completion
(setq org-goto-interface 'outline-path-completion)
(setq org-outline-path-complete-in-steps nil)
;; Bibliography
(setq reftex-default-bibliography '("~/Google-dr/Research/MyWork/Bibtex/library.bib"))
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Google-dr/Research/MyWork/Bibtex/libraryNotes.bib"
      org-ref-default-bibliography '("~/Google-dr/Research/MyWork/Bibtex/library.bib")
      org-ref-pdf-directory "~/Google-dr/Research/Papers/")

;; Setup so todotxt works and initialize location of todotxt file
(setq todotxt-file (expand-file-name "/Users/bigtyme/Dropbox/Apps/Simpletask/todo.txt"))

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

(setq ispell-program-name (executable-find "hunspell"))
(setq ispell-silently-savep t)
(setq ispell-personal-dictionary (expand-file-name "~/Dropbox/Programs/emacs/user/hunspell_personal.dic"))

(setq desktop-path (list "~/Programs/scimax/user"))
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

;; For alternative input methods (korean)
(setq alternative-input-methods
      '(("korean-hangul" . [?\M-\s-\\])))
(setq default-input-method
      (caar alternative-input-methods))
(reload-alternative-input-methods)

;; needs to be added to hook after (recentf-mode 1) so loaded first
;; if not writing to recentf, might not work properly
(add-hook 'emacs-startup-hook
	  (lambda ()
	    ;; (interactive)
	    (cond ((file-exists-p (concat (file-name-as-directory (car desktop-path))  desktop-base-lock-name))
		   (message ".emacs.desktop.lock file exists so desktop-save-mode not turned on")
		   (setq jj/desktop-save-if-all-buffers-read t)
		   (setq desktop-path (list "~/Programs/scimax/user/desktops")))
		  (t (when (not (daemonp))
		       (desktop-save-mode)
		       (desktop-read))))))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not using
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; add some additional themes
					; (add-to-list 'custom-theme-load-path (expand-file-name "themes/emacs-color-theme-solarized" starter-kit-dir))

					; (add-to-list 'custom-theme-load-path (expand-file-name "themes/replace-colorthemes" starter-kit-dir))

					; (add-to-list 'load-path (expand-file-name "themes/tomorrow-theme/Gnu Emacs" starter-kit-dir))

					; (add-to-list 'custom-theme-load-path (expand-file-name "themes/tomorrow-theme/Gnu Emacs" starter-kit-dir))

;; flyspell mode for spell checking everywhere
;; (add-hook 'org-mode-hook 'turn-on-flyspell 'append)

;; [[https://github.com/grettke/home/blob/master/ALEC.txt][home/ALEC.txt at master · grettke/home]]
					; (setq org-catch-invisible-edits 'error)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Old emacs config mine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; adapted from [[http://doc.rix.si/org/fsem.html][Hardcore Freestyle Emacs]]
;; (rainbow-mode 1)
;; (diminish 'rainbow-mode)
;; (global-linum-mode 0)
;; (global-whitespace-mode 0)
;; ;; (global-relative-line-numbers-mode 0)
;; (global-hl-line-mode 0)
;; ;; (column-highlight-mode 0)
;; (hl-line-mode 0)

;; (defun rrix/enable-hl-line ()
;;        (hl-line-mode 1))

;; (mapc (function (lambda (mode)
;;                  (message (symbol-name mode))
;;                  (add-hook mode 'rrix/enable-hl-line)))
;;       '(erc-mode-hook
;;         gnus-group-mode-hook
;;         gnus-summary-mode-hook
;;         org-agenda-mode-hook
;;         eshell-mode-hook))

;; (require 'diminish)
;; (diminish 'visual-line-mode "")

;; (global-visual-line-mode)
;; (setq-default fill-column 80
;;	      whitespace-line-column 80)

;; (require 'whitespace)
;; (diminish 'whitespace-mode "ᗣ")
;; (diminish 'global-whitespace-mode "ᗣ")
;; (add-hook 'before-save-hook 'whitespace-cleanup)

;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
;; (define-key global-map (kbd "RET") 'newline-and-indent)

;; (defun rrix/setup-text-mode ()
;;        "function that applies all of my text-mode customizations"
;;        (whitespace-mode 1))
;; (add-hook 'text-mode-hook 'rrix/setup-text-mode)

;; (setq whitespace-style '(indentation::space
;;                          space-after-tab
;;                          space-before-tab
;;                          trailing
;; ;;                         lines-tail
;;                          tab-mark
;;                          face
;;                          tabs))

;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; (setq linum-delay t
;;       linum-eager nil)
;; (add-hook 'prog-mode-hook '(lambda () (linum-mode 1)))

;; (require 'flymake)
;; (flymake-mode 0)
;; (diminish 'flymake-mode "")

;; (require 'hideshow)
;; (add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1)))
;; (diminish 'hs-minor-mode "F")

;; (require 'git-messenger)
;; (add-hook 'prog-mode-hook (lambda ()
;;                            (local-set-key (kbd "C-c v p")
;;         'git-messenger:popup-message)
;;         ))



;; (require 'ace-isearch)
;; (global-ace-isearch-mode +1)
