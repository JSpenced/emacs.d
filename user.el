;; -*- mode: Emacs-Lisp -*-
;; This is an example user.el file for configuring jmax. Uncomment things you like.
;; Load functions and settings file that has all these defined for bindings below
(load "functions")
(load "bindings")
(load "settings")
;; Use for debugging
;; (error "No error until here")
(global-set-key (kbd "C-x C-s") nil)

(setq wttrin-default-cities '("Seoul" "Saint Louis, United States of America"))
;; '("Accept-Language" . "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4")
(setq wttrin-default-accept-language '("Accept-Language" . "en-US,en;q=0.8"))

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

(add-hook 'after-save-hook 'backup-each-save)
(setq backup-each-save-mirror-location "~/.emacs_path_backups")
;; Backup-save size limit is set to 5mb
(setq backup-each-save-size-limit (* 1024 1024 2))
(defun jj/backup-each-save-filter (filename)
  (let ((ignored-filenames
    	 '("^/tmp" "semantic.cache$" "\\.gpg$" "\\places$" "\\abbrev_defs$" "\\bookmarks$" "\\emacs_workgroups$"
	   "smex-items$" "\\recentf$" "\\.recentf$" "\\tramp$"
    	   "\\.mc-lists.el$" "\\.emacs.desktop$" "\\history$" ".newsrc\\(\\.eld\\)?"))
    	(matched-ignored-filename nil))
    (mapc
     (lambda (x)
       (when (string-match x filename)
    	 (setq matched-ignored-filename t)))
     ignored-filenames)
    (not matched-ignored-filename)))
(setq backup-each-save-filter-function 'jj/backup-each-save-filter)

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

;; auto save often
;; save every 20 characters typed (this is the minimum)
(setq auto-save-interval 5000)
;; number of seconds before auto-save when idle
(setq auto-save-timeout 30)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup settings                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.emacswiki.org/emacs/BackupFiles
(setq
 backup-inhibited nil	       ; enable backups
 backup-by-copying t	       ; don't clobber symlinks
 kept-new-versions 4	       ; keep 12 latest versions
 kept-old-versions 1	       ; don't bother with old versions
 delete-old-versions t	       ; don't ask about deleting old versions
 delete-by-moving-to-trash t
 version-control t		     ; number backups
 vc-make-backup-files t) ; backup version controlled files
;; Later maybe update the backup functions above so the tramp files are stored into their own
;; per-session and per-save directories
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp "~/.emacs_backups/per-save"))

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

(defvar jj/backup-exclude-regexp "\\.\\(vcf\\|gpg\\)$"
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

;; add to save hook
(add-hook 'before-save-hook 'jj/backup-every-save)

;; If sensitive mode is turned off then the autosave file will be created
;; and the backups will go to the trash due to the settings jj/backup-every-save
;; Can also use the below to make it sensitive-minor mode
;; // -*-mode:org; mode:sensitive; fill-column:132-*-
(setq auto-mode-alist
 (append '(("\\.gpg$" . sensitive-mode))
               auto-mode-alist))

(setq wg-use-default-session-file nil)
;; don't open last workgroup automatically in `wg-open-session',
;; I only want to check available workgroups! Nothing more.
(setq wg-session-file "~/Programs/scimax/user/emacs_workgroups")
(setq wg-load-last-workgroup nil)
(setq wg-open-this-wg nil)

;(workgroups-mode 1) ; put this one at the bottom of .emacs
;; by default, the sessions are saved in "~/.emacs_workgroups"
(autoload 'wg-create-workgroup "workgroups2" nil t)

(defun jj/wg-switch-workgroup ()
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
  
(require 'back-button)
(require 'nice-jumper)
(back-button-mode 1)
(global-nice-jumper-mode t)
(global-set-key (kbd "M-[")  'nice-jumper/backward)
(global-set-key (kbd "M-]") 'nice-jumper/forward)
(global-set-key (kbd "C-(") 'back-button-global-backward)
(global-set-key (kbd "C-)") 'back-button-global-forward)
(global-set-key (kbd "s-[") 'back-button-local-backward)
(global-set-key (kbd "s-]") 'back-button-local-forward)

;; ;; try autocomplete again for emacs-lisp
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(auto-complete-mode t)






;; ;; Setup later to define read-only directories
;; ;; Define a read-only directory class
;; (dir-locals-set-class-variables 'read-only
;;  '((nil . ((buffer-read-only . t)))))

;; ;; Associate directories with the read-only class
;; (dolist (dir (list "/some/dir" "/some/other/dir"))
;;   (dir-locals-set-directory-class (file-truename dir) 'read-only))

;; (when (locate-library "edit-server")
;;   (require 'edit-server)
;;   (setq edit-server-new-frame nil)
;;   (edit-server-start))

;; Possibly add below later as it lets you do case-insenstitive sorting
;; ;; using ls-lisp with these settings gives case-insensitve
;; ;; sorting on OS X
;; (require 'ls-lisp)
;; (setq dired-listing-switches "-alhG")
;; (setq ls-lisp-use-insert-directory-program nil)
;; (setq ls-lisp-ignore-case t)
;; (setq ls-lisp-use-string-collate nil)
;; ;; customise the appearance of the listing
;; (setq ls-lisp-verbosity '(links uid))
;; (setq ls-lisp-format-time-list '("%b %e %H:%M" "%b %e  %Y"))
;; (setq ls-lisp-use-localized-time-format t)




;; Possibly try this below
;; (require 'key-chord)
;; (key-chord-mode 1)
;; (key-chord-define-global "dd"  'kill-whole-line)
;; (key-chord-define-global "cc"  'yank-whole-line)

;; Possibly add in the below commands for save hooks on whitespace
;; (require 'whitespace)
;; (diminish 'whitespace-mode "ᗣ")
;; (diminish 'global-whitespace-mode "ᗣ")
;; (add-hook 'before-save-hook 'whitespace-cleanup)

;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
;; (define-key global-map (kbd "RET") 'newline-and-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup later
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eacl-complete-tag

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Not using but good ideas below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (advice-add 'kill-region :before #'jj/slick-cut)
;; (advice-add 'kill-ring-save :before #'jj/slick-copy)
;; Make bindings for cut-line or region (univ arg cuts whole buffer so more func than jj/slick-copy)
;; (global-set-key (kbd "<f2>") 'jj/cut-line-or-region) ; cut
;; (global-set-key (kbd "<f3>") 'jj/copy-line-or-region) ; copy


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using but remove with upgrade to new version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remove with emacs 26.2 as new variable auto-save-no-message was added
;; custom autosave to suppress messages
;;
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
