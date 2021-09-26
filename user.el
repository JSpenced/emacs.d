;; -*- mode: Emacs-Lisp -*-

;; needs to be loaded before markdown mode I think so put at the beginning
(setq markdown-header-scaling t)
(setq markdown-header-scaling-values '(1.25 1.15 1.1 1.05 1.0 1.0))

(if (file-exists-p (expand-file-name "~/Programs/scimax/user/definitions.el.snes"))
	(load "definitions.el.snes"))
(load "functions")
(load "bindings")
(load "settings")
;; if error stringp, nil (filename-extension: wrong-type argument) likely due to (desktop-read)

;; LOCATION based values
(setq calendar-latitude 20.66)
(setq calendar-longitude  -103.35)
(setq wttrin-default-cities '("Guadalajara, Mexico"))

(defun jj/delete-backward-char (n &optional killflag)
  "Delete the previous N characters (following if N is negative).
If Transient Mark mode is enabled, the mark is active, and N is 1,
delete the text in the region and deactivate the mark instead.
To disable this, set option `delete-active-region' to nil.

Optional second arg KILLFLAG, if non-nil, means to kill (save in
kill ring) instead of delete.  If called interactively, a numeric
prefix argument specifies N, and KILLFLAG is also set if a prefix
argument is used.

When killing, the killed text is filtered by
`filter-buffer-substring' before it is saved in the kill ring, so
the actual saved text might be different from what was killed.

In Overwrite mode, single character backward deletion may replace
tabs with spaces so as to back over columns, unless point is at
the end of the line."
  (declare (interactive-only delete-char))
  (interactive "p\nP")
  (unless (integerp n)
	(signal 'wrong-type-argument (list 'integerp n)))
  (cond ((and (use-region-p)
			  delete-active-region
			  (= n 1))
		 ;; If a region is active, kill or delete it.
		 (if (eq delete-active-region 'kill)
			 (kill-region (region-beginning) (region-end) 'region)
		   (funcall region-extract-function 'delete-only)))
		;; In Overwrite mode, maybe untabify while deleting
		((null (or (null overwrite-mode)
				   (<= n 0)
				   (memq (char-before) '(?\t ?\n))
				   (eobp)
				   (eq (char-after) ?\n)))
		 (let ((ocol (current-column)))
		   (delete-char (- n) killflag)
		   (save-excursion
			 (insert-char ?\s (- ocol (current-column)) nil))))
		;; Otherwise, do simple deletion.
		(t (delete-char (- n) killflag))))
(global-set-key [(control ?h)] 'jj/delete-backward-char)

;; Used to not show closed pull-requests by default
(setq forge-topic-list-limit '(60 . 3))
;; (global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-x C-n") 'dired-jump-other-window)

;; NOTE: Saves all org buffers instead of just agenda files
;; (defun my-org-mode-autosave-settings ()
;;   (add-hook 'auto-save-hook 'org-save-all-org-buffers nil nil))
;; (add-hook 'org-mode-hook 'my-org-mode-autosave-settings)

(define-prefix-command 'orgclock-map)
(global-set-key (kbd "s-SPC c") 'orgclock-map)
(define-key global-map (kbd "s-SPC i") 'org-clock-in)
(define-key global-map (kbd "s-SPC o") 'org-clock-out)
(define-key global-map (kbd "s-SPC g") 'org-clock-goto)
(define-key global-map (kbd "s-SPC l") 'org-clock-in-last)
(define-key orgclock-map (kbd "i") 'org-clock-in)
(define-key orgclock-map (kbd "o") 'org-clock-out)
(define-key orgclock-map (kbd "g") 'org-clock-goto)
(define-key orgclock-map (kbd "l") 'org-clock-in-last)
(define-key orgclock-map (kbd "c") 'org-clock-cancel)
(define-key orgclock-map (kbd "x") 'org-clock-cancel)
(define-key orgclock-map (kbd "r") 'org-clock-report)
(define-key orgclock-map (kbd "d") 'org-clock-display)
(define-key orgclock-map (kbd "D") 'org-clock-remove-overlays)
(setq org-clock-idle-time 15)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Do not prompt to resume an active clock, just resume it
;; (setq org-clock-persist-query-resume nil)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-agenda-clockreport-parameter-plist '(:stepskip0 t :link t :maxlevel 4 :fileskip0 t))
;; use pretty things for the clocktable
(setq org-pretty-entities t)
(setq org-log-into-drawer t)
;; Sets global clock-in and clock-out
;; (defun eos/org-clock-in ()
;; "Allows to select recent clocks."
;;   (interactive)
;;   (org-clock-in '(4)))
;; (global-set-key (kbd "C-c I") #'eos/org-clock-in)
;; (global-set-key (kbd "C-c O") #'org-clock-out)

(add-to-list 'org-speed-commands-user (cons "'" 'org-schedule))

(jj/append-to-list-no-duplicates 'helm-chronos-standard-timers
								 '("10/P: SQL + 8/P: SQL Solution"
								   "20/P: Code + 10/P: Code Solution"))

(setq switch-to-prev-buffer-skip 'visible)

(use-package keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
;; (setq keyfreq-excluded-commands
;;       '(self-insert-command
;;         next-line))
(use-package which-key)
(setq which-key-show-early-on-C-h t)
(eval-after-load "which-key" '(diminish 'which-key-mode ""))
(which-key-mode 1)

(global-set-key (kbd "<escape> 6") 'delete-indentation)


;; Setup current ssh to log to deep learning box
;; Need to use sshx (not sure why but ssh won't work)
(cond
 ((string-equal system-type "darwin")
  (setq tramp-default-method "scpx")
  (setq tramp-default-user "bigtyme")
  (setq tramp-default-host "gpu")
  (setq tramp-copy-size-limit 102400)
  (setq tramp-chunksize 2000)
  (setq my-tramp-ssh-completions
		'((tramp-parse-sconfig "~/.ssh/config")
		  (tramp-parse-shosts "~/.ssh/known_hosts")))
  (mapc (lambda (method)
		  (tramp-set-completion-function method my-tramp-ssh-completions))
		'("fcp" "rsync" "scp" "scpc" "scpx" "sftp" "ssh"))
  (setq recentf-exclude (append recentf-exclude  '("/ssh:" "/sshx:" "/scpx:" "/scp:" "/ftp:" "/ftpx:")))
  ))

(defmacro jj/advise-commands-after (advice-name commands &rest body)
  "Apply advice named ADVICE-NAME to multiple COMMANDS.

The body of the advice is in BODY."
  `(progn
	 ,@(mapcar (lambda (command)
				 `(defadvice ,command (after ,(intern (concat (symbol-name command) "-" advice-name)) activate)
					,@body))
			   commands)))

;; save all agenda buffers after completing the commands below
(jj/advise-commands-after "save-agendas"
						  ;; Place commands here
						  (org-agenda-kill jj/org-agenda-kill org-agenda-schedule org-agenda-archive-default-with-confirmation)
						  (jj/org-save-all-agenda-buffers))


;; NOTE: Can use this instead o fthe function below
;; Cancel the timer with one of the below:
;; (cancel-function-timers 'jj/org-save-all-agenda-buffers)
;; (cancel-timer jj/org-timer-save-agenda-buffers)
;; (setq jj/org-timer-save-agenda-buffers
;;	  (run-with-idle-timer 10 t 'jj/org-save-all-agenda-buffers))

;; save all the agenda files after each capture
(add-hook 'org-capture-after-finalize-hook 'jj/org-save-all-agenda-buffers)
(add-hook 'org-agenda-mode-hook 'jj/org-save-all-agenda-buffers)

;; FIXME: Not sure if this is working. Check later or ask on scimax
(setq save-abbrevs 'silently)
(setq abbrev-file-name "~/Programs/scimax/user/abbrev_defs")

(global-set-key (kbd "C-c M-t") 'transpose-words)
(global-set-key (kbd "M-s M-i") 'swiper-isearch-thing-at-point)
(global-set-key (kbd "M-s i") 'swiper-isearch)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-s-K")	'jj/kill-current-buffer-and-window)
(global-set-key (kbd "s-K")	'scimax-dispatch-mode-hydra)
(global-set-key (kbd "C-x M")	'scimax-dispatch-mode-hydra)
(global-set-key (kbd "C-x m")	'scimax-dispatch-mode-hydra)
(global-set-key (kbd "H-j")	'scimax-dispatch-mode-hydra)
(global-set-key (kbd "H-m")	'scimax-dispatch-mode-hydra)

(eval-after-load "org-gcal"
  '(progn
	 (setq org-agenda-files '())
	 (if (file-exists-p (expand-file-name org-gcal-file-main))
		 (setq org-agenda-files (append org-agenda-files (list org-gcal-file-main))))
	 (if (file-exists-p (expand-file-name "~/Dropbox/Documents/Notes/Work/gtd_work.org"))
		 (setq org-agenda-files (append org-agenda-files (list "~/Dropbox/Documents/Notes/Work/gtd_work.org"))))
	 (if (file-exists-p (expand-file-name "~/Dropbox/Documents/Notes/Orgzly/gtd.org"))
		 (setq org-agenda-files (append org-agenda-files (list "~/Dropbox/Documents/Notes/Orgzly/gtd.org"))))
	 (if (file-exists-p (expand-file-name "~/Dropbox/Documents/Notes/Orgzly/Inbox.org"))
		 (setq org-agenda-files (append org-agenda-files (list "~/Dropbox/Documents/Notes/Orgzly/Inbox.org"))))
	 ))


;; FIXME: All the below is working but an error with appt-check is
;; causing no timers from org or manually added to activate in the
;; echo area or as a reminder
(use-package calendar
  :after org-agenda
  :after org-gcal
  :init
  (require 'appt)
  (defvar terminal-notifier-path (executable-find "terminal-notifier") "The path to terminal-notifier.")
  (setq appt-time-msg-list nil)	;; clear existing appt list (assumes no diary file)
  (setq appt-display-interval (* 2 60)) ;; warn every 2 hours (only want the message to display once)
  (setq appt-audible nil				;; Don't have audible beep
		appt-message-warning-time '5 ;; send first warning 5 minutes before appointment
		appt-display-mode-line nil	 ;; don't show in the modeline
		appt-display-format 'window) ;; pass warnings to the designated window function
  (setq appt-disp-window-function (function jj/appt-display-native-timer-osx))
  :config
  (appt-activate 1)	;; activate appointment notification

  (defun jj/org-agenda-to-appt (&optional refresh filter &rest args)
	"Removes gcal file from org-agenda since displayed by
Native OSX apps. `Refresh` resets the appt list to nil and
recalculates the appt list."
	(interactive "P")
	(let ((save-agenda org-agenda-files))
	  (setq org-agenda-files (delete (format org-gcal-file-main) org-agenda-files))
	  (org-agenda-to-appt refresh)
	  (setq org-agenda-files save-agenda)))
  (defun jj/org-agenda-to-appt-reset ()
	"Removes gcal file from org-agenda since displayed by
Native OSX apps. Resets the appt list. Also call
org-agenda-to-appt with a ``universal prefix`` arg."
	(interactive)
	(jj/org-agenda-to-appt t))

  (cond
   ((and (string-equal system-type "darwin") (not (file-exists-p (concat (file-name-as-directory (car desktop-path))  desktop-base-lock-name))))
	;; Agenda-to-appointent hooks
	(jj/org-agenda-to-appt-reset) ;; generate the appt list from org agenda files on emacs launch
	(run-at-time "00:05:00" (* 1440 60) 'jj/org-agenda-to-appt-reset) ;; update appt list once a day
	(add-hook 'org-agenda-finalize-hook 'jj/org-agenda-to-appt-reset) ;; update appt list on agenda view
	))

  (defun jj/terminal-notifier-notify (title message)
	"Show a message with `terminal-notifier-command`."
	(start-process "terminal-notifier"
				   nil
				   terminal-notifier-path
				   "-title" title
				   "-message" message
				   "-sound" "alarm.wav"
				   ;; Emacs won't stay as alert/banner (use other apps then won't launch execute)
				   "-execute" "open -a Emacs"))

  (defun jj/appt-display-native-timer-osx (min-to-app new-time msg)
	(jj/terminal-notifier-notify
	 (format "Appointment in %s minutes" min-to-app)
	 (format "%s" msg))))

;; Add later
(setq org-capture-templates
	  '(("t" "todo [gtd]" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?")
		("f" "todo [gtd]" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?")
		("F" "todo [gtd, timestamp]" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?\n%^t")
		("j" "Todo [gtd, link]" entry
		 (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %i%?\n%a")
		;; %U inserts current inactive time-stamp
		;; :empty-lines 1 or any number to add at end
		("s" "Scheduled TODO" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?\nSCHEDULED: %^t")
		("w" "Work: Scheduled TODO" entry (file+headline "~/Dropbox/Documents/Notes/Work/gtd_work.org" "Tasks")
		 "* TODO %?\nSCHEDULED: %^t")
		("W" "Work: Todo [gtd, link]" entry
		 (file+headline "~/Dropbox/Documents/Notes/Work/gtd_work.org" "Tasks")
		 "* TODO %i%?\n%a")
		("d" "Deadline TODO" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?\nDEADLINE: %^t")
		("a" "todo priority A [gtd]" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO [#A] %?")
		("c" "Calendar/Reminder activity" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Calendar")
		 "* %?\n%^t")
		("S" "Scheduele+Deadline TODO" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?\nSCHEDULED: %^t DEADLINE: %^t")
		("D" "Scheduele+Deadline TODO" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO %?\nSCHEDULED: %^t DEADLINE: %^t")
		("A" "todo priority A [gtd, link]" entry (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Tasks")
		 "* TODO [#A] %i%?\n%a")
		("b" "Backlog" entry
		 (file+headline "~/Dropbox/Documents/Notes/Orgzly/gtd.org" "Backlog")
		 "* %i%?\n%a")))

;; FIXME: This was renamed and called during org-capture for some reason so alias necessary
(defalias 'scimax-define-src-key 'scimax-ob-define-src-key)

;; Sets a specific capture template to a key-binding
(define-key global-map (kbd "H-;") (lambda () (interactive) (org-capture nil "t")))
(define-key global-map (kbd "H-c") (lambda () (interactive) (org-capture nil "c")))
(define-key global-map (kbd "H-s") (lambda () (interactive) (org-capture nil "s")))
(define-key global-map (kbd "H-w") (lambda () (interactive) (org-capture nil "w")))
(define-key global-map (kbd "H-d") (lambda () (interactive) (org-capture nil "d")))


(defun jj/org-agenda-kill ()
  "Kill the entry or subtree belonging to the current agenda entry."
  (interactive)
  (or (eq major-mode 'org-agenda-mode) (error "Not in agenda"))
  (let* ((bufname-orig (buffer-name))
		 (marker (or (org-get-at-bol 'org-marker)
					 (org-agenda-error)))
		 (buffer (marker-buffer marker))
		 (pos (marker-position marker))
		 (type (org-get-at-bol 'type))
		 dbeg dend (n 0))
	(org-with-remote-undo buffer
	  (with-current-buffer buffer
		(save-excursion
		  (goto-char pos)
		  (if (and (derived-mode-p 'org-mode) (not (member type '("sexp"))))
			  (setq dbeg (progn (org-back-to-heading t) (point))
					dend (org-end-of-subtree t t))
			(setq dbeg (point-at-bol)
				  dend (min (point-max) (1+ (point-at-eol)))))
		  (goto-char dbeg)
		  (while (re-search-forward "^[ \t]*\\S-" dend t) (setq n (1+ n)))))
	  (when (or (eq t org-agenda-confirm-kill)
				(and (numberp org-agenda-confirm-kill)
					 (> n org-agenda-confirm-kill)))
		(let ((win-conf (current-window-configuration)))
		  (unwind-protect
			  (and
			   (prog2
				   (org-agenda-tree-to-indirect-buffer nil)
				   (not t)
				 (kill-buffer org-last-indirect-buffer))
			   (error "Abort"))
			(set-window-configuration win-conf))))
	  (let ((org-agenda-buffer-name bufname-orig))
		(org-remove-subtree-entries-from-agenda buffer dbeg dend))
	  (with-current-buffer buffer (delete-region dbeg dend))
	  (message "Agenda item and source killed"))))

(eval-after-load "org-agenda"
  '(progn
	 (setq org-agenda-restore-windows-after-quit t)
	 (setq org-agenda-sticky t)
	 (setq org-agenda-skip-deadline-prewarning-if-scheduled t)
	 ;; These already set to t by scimax I think (possibly change to below)
	 ;; (setq org-agenda-todo-ignore-scheduled 'future)
	 ;; (setq org-agenda-todo-ignore-deadlines 'far)
	 ;; (setq org-agenda-todo-ignore-timestamp 'future)
	 ;; (setq org-agenda-todo-ignore-with-date 'future)
	 ;; If set to t, ignore above in tags search as well
	 ;; (setq org-agenda-tags-todo-honor-ignore-options nil)
	 ;; (setq org-deadline-warning-days 7)
	 (define-prefix-command 'org-agenda-h-prefix-map)
	 (define-key org-agenda-mode-map (kbd "h") 'org-agenda-h-prefix-map)
	 (define-key org-agenda-mode-map (kbd "h f") 'jj/org-gcal-fetch-quick)
	 (define-key org-agenda-mode-map (kbd "h F") 'jj/org-gcal-archive-erase-then-fetch)
	 (define-key org-agenda-mode-map (kbd "h g") 'jj/org-gcal-archive-erase-then-fetch)

	 (define-key org-agenda-mode-map (kbd "C-k") 'org-agenda-kill)
	 (define-key org-agenda-mode-map (kbd "C-S-k") 'jj/org-agenda-kill)
	 (define-key org-agenda-mode-map (kbd "h k") 'jj/org-agenda-kill)
	 (define-key org-agenda-mode-map (kbd "<C-S-backspace>") 'jj/org-agenda-kill)
	 (define-key org-agenda-mode-map (kbd "M-k") 'jj/org-agenda-kill)))


(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit t)
  (define-key org-mode-map (kbd "C-c 1") (lambda () (interactive) (org-content 1)))
  (define-key org-mode-map (kbd "C-c 2") (lambda () (interactive) (org-content 2)))
  (define-key org-mode-map (kbd "C-c {") 'org-remove-file)
  (define-key org-mode-map (kbd "C-c 9") 'org-content)

  (defun org-dblock-write:weekly (params)
	"Writes  a file that specifies the number of minutes and hours worked that week in the file.
Use by putting the below in an org file and pressing C-c C-c.
#+BEGIN: weekly :tstart '<2020-05-11>' :tend '<now>'"
	(cl-flet ((fmttm (tm) (format-time-string (org-time-stamp-format t t) tm)))
	  (let ((file (or (plist-get params :file) (buffer-file-name)))
			(start (seconds-to-time
					(org-matcher-time (plist-get params :tstart))))
			(end (seconds-to-time (org-matcher-time (plist-get params :tend)))))
		(while (time-less-p start end)
		  (let ((next-week (time-add start
									 (date-to-time "1970-01-08T00:00Z")))
				(week-begin (line-beginning-position))
				(week-minutes 0))
			(insert "\nWeekly Table from " (fmttm start) "\n")
			(insert "| Day of Week | Mins | Hours |\n|-\n")
			(while (time-less-p start next-week)
			  (let* ((next-day (time-add start (date-to-time "1970-01-02T00:00Z")))
					 (minutes
					  (with-current-buffer (find-file-noselect file)
						(cadr (org-clock-get-table-data
							   file
							   (list :maxlevel 0
									 :tstart (fmttm start)
									 :tend (fmttm next-day)))))))
				(insert "|" (format-time-string "%a" start)
						"|" (format "%d" minutes)
						"|" (format "%.2f" (/ minutes 60.0))
						"|\n")
				(org-table-align)
				(incf week-minutes minutes)
				(setq start next-day)))
			(when (equal week-minutes 0)
			  (delete-region week-begin (line-beginning-position))))))))
  )

;; Sets the file from heading to different colors not the text
(add-hook 'org-agenda-finalize-hook 'org-agenda-set-category-colors)
(defun org-agenda-set-category-colors ()
  (save-excursion
	(org-agenda-color-category "gcal:" "gray16" "pink")
	(org-agenda-color-category "gtd:" "gray16" "lightblue")))
(defun org-agenda-color-category (category backcolor forecolor)
  (let ((re (rx-to-string `(seq bol (0+ space) ,category (1+ space)))))
	(save-excursion
	  (goto-char (point-min))
	  (while (re-search-forward re nil t)
		(add-text-properties (match-beginning 0) (match-end 0)
							 (list 'face (list :background backcolor :foreground forecolor)))))))

(defun jj/org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
		(pri-value (* 1000 (- org-lowest-priority priority)))
		(pri-current (org-get-priority (thing-at-point 'line t))))
	(if (= pri-value pri-current)
		subtree-end
	  nil)))

(defun jj/org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
	(if (string= (org-entry-get nil "STYLE") "habit")
		subtree-end
	  nil)))

;; TODO: The default priority is set to B and this makes it C (for sorting in org agenda)
(setq org-default-priority 68)
;; Change this to allow D(68),E(69) prorities
(setq org-lowest-priority 69)

;; Org-mode nicer agenda views
;; TODO: org-super-agenda cool and simple package for agenda views
(setq org-agenda-custom-commands
	  '(("L" "Todo tasks then Scheduled"
		 ((todo
		   "TODO"
		   ((org-agenda-overriding-header "=== TODO tasks without scheduled date ===")
			(org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
			(org-agenda-prefix-format '((todo . " %1c ")))))
		  (agenda
		   ""
		   ((org-agenda-overriding-header "=== Scheduled tasks ===")
			(org-agenda-span 22)
			(org-agenda-prefix-format '((agenda . " %1c %?-12t% s")))))))
		("l" "Scheduled then todo tasks (10 days)"
		 ((agenda
		   ""
		   ((org-agenda-overriding-header "=== Scheduled tasks ===")
			(org-agenda-span 10)
			(org-agenda-prefix-format '((agenda . " %1c %?-12t% s")))))
		  (todo
		   "TODO"
		   ((org-agenda-overriding-header "=== TODO tasks without scheduled date ===")
			(org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
			(org-agenda-prefix-format '((todo . " %1c ")))))))
		("d" "Weekly schedule (sched and deadline)" agenda ""
		 ((org-agenda-span 7) ;; agenda will start in week view
		  (org-agenda-repeating-timestamp-show-all t) ;; ensures that repeating events appear on all relevant dates
		  (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
		("D" "Upcoming deadlines" agenda ""
		 ((org-agenda-entry-types '(:deadline))
		  ;; a slower way to do the same thing
		  ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
		  (org-agenda-span 1)
		  (org-deadline-warning-days 60)
		  (org-agenda-time-grid nil)))
		("c" "Priority, fortnight agenda, todos"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority unfinished tasks:")))
		  (agenda "" ((org-agenda-span 14)))
		  (alltodo ""
				   ((org-agenda-skip-function
					 '(or (jj/org-skip-subtree-if-priority ?A)
						  (org-agenda-skip-entry-if 'todo '("MAYBE" "WAIT" "APPT"))
						  ))
					(org-agenda-overriding-header "All normal priority tasks:")))))
		("J" "Daily agenda and TODOs (no Maybe Wait Appt)"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority unfinished tasks:")))
		  (agenda "" ((org-agenda-span 1)))
		  (alltodo ""
				   ((org-agenda-skip-function '(or (jj/org-skip-subtree-if-priority ?A)
												   ;; Don't need this function now because already skipped
												   ;; (air-org-skip-subtree-if-habit)
												   (org-agenda-skip-entry-if 'todo '("MAYBE" "WAIT" "APPT"))
												   ;; Don't need because of my default agenda settings
												   ;; (org-agenda-skip-if nil '(scheduled deadline))
												   ))
					(org-agenda-overriding-header "ALL todo and next todos:")))
		  (alltodo ""
				   ((org-agenda-skip-function '(or (jj/org-skip-subtree-if-priority ?A)
												   ;; Don't need this function now because already skipped
												   ;; (air-org-skip-subtree-if-habit)
												   (org-agenda-skip-entry-if 'todo '("TODO" "NEXT"))
												   ;; Don't need because of my default agenda settings
												   ;; (org-agenda-skip-if nil '(scheduled deadline))
												   ))
					(org-agenda-overriding-header "ALL wait and maybe tasks:"))))
		 ;; Makes it so removes the equal lines to conserve space (move between with M-S-{
		 ;; ((org-agenda-compact-blocks t))
		 )
		("w" "Daily agenda and all TODOs (except Maybe Appt)"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority unfinished tasks:")))
		  (agenda "" ((org-agenda-span 1)))
		  (alltodo ""
				   ((org-agenda-skip-function '(or (jj/org-skip-subtree-if-priority ?A)
												   ;; Don't need this function now because already skipped
												   ;; (air-org-skip-subtree-if-habit)
												   (org-agenda-skip-entry-if 'todo '("MAYBE" "APPT"))
												   ;; Don't need because of my default agenda settings
												   ;; (org-agenda-skip-if nil '(scheduled deadline))
												   ))
					(org-agenda-overriding-header "ALL normal priority tasks:"))))
		 ;; Makes it so removes the equal lines to conserve space (move between with M-S-{
		 ;; ((org-agenda-compact-blocks t))
		 )
		("W" "Daily agenda and include all TODOs (Maybe, wait)"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority unfinished tasks:")))
		  (agenda "" ((org-agenda-span 1)))
		  (alltodo ""
				   ((org-agenda-skip-function '(or (jj/org-skip-subtree-if-priority ?A)
												   ))
					(org-agenda-overriding-header "ALL normal priority tasks:"))))
		 ;; Makes it so removes the equal lines to conserve space (move between with M-S-{
		 ;; ((org-agenda-compact-blocks t))
		 )
		("j" "Daily agenda only"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority A unfinished tasks:")))
		  (agenda "" ((org-agenda-span 1)))
		  (tags "PRIORITY=\"B\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority B unfinished tasks:")))
		  (alltodo ""
				   ((org-agenda-skip-function
					 '(or (jj/org-skip-subtree-if-priority ?A)
						  (org-agenda-skip-entry-if 'todo '("TODO" "MAYBE" "WAIT" "NEXT" "STARTED"))
						  ))
					(org-agenda-overriding-header "All normal priority tasks:")))
		  )
		 )
		("A" "Priority, one week agenda, 24hrs scheduled"
		 ((tags "PRIORITY=\"A\""
				((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
				 (org-agenda-overriding-header "High-priority unfinished tasks:")))
		  (agenda "" ((org-agenda-skip-function '(jj/org-agenda-skip-function-scheduled-one-day 'agenda))
					  (org-agenda-span 7)))
		  (alltodo ""
				   ((org-agenda-skip-function
					 '(or (jj/org-skip-subtree-if-priority ?A)
						  (org-agenda-skip-entry-if 'todo '("MAYBE" "WAIT" "APPT"))
						  ))
					(org-agenda-overriding-header "All normal priority tasks:")))))
		("C" "Simple agenda"
		 ((agenda "")
		  (alltodo "")))
		("g" "My General Agenda"
		 ((tags "TODO={.*}"
				((org-agenda-files (list my/inbox))
				 (org-agenda-overriding-header "Inbox")
				 (org-tags-match-list-sublevels nil)
				 (org-agenda-sorting-strategy '(priority-down))))
		  (todo "WAIT"
				((org-agenda-overriding-header "Waiting")
				 (org-agenda-sorting-strategy '(priority-down))))
		  (tags "-{^@.*}+TODO={NEXT\\|TODO}"
				((org-agenda-overriding-header "Tasks Without Context")
				 (org-agenda-skip-function #'my/org-skip-inode-and-root)
				 (org-agenda-sorting-strategy
				  '(todo-state-down priority-down))))
		  (tags "TODO=\"TODO\"+work"
				((org-agenda-overriding-header "Active Work Projects")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-tags-match-list-sublevels nil)
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-leaves)
					(org-agenda-skip-subtree-if 'nottodo '("NEXT"))))))
		  (tags "TODO=\"TODO\"+work"
				((org-agenda-overriding-header "Stuck Work Projects")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-tags-match-list-sublevels nil)
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-leaves)
					(org-agenda-skip-subtree-if 'todo '("NEXT"))))))
		  (tags "TODO=\"TODO\"-work"
				((org-agenda-overriding-header "Active Projects")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-tags-match-list-sublevels nil)
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-leaves)
					(org-agenda-skip-subtree-if 'nottodo '("NEXT"))))))
		  (tags "TODO=\"TODO\"-work"
				((org-agenda-overriding-header "Stuck Projects")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-tags-match-list-sublevels nil)
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-leaves)
					(org-agenda-skip-subtree-if 'todo '("NEXT"))))))
		  (agenda ""
				  ((org-agenda-files (list my/inbox my/project my/birthdays))
				   (org-agenda-span 'day)))
		  (tags "@errand+TODO=\"NEXT\""
				((org-agenda-overriding-header "NEXT @errand")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@review+TODO=\"NEXT\""
				((org-agenda-overriding-header "NEXT @review")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@home+work+TODO=\"NEXT\""
				((org-agenda-overriding-header "NEXT work@home")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@home-work+TODO=\"NEXT\""
				((org-agenda-overriding-header "NEXT @home")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@read_watch_listen+TODO=\"NEXT\""
				((org-agenda-overriding-header "NEXT @read/watch/listen")
				 (org-agenda-sorting-strategy '(priority-down effort-up))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@errand+TODO=\"TODO\""
				((org-agenda-overriding-header "@errand")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@review+TODO=\"TODO\""
				((org-agenda-overriding-header "@review")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@home+work+TODO=\"TODO\""
				((org-agenda-overriding-header "work@home")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@home-work+TODO=\"TODO\""
				((org-agenda-overriding-header "@home")
				 (org-agenda-sorting-strategy '(priority-down))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))
		  (tags "@read_watch_listen+TODO=\"TODO\""
				((org-agenda-overriding-header "@read/watch/listen")
				 (org-agenda-sorting-strategy '(priority-down effort-up))
				 (org-agenda-skip-function
				  '(or
					(my/org-skip-inode-and-root)
					(org-agenda-skip-entry-if 'scheduled)))))))
		))


(defun jj/org-agenda-skip-function-scheduled-one-day (part)
  "Partitions things to decide if they should go into the agenda
'(agenda future-scheduled done). Modified so future scheduled is
in the next 24 hours. "
  (let* ((skip (save-excursion (org-entry-end-position)))
		 (dont-skip nil)
		 (scheduled-time (org-get-scheduled-time (point)))
		 (result
		  (or (and scheduled-time
				   (time-less-p (time-add (current-time) (* 24 60 60)) scheduled-time)
				   'future-scheduled) ; This is scheduled for a future date
			  (and (org-entry-is-done-p) ; This entry is done and should probably be ignored
				   'done)
			  'agenda)))	 ; Everything else should go in the agenda
	(if (eq result part) dont-skip skip)))

(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(auto-complete-mode t)
(setq ac-use-menu-map t)
(setq ac-modes (delq 'python-mode ac-modes))
;; (setq ac-auto-show-menu    0.2)
;; (setq ac-delay             0.2)
;; (setq ac-menu-height       20)
;; (setq ac-auto-start    2)
(setq company-minimum-prefix-length 2)
(setq company-idle-delay 0)
(setq company-show-numbers t)
;; (global-set-key (kbd "s-j") 'ac-complete)
;; (define-key ac-complete-mode-map (kbd "s-j") 'ac-complete)
(define-key ac-complete-mode-map (kbd "M-j") 'ac-complete)
;; (define-key company-active-map (kbd "s-j") 'company-complete-selection)
(define-key company-active-map (kbd "M-j") 'company-complete-selection)
(define-key company-active-map [return] 'company-complete-selection)

(use-package company-tabnine
  :ensure t
  :after company
  :bind (("s-j" . company-tabnine))
  :config
  (add-to-list 'company-backends #'company-tabnine))

(defun jj/split-line-move-down (&optional arg)
  "Run split line and move down to the next line, so like hitting
enter but brings you to the same level. "
  (interactive "p")
  (split-line arg)
  (next-line))
(global-set-key (kbd "M-j") 'jj/split-line-move-down)

(setq py-docstring-fill-column 88)
(setq py-comment-fill-column 88)
(setq flycheck-python-mypy-config '("mypy.ini" "setup.cfg" ".mypy.ini"))

(defun jj/local-python-mode-setup ()
  "Custom variables and behaviors for `python-mode'."
  (setq-local fill-column 88)
  (display-line-numbers-mode)
  (smartparens-strict-mode)
  ;; So indent-rigidly recognizes 4 spaces for identation
  (setq-local tab-stop-list (list 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  ;; (setq sp-autoskip-opening-pair nil)
  ;; (setq sp-autoskip-closing-pair nil)
  ;; With pylintrc the same as vs-code a minimal setting don't turn off anymore
  ;; (setq-local flycheck-disabled-checkers '(python-pylint))
  ;; FIXME: choose one of these
  ;; (electric-pair-local-mode)
  )

(eval-after-load "smartparens" '(diminish 'smartparens-mode ""))

(add-hook 'python-mode-hook 'jj/local-python-mode-setup)

(add-hook 'org-mode-hook 'smartparens-mode)

(global-set-key (kbd "M-Q") 'unfill-paragraph)
(global-set-key (kbd "C-x M-q") 'set-fill-column)
(global-set-key (kbd "s-<SPC> M-q") 'set-fill-column)
(global-set-key (kbd "s-<SPC> q") 'set-fill-column)
(defalias 'jj/insert-keyboard-characters-quoted 'quoted-insert)

(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

(use-package python-black
  :demand t
  :after python)

;; Use for remote directory completion
(eval-after-load 'ssh
  '(progn
	 (add-hook 'ssh-mode-hook
			   (lambda ()
				 (setq ssh-directory-tracking-mode t)
				 (shell-dirtrack-mode t)
				 (setq dirtrackp nil)))))

;; PDF printing from pdf-tools
(setq pdf-misc-print-programm "/usr/bin/lpr")
(setq pdf-misc-print-programm-args (quote ("-o media=Letter" "-o fitplot" "-o sides=one-sided")))
;; TODO: Setup functions to modify pdf-misc-print-programm-args
;; Other settings: "-o page-ranges=1-4,7,9-12" "-o outputorder=reverse" "-o fit-to-page" "-# 10"

;; NOTE: Rewrote this function to respect the below variable when nil don't ask
(setq dired-clean-confirm-killing-deleted-buffers nil)
(defun dired-clean-up-after-deletion (fn)
  "Clean up after a deleted file or directory FN.
Removes any expanded subdirectory of deleted directory.  If
`dired-x' is loaded and `dired-clean-up-buffers-too' is non-nil,
kill any buffers visiting those files, prompting for
confirmation.  To disable the confirmation, see
`dired-clean-confirm-killing-deleted-buffers'."
  (save-excursion (and (cdr dired-subdir-alist)
					   (dired-goto-subdir fn)
					   (dired-kill-subdir)))
  ;; Offer to kill buffer of deleted file FN.
  (when (and (featurep 'dired-x) dired-clean-up-buffers-too)
	(let ((buf (get-file-buffer fn)))
	  (and buf
		   (or (and dired-clean-confirm-killing-deleted-buffers
					(funcall #'y-or-n-p
							 (format "Kill buffer of %s, too? "
									 (file-name-nondirectory fn))))
			   (not dired-clean-confirm-killing-deleted-buffers))
		   (kill-buffer buf)))
	(let ((buf-list (dired-buffers-for-dir (expand-file-name fn))))
	  (and buf-list
		   (or (and dired-clean-confirm-killing-deleted-buffers
					(y-or-n-p (format (ngettext "Kill Dired buffer of %s, too? "
												"Kill Dired buffers of %s, too? "
												(length buf-list))
									  (file-name-nondirectory fn))))
			   (not dired-clean-confirm-killing-deleted-buffers))
		   (dolist (buf buf-list)
			 (kill-buffer buf))))))
;; NOTE: Set to not force a newline at the end of file
;; (setq mode-require-final-newline t)

;; TODO: Org-mode create matching brackets like programming modes

;; TODO: Right a function to read helm timers from file and reset variable and also function to reset to default
;; TODO: Look at turning off leuven theme and how it affects my current settings

;; TODO: Check this for ideas https://ladicle.com/post/config/#wgrep

;; TODO: Add dired-filter-group-saved-groups for Downloads and other folders (example below)
;; (("default"
;;   ("PDF"
;;    (extension . "pdf"))
;;   ("LaTeX"
;;    (extension "tex" "bib"))
;;   ("Org"
;;    (extension . "org"))
;;   ("Archives"
;;    (extension "zip" "rar" "gz" "bz2" "tar"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using but remove with upgrade to new version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
