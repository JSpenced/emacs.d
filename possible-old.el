;; -*- mode: Emacs-Lisp -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Move to new system changes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  emacs-lock-mode shorten mode-line on line 210 to " l:" and " L:"
;;
;; install lsp-python-ms as dotnet not working for python-language-server
;;
;; modified hl-todo--setup in hl-todo.el by replacing (setq hl-todo--regexp...
;; didn't work when I tried to add this function into user.el
;; Makes it so hl-todo-highlight-punctuation is recognized before keywords too
;; (setq hl-todo--regexp
;;       (concat "\\("
;;	      (and (not (equal hl-todo-highlight-punctuation ""))
;;		   (concat "[" hl-todo-highlight-punctuation "]*"))
;;	      "\\<"
;;	      (regexp-opt (mapcar #'car hl-todo-keyword-faces) t)
;;	      "\\>"
;;	      (and (not (equal hl-todo-highlight-punctuation ""))
;;		   (concat "[" hl-todo-highlight-punctuation "]*"))
;;	      "\\)"))
;; Further modified hl-todo so to insert keywords with a colon and
;; no space before comment on a new line (and double comments in emacs-lisp)
;; (defun hl-todo-insert-keyword (keyword)
;;   "Insert TODO or similar keyword.
;; If point is not inside a string or comment, then insert a new
;; comment.  If point is at the end of the line, then insert the
;; comment there, otherwise insert it as a new line before the
;; current line."
;;   (interactive
;;    (list (completing-read
;;           "Insert keyword: "
;;           (mapcar (pcase-lambda (`(,keyword . ,face))
;;                     (propertize keyword 'face
;;                                 (if (stringp face)
;;                                     (list :inherit 'hl-todo :foreground face)
;;                                   face)))
;;                   hl-todo-keyword-faces))))
;;   (cond
;;    ((hl-todo--inside-comment-or-string-p)
;;     (insert (concat (and (not (memq (char-before) '(?\s ?\t))) " ")
;;                     keyword
;;                     ":"
;;                     (and (not (memq (char-after) '(?\s ?\t ?\n))) " "))))
;;    ((eolp)
;;     (insert (concat (and (not (memq (char-before) '(?\s ?\t))) "")
;;                     (format "%s %s: "
;;                             (if (derived-mode-p 'lisp-mode 'emacs-lisp-mode)
;;                                 (format "%s%s" comment-start comment-start)
;;                               comment-start)
;;                             keyword)))
;;     (backward-char))
;;    (t
;;     (goto-char (line-beginning-position))
;;     (insert (format "%s %s: \n"
;;                     (if (derived-mode-p 'lisp-mode 'emacs-lisp-mode)
;;                         (format "%s%s" comment-start comment-start)
;;                       comment-start)
;;                     keyword))
;;     (backward-char)
;;     (indent-region (line-beginning-position) (line-end-position)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Remove with emacs 26.2 as new variable auto-save-no-message was added
;; custom autosave to suppress messages

;; For some reason `do-auto-save' doesn't work if called manually
;; after switching off the default autosave altogether. Instead set
;; to a long timeout so it is not called.
(setq auto-save-timeout 99999)

;; Set up my timer
(defvar bjm/auto-save-timer nil
  "Timer to run `bjm/auto-save-silent'")

;; Auto-save every 5 seconds of idle time
(defvar bjm/auto-save-interval 10
  "How often in seconds of idle time to auto-save with `bjm/auto-save-silent'")

;; Function to auto save files silently
(defun bjm/auto-save-silent ()
  "Auto-save all buffers silently"
  (interactive)
  (do-auto-save t))

;; Start new timer
(setq bjm/auto-save-timer
      (run-with-idle-timer 0 bjm/auto-save-interval 'bjm/auto-save-silent))


;; don't require-final-newline in todo.txt mode
;; originally used to prevent new lines in todo.txt (now unnecessary and
;; cause error with ice_recur if new line is present
(add-hook 'text-mode-hook
	  (lambda ()
	    (when (get-buffer "todo.txt")
	      (progn
		(with-current-buffer "todo.txt"
		  (interactive)
		  (setq require-final-newline nil))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-save after switching buffers or windows but don't seem to need this
;; If going to use, possibly needs modified (also look at super-save)
;; (defadvice switch-to-buffer (before save-buffer-now activate)
;;   (when buffer-file-name (do-auto-save t)))
;; (defadvice other-window (before other-window-now activate)
;;   (when buffer-file-name (do-auto-save t)))
;; (defadvice ace-window (before other-window-now activate)
;;   (when buffer-file-name (do-auto-save t)))
;; Probably don't need these as I think the other-window and switch-to-buffer above works fine
;; (defadvice next-multiframe-window (before other-window-now activate)
;;   (when buffer-file-name (do-auto-save)))
;; (defadvice previous-multiframe-window (before other-window-now activate)
;;   (when buffer-file-name (do-auto-save)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Possibly try this below
;; (require 'key-chord)
;; (key-chord-mode 1)
;; (key-chord-define-global "dd"  'kill-whole-line)
;; (key-chord-define-global "cc"  'yank-whole-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun jj/delete-line ()
  "Delete text from current position to end of line char.
This command does not push text to `kill-ring'."
  (interactive)
  (delete-region
   (point)
   (progn (end-of-line 1) (point)))
  (delete-char 1))

(defun my-browse-url-of-buffer-with-firefox ()
  "Same as `browse-url-of-buffer' but using Firefox.
You need Firefox's path in the path environment variable within emacs.
e.g.
 (setenv \"PATH\" (concat \"C:/Program Files (x86)/Mozilla Firefox/\" \";\" (getenv \"PATH\") ) )
On Mac OS X, you don't need to. This command makes this shell call:
 「open -a Firefox.app http://example.com/」"
  (interactive)
  (cond
   ((string-equal system-type "windows-nt") ; Windows
    (shell-command (concat "firefox file://" buffer-file-name)))
   ((string-equal system-type "gnu/linux")
    (shell-command (concat "firefox file://" buffer-file-name)))
   ((string-equal system-type "darwin") ; Mac
    (shell-command (concat "open -a Firefox.app file://" buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Possible ideas to implement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-i") 'some-function)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(my-keys-minor-mode 1)

(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

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


;; Possibly add below later as it lets you do case-insenstitive sorting
;; using ls-lisp with these settings gives case-insensitve
;; sorting on OS X
(require 'ls-lisp)
(setq dired-listing-switches "-a -lhG")
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-ignore-case t)
(setq ls-lisp-use-string-collate nil)
;; customise the appearance of the listing
(setq ls-lisp-verbosity '(links uid))
(setq ls-lisp-format-time-list '("%b %e %H:%M" "%b %e  %Y"))
(setq ls-lisp-use-localized-time-format t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup later
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eacl-complete-tag
;;
;; (defun jj/ag-collection (string)
;;   "Search for pattern STRING using ag.
;; We only have this as a separate function so we can assoc with sort function."
;;   ;; this will use counsel--async-command to run asynchronously
;;   (counsel-ag-function string counsel-ag-base-command ""))

;; ;; modified from https://github.com/abo-abo/swiper/wiki/Sort-files-by-mtime
;; (defun jj/ivy-sort-file-by-mtime-ag-collection (x y)
;;   "Determine if AG sort result X is newer than Y."
;;   (let* ((x (concat counsel--git-grep-dir (car (split-string x ":"))))
;;	 (y (concat counsel--git-grep-dir (car (split-string y ":"))))
;;	 (x-mtime (nth 5 (file-attributes x)))
;;	 (y-mtime (nth 5 (file-attributes y))))
;;     (time-less-p y-mtime x-mtime)))

;; ;; ivy uses the ivy-sort-functions-alist to look up suitable sort
;; ;; functions for any given collection function
;; ;; we add a cons cell specifying jj/ivy-sort-file-by-mtime as the sort
;; ;; function to go with our collection function
;; (add-to-list 'ivy-sort-functions-alist
;;	     '(jj/ag-collection . jj/ivy-sort-file-by-mtime-ag-collection))

;; (defun jj/counsel-ag (&optional initial-input initial-directory extra-ag-args ag-prompt)
;;   "Grep for a string in the current directory using ag.
;; INITIAL-INPUT can be given as the initial minibuffer input.
;; INITIAL-DIRECTORY, if non-nil, is used as the root directory for search.
;; EXTRA-AG-ARGS string, if non-nil, is appended to `counsel-ag-base-command'.
;; AG-PROMPT, if non-nil, is passed as `ivy-read' prompt argument.

;; Modified by cpbotha: Sort results last modified file first."
;;   (interactive)
;;   (when current-prefix-arg
;;     (setq initial-directory
;;	  (or initial-directory
;;	      (read-directory-name (concat
;;				    (car (split-string counsel-ag-base-command))
;;				    " in directory: "))))
;;     (setq extra-ag-args
;;	  (or extra-ag-args
;;	      (let* ((pos (cl-position ?  counsel-ag-base-command))
;;		     (command (substring-no-properties counsel-ag-base-command 0 pos))
;;		     (ag-args (replace-regexp-in-string
;;			       "%s" "" (substring-no-properties counsel-ag-base-command pos))))
;;		(read-string (format "(%s) args:" command) ag-args)))))
;;   (ivy-set-prompt 'jj/counsel-ag #'counsel-prompt-function-default)
;;   (setq counsel--git-grep-dir (or initial-directory default-directory))
;;   (ivy-read (or ag-prompt (car (split-string counsel-ag-base-command)))
;;	    #'jj/ag-collection
;;	    :initial-input initial-input
;;	    :dynamic-collection t
;;	    ;; yes, we want to sort the results
;;	    :sort t
;;	    :keymap counsel-ag-map
;;	    :history 'counsel-git-grep-history
;;	    :action #'counsel-git-grep-action
;;	    :unwind (lambda ()
;;		      (counsel-delete-process)
;;		      (swiper--cleanup))
;;	    :caller 'jj/counsel-ag))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not using but good ideas below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree based sidebar like neotree (toggleable), dired-sidebar, sidebar (also does buffers and seems like sublime folder viewer), ztree (looks not as nice as neotree), project explorer (not updated since 2015), dirtree (old and not updated),

;; Add hook Turn off spell-checking in nxml-mode (turned on since derived from text-mode hook)

;; (advice-add 'kill-region :before #'jj/slick-cut)
;; (advice-add 'kill-ring-save :before #'jj/slick-copy)
;; Make bindings for cut-line or region (univ arg cuts whole buffer so more func than jj/slick-copy)
;; (global-set-key (kbd "<f2>") 'jj/cut-line-or-region) ; cut
;; (global-set-key (kbd "<f3>") 'jj/copy-line-or-region) ; copy

;; (defun sylvain/desktop-owner-advice (original &rest args)
;;   (let ((owner (apply original args)))
;;     (if (and owner (/= owner (emacs-pid)))
;;         (and (car (member owner (list-system-processes)))
;;              (let (cmd (attrlist (process-attributes owner)))
;;                (if (not attrlist) owner
;;                  (dolist (attr attrlist)
;;                    (and (string= "comm" (car attr))
;;                         (setq cmd (car attr))))
;;                  (and cmd (string-match-p "[Ee]macs" cmd) owner))))
;;       owner)))
;; ;; Ensure that dead system processes don't own it.
;; (advice-add #'desktop-owner :around #'sylvain/desktop-owner-advice)

;; (defun get-newest-file-from-dir  (path)
;;   "Get latest file (including directory) in PATH."
;;   (car (directory-files path 'full nil #'file-newer-than-file-p)))

;; (require 'hungry-delete)
;; (global-hungry-delete-mode)

;; (setq myGraphicModeHash (make-hash-table :test 'equal :size 2))
;; (puthash "gui" t myGraphicModeHash)
;; (puthash "term" t myGraphicModeHash)

;; (defun emacsclient-setup-theme-function (frame)
;;   (let ((gui (gethash "gui" myGraphicModeHash))
;;         (ter (gethash "term" myGraphicModeHash)))
;;     (progn
;;       (select-frame frame)
;;       (when (or gui ter)
;;         (progn
;;           (load-theme 'monokai t)
;;           ;; setup the smart-mode-line and its theme
;;           (sml/setup)
;;           (sml/apply-theme 'dark)
;;           (if (display-graphic-p)
;;               (puthash "gui" nil myGraphicModeHash)
;;             (puthash "term" nil myGraphicModeHash))))
;;       (when (not (and gui ter))
;;         (remove-hook 'after-make-frame-functions 'emacsclient-setup-theme-function)))))

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions 'emacsclient-setup-theme-function)
;;   (progn (load-theme 'monokai t)
;;          (sml/setup)))

;; ;; Setup later to define read-only directories
;; ;; Define a read-only directory class
;; (dir-locals-set-class-variables 'read-only
;;  '((nil . ((buffer-read-only . t)))))

;; ;; Associate directories with the read-only class
;; (dolist (dir (list "/some/dir" "/some/other/dir"))
;;   (dir-locals-set-directory-class (file-truename dir) 'read-only))

;; (require 'flymake)
;; (flymake-mode 0)
;; (diminish 'flymake-mode "")

;; (require 'hideshow)
;; (add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1)))
;; (diminish 'hs-minor-mode "F")

;; (add-hook 'prog-mode-hook '(lambda () (linum-mode 1)))
