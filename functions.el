;; -*- mode: Emacs-Lisp -*-
;; This is bindings loaded by user.el
(require 'todotxt)
(require 'multiple-cursors)
(require 'expand-region)
(require 'avy)
(require 'dired-x)
(require 'openwith)
(require 'savehist)
(require 'goto-last-change)
(require 'ivy-dired-history)
(require 'ace-jump-zap)
(require 'visible-mark)
(require 'dash)
(require 'find-dired)
(require 'visual-regexp)
(require 'visual-regexp-steroids)
(require 'transpose-frame)
(require 'desktop)
(require 'eyebrowse)
(require 'peep-dired)
(require 'tiny)
(require 'magithub)
(require 'dired-aux)
(require 'dired-ranger)
(require 'dired-narrow)
(require 'dired-filter)
(require 'whole-line-or-region)
(require 'backup-each-save)
(require 'wttrin)
(require 'frame-cmds)
(require 'f)
(require 'dired-aux)

;; (require 'evil-nerd-commenter)
;; (require 'counsel-etags)
(eval-when-compile (require 'cl))
;; (require 'dired-subtree)
;; Not installed but can use for two-pane dired work
;; (require 'sunrise-commander)

;; Needs to be installed but can be used for dedicatiing windows and reloading window configurations
;; (require 'window-purpose)

;; For alternative input methods (korean)
(setq alternative-input-methods
      '(("korean-hangul" . [?\M-\s-«])
	))
(setq default-input-method
      (caar alternative-input-methods))

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

(reload-alternative-input-methods)



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

(defun jj/forward-delete-sexp-or-dir (&optional p)
  "Kill forward sexp or directory.
If inside a string or minibuffer, and if it looks like
we're typing a directory name, kill forward until the next
/. Otherwise, `kill-sexp'"
  (interactive "p")
  (if (< p 0)
      (jj/backward-delete-sexp-or-dir (- p))
    (let ((r (point)))
      (if (and (or (in-string-p)
		   (minibuffer-window-active-p
		    (selected-window)))
	       (looking-at "[^[:blank:]\n\r]*[/\\\\]"))
	  (progn (search-forward-regexp
		  "[/\\\\]" nil nil p)
		 (delete-region r (point)))
	(jj/delete-sexp p)))))

(defun jj/backward-delete-sexp-or-dir (&optional p)
  "Kill backwards sexp or directory."
  (interactive "p")
  (if (< p 0)
      (jj/forward-delete-sexp-or-dir (- p))
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

(defun jj/forward-kill-sexp-or-dir (&optional p)
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



(defun jj/delete-sexp (&optional arg)
  "Kill the sexp (balanced expression) following point.
With ARG, kill that many sexps after point.
Negative arg -N means kill N sexps before point.
This command assumes point is not in a string or comment."
  (interactive "p")
  (let ((opoint (point)))
    (forward-sexp (or arg 1))
    (delete-region opoint (point))))

(defun jj/backward-delete-sexp (&optional arg)
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

(defun jj/backward-delete-word (arg)
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

(defun jj/split-window-4()
 "Splite window into 4 sub-window"
 (interactive)
 (if (= 1 (length (window-list)))
     (progn (split-window-vertically)
	    (split-window-horizontally)
	    (other-window 2)
	    (split-window-horizontally))))

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

(defun jj/window-split-toggle ()
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

(defun jj/goto-last-change ()
  (interactive)
  (when jj/last-change-pos1
    (let* ((buffer (find-file-noselect (car jj/last-change-pos1)))
	   (win (get-buffer-window buffer)))
      (if win
	  (select-window win)
	(switch-to-buffer-other-window buffer))
      (goto-char (cdr jj/last-change-pos1))
      (jj/swap-last-changes))))

(defun jj/buffer-change-hook (beg end len)
  (let ((bfn (buffer-file-name))
	(file (car jj/last-change-pos1)))
    (when bfn
      (if (or (not file) (equal bfn file)) ;; change the same file
	  (setq jj/last-change-pos1 (cons bfn end))
	(progn (setq jj/last-change-pos2 (cons bfn end))
	       (jj/swap-last-changes))))))

(defun jj/revert-all-buffers ()
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

(defun jj/switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

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
    (while (and (car file-list) (not (string= (car file-list) (concat "untitled~~" (number-to-string cnt) ".tmp"))))
      (setq file-list (cdr file-list)))
    (car file-list))

  (defun exsitp-untitled (file-list)
    (while (and (car file-list) (not (string= (car file-list) "untitled~~.tmp")))
      (setq file-list (cdr file-list)))
    (car file-list))

  (if (not (exsitp-untitled file-list))
      "untitled~~.tmp"
    (let ((cnt 2))
      (while (exsitp-untitled-x file-list cnt)
	(setq cnt (1+ cnt)))
      (concat "untitled~~" (number-to-string cnt) ".tmp")
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
  '("-alXGhF -HA  --group-directories-first"  "-alXGhvF -HAL  --group-directories-first" "-alXGhvF -HA  --group-directories-first")
  "List of ls switches for dired to cycle among.")

(defun jj/dired-cycle-switches ()
  "Cycle through the list `dired-list-of-switches' of switches for ls"
  (interactive)
  (setq dired-list-of-switches
	(append (cdr dired-list-of-switches)
		(list (car dired-list-of-switches))))
  (dired-sort-other (car dired-list-of-switches))
   (dired-sort-toggle-or-edit)
)
(defun jj/dired-sort-by-time-switch-toggle ()
  "Sort by time not putting directories first"
  (interactive)
  (cond ((string= dired-actual-switches "-alXGhvF -HAU -t")
	 (dired-sort-other "-alXGhF -HA  --group-directories-first"))
	((string= dired-actual-switches "-alXGhv -HAU")
	 (dired-sort-other "-alXGhF -HA  --group-directories-first"))
	(t
	 (dired-sort-other "-alXGhvF -HAU")))
  (dired-sort-toggle-or-edit)
)

(defun jj/remove-elc-on-save ()
  "If you're saving an Emacs Lisp file, likely the .elc is no longer valid."
  (add-hook 'after-save-hook
	    (lambda ()
	      (if (file-exists-p (concat buffer-file-name "c"))
		  (delete-file (concat buffer-file-name "c"))))
	    nil
	    t))

(defun jj/brc-functions-file ()
    "Recompile the functions file to hook on exit emacs"
  (interactive)
  (byte-recompile-file "/Users/bigtyme/Dropbox/Programs/emacs/user/functions.el")
)

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

;;; --------------------------------------------------- adding words to flyspell
;; If ispell-personal-dictionary variable not set this won't work correctly
(defun jj/ispell-append-word (new-word)
  (let ((header "hunspell_personal_dic:")
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
    (when (file-readable-p file-name)
      (let* ((cur-words (eval (list read-words file-name)))
	     (all-words (delq header (cons new-word cur-words)))
	     (words (delq nil (remove-duplicates all-words :test 'string=))))
	(with-temp-file file-name
	  (insert (concat header
			  " Total word count is "
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

;; Still runs with using s-x
(defadvice kill-ring-save (before slick-copy-line activate compile)
  "When called interactively with no region, copy the sexp or line

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
	 (backward-sexp)
	 (mark-sexp)
	 (message "Copied sexp")
	 (list (mark) (point)))))))

;; *** Kill word/line without selecting
(defadvice kill-region (before slick-cut-line first activate compile)
  "When called interactively kill the current sexp or line.

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
	 (backward-sexp)
	 (mark-sexp)
	 (message "Killed sexp")
	 (list (mark) (point)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun jj/delete-line ()
;;   "Delete text from current position to end of line char.
;; This command does not push text to `kill-ring'."
;;   (interactive)
;;   (delete-region
;;    (point)
;;    (progn (end-of-line 1) (point)))
;;   (delete-char 1))

;; (defun my-browse-url-of-buffer-with-firefox ()
;;   "Same as `browse-url-of-buffer' but using Firefox.
;; You need Firefox's path in the path environment variable within emacs.
;; e.g.
;;  (setenv \"PATH\" (concat \"C:/Program Files (x86)/Mozilla Firefox/\" \";\" (getenv \"PATH\") ) )
;; On Mac OS X, you don't need to. This command makes this shell call:
;;  「open -a Firefox.app http://example.com/」"
;;   (interactive)
;;   (cond
;;    ((string-equal system-type "windows-nt") ; Windows
;;     (shell-command (concat "firefox file://" buffer-file-name)))
;;    ((string-equal system-type "gnu/linux")
;;     (shell-command (concat "firefox file://" buffer-file-name)))
;;    ((string-equal system-type "darwin") ; Mac
;;     (shell-command (concat "open -a Firefox.app file://" buffer-file-name)))))
