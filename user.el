;; -*- mode: Emacs-Lisp -*-
;; This is an example user.el file for configuring jmax. Uncomment things you like.
;; Load functions and settings file that has all these defined for bindings below

;; needs to be loaded before markdown mode I think so put at the beginning
(setq markdown-header-scaling t)
(setq markdown-header-scaling-values '(1.25 1.15 1.1 1.05 1.0 1.0))

;; change background for ivy and when searching in buffer to brighter (can barely see now)
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
    ;; (set-face-attribute 'markdown-header-face-1 nil :foreground "#f99157" :height 1.2)
    (set-face-attribute 'markdown-header-delimiter-face nil :inherit 'markdown-markup-face :foreground "Tomato3" :height 1.1 :bold t)
    ;; Default value below (shadow color)
    ;; (set-face-attribute 'markdown-header-delimiter-face nil :inherit 'markdown-markup-face :foreground nil)
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
	 (set-face-attribute 'diredp-omit-file-name nil :foreground "salmon"  :italic t :box t)
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

(load "functions")
(load "bindings")
(load "settings")
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

(set-face-attribute 'Man-overstrike nil :inherit 'bold :foreground "firebrick3")
(set-face-attribute 'Man-underline nil :inherit 'underline :foreground "green3")

;; setup later undo info
;; (setq undo-tree-auto-save-history t)
;; (setq undo-tree-history-directory-alist
;;       (quote (("" . "~/.local/var/emacs/undo_hist"))))
(setq undo-outer-limit (* 1024 1024 10))
(setq undo-strong-limit (* 1024 1024 6))
(setq undo-limit (* 1024 1024 5))

;; ;; Undo some previous changes.
;; (global-set-key (kbd "C-z") #'undo)
;; (global-set-key (kbd "<f11>") #'undo)

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

;; if error stringp, nil (filename-extension: wrong-type argument) likely due to (desktop-read)
;; (error "No error until here")
(defun jj/save-buffers-kill-terminal ()
  (interactive)
  (when (get-buffer "Downloads")
    (progn
      (with-current-buffer "Downloads"
	(interactive)
	(jj/emacs-lock-mode-off))))
  (save-buffers-kill-terminal))

(global-set-key (kbd "C-x C-s") nil)
(global-set-key (kbd "<escape> s") 'save-buffer)
(global-set-key (kbd "<escape> S") 'save-some-buffers)

(define-prefix-command 'jj-command-m-map)
(global-set-key (kbd "s-m") 'jj-command-m-map)
(global-set-key (kbd "M-g M") 'manual-entry)
(global-set-key (kbd "M-s-m") 'iconify-or-deiconify-frame)
(global-set-key (kbd "<escape> <backspace>") 'jj/delete-backward-bracket-pair)
(global-set-key (kbd "<escape> C-d") 'jj/delete-forward-bracket-pairs)
(global-set-key (kbd "<escape> M-h") 'jj/delete-backward-bracket-pair)
(global-set-key (kbd "<escape> s-h") 'Helper-describe-bindings)

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

(setq org-support-shift-select nil)
(setq org-list-allow-alphabetical t)
(setq org-list-demote-modify-bullet
      '(("+" . "-") ("-" . "*") ("*" . "+") ("1." . "a.") ("a." . "+") ("A." . "+") ("1)" . "a)") ("a)" . "1.") ("A)" . "1.")))

;; setup when start refiling notes
;; (setq org-refile-targets
;;       '(("gtd.org" :maxlevel . 1)
;;         ("done.org" :maxlevel . 1)))

;; (setq org-agenda-files
;;       '("gtd.org" "done.org"))

;; (setq org-refile-targets
;;       '((nil :maxlevel . 3)
;;         (org-agenda-files :maxlevel . 3)))
;; (setq org-outline-path-complete-in-steps nil)    ; Refile in a single go
;; also seen people set use-outline-path to 'file
;; (setq org-refile-use-outline-path t)             ; Show full paths for refiling
;; (setq org-refile-allow-creating-parent-nodes 'confirm)

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

;; untitled~~.tmp files will open into text-mode (
(add-to-list 'auto-mode-alist '("\\.qqq\\'" . text-mode))
;; symlinks under version control are followed to there real directory
;; only necessary if using emacs for controlling git (possibly remove later)
(setq vc-follow-symlinks t)

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

(add-to-list 'ivy-sort-functions-alist
	     '(read-file-name-internal . jj/ivy-sort-file-function))

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

;; (add-to-list 'ivy-sort-functions-alist
;;              '(read-file-name-internal . jj/ivy-sort-file-by-mtime))

;; don't require-final-newline in todo.txt mode
;; originally used to prevent new lines in todo.txt (now unnecessary and
;; cause error with ice_recur if new line is present
;; (add-hook 'text-mode-hook
;;	  (lambda ()
;;	    (when (get-buffer "todo.txt")
;;	      (progn
;;		(with-current-buffer "todo.txt"
;;		  (interactive)
;;		  (setq require-final-newline nil))))))

(require 'dtrt-indent)
(require 'clean-aindent-mode)
(require 'ws-butler)
(require 'whitespace-cleanup-mode)
;; Only use ws-butler in buffers where whitespace-cleanup-mode isn't turned on
(defun jj/ws-butler-mode-if-whitespace-initially-not-clean ()
  (interactive)
  (if (not whitespace-cleanup-mode-initially-clean)
      (ws-butler-mode)))
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

(setq hl-todo-highlight-punctuation "\-:*/~=#<>|\\")
;; Sets for every buffer so can run hl-todo-occur even if hl-todo-mode not enabled
(setq-default hl-todo--regexp "\\([-:*/~=#<>|\\\\]*\\<\\([?]\\{3,5\\}\\|UNSURE\\|FINISHED\\|DON[ET]\\|F\\(?:AIL\\|IXME\\)\\|H\\(?:ACK\\|OLD\\)\\|KLUDGE\\|N\\(?:EXT\\|OTE\\)\\|OKAY\\|PROG\\|T\\(?:EMP\\|HEM\\|ODO\\|0D0\\)\\|XXXX?\\)\\>[-:*/~=#<>|\\\\]*\\)")
(setq-default hl-todo-keyword-faces '(("HOLD" . "#d0bf8f") ("TODO" . "#cc9393") ("T0D0" . "#cc9393")
				      ("NEXT" . "#dca3a3") ("TOD0" . "#cc9393") ("TODOO" . "#cc9393")
				      ("THEM" . "#dc8cc3") ("PROG" . "#7cb8bb") ("OKAY" . "#7cb8bb")
				      ("DONT" . "#5f7f5f") ("FAIL" . "#8c5353") ("DONE" . "#afd8af")
				      ("FINISHED" . "#afd8af") ("UNSURE" . "#dc8cc3") ("T000" . "#cc9393")
				      ("NOTE" . "#d0bf8f") ("KLUDGE" . "#d0bf8f") ("HACK" . "#d0bf8f")
				      ("TEMP" . "#d0bf8f") ("FIXME" . "#cc9393") ("XXX" . "#cc9393")
				      ("XXXX" . "#cc9393") ("????" . "#cc9393") ("???" . "#cc9393")
				      ))
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

;; below uneccasry because hl-todo-mode is set by hl-todo-activate-in-modes
;; this defualts to (prog-mode text-mode) but not turned on in org-mode
(global-hl-todo-mode)
;; highlight todo, done, and fixme in prog-modes and latex-mode
;; (dolist (hook '(prog-mode-hook latex-mode-hook markdown-mode-hook ...))
;;   (add-hook hook (lambda ()
;;		   (hl-todo-mode))))

;; if using semantic might need this (removes print on opening buffer)
;; (setq dtrt-indent-verbosity 0)

;; use diminish to change minor-mode line or with no argument deletes it
;; can also be used to change major-mode lines
;; (eval-after-load "dubcaps" '(diminish 'dubcaps-mode))
(eval-after-load 'emacs-lock-mode '(diminish 'org-indent-mode))
(eval-after-load "org-indent" '(diminish 'org-indent-mode))
(eval-after-load "ws-butler" '(diminish 'ws-butler-mode " WB"))
(eval-after-load "dtrt-indent" '(diminish 'dtrt-indent-mode ""))
(eval-after-load "dired-x" '(diminish 'dired-omit-mode " Omt"))
(eval-after-load "dired-filter" '(diminish 'dired-filter-mode " Filter"))
(eval-after-load "dired-narrow" '(diminish 'dired-narrow-mode " Narrow"))
(eval-after-load "elpy" '(diminish 'elpy-mode " El"))
(eval-after-load "autorevert" '(progn (setq auto-revert-mode-text " AR")))
(eval-after-load "emacs-lock" '(diminish 'emacs-lock-mode
					 `("" (emacs-lock--try-unlocking " l:" " L:")
					   (:eval (substring (symbol-name emacs-lock-mode) 0 1) ))))

(require 'cyphejor)
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
   ("package"     "↓")
   ("python"      "π")			;Ƥ
   ("org"      "Ω")			;Ⓞ
   ("shell"       "sh" :postfix)
   ("help"       "Ήϵ")
   ("dired"       "Ɖ")			;Ⓓ
   ("text"        "Ŧ")
   ("wdired"      "𝓦Ɖ")))
(cyphejor-mode 1)

(require 'org-download)
(setq org-download-screenshot-method "screencapture -i %s")
;; will show space between headings if 1 or more lines blank (default 2)
(setq org-cycle-separator-lines 1)

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
	 '("^/tmp" "semantic.cache$" "\\.gpg$" "\\.pdf$" "\\places$" "\\abbrev_defs$" "\\bookmarks$" "\\emacs_workgroups$"
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

(require 'dumb-jump)
(setq dumb-jump-selector 'ivy)
(setq dumb-jump-prefer-searcher 'rg)
(define-prefix-command 'dumb-jump-map)
(global-set-key (kbd "M-g d") 'dumb-jump-map)
(global-set-key (kbd "M-g M-d") 'dumb-jump-go)
(global-set-key (kbd "M-g M-b") 'dumb-jump-back)
(define-key dumb-jump-map (kbd "j") 'dumb-jump-go)
(define-key dumb-jump-map (kbd "i") 'dumb-jump-go-prompt)
(define-key dumb-jump-map (kbd "l") 'dumb-jump-quick-look)
(define-key dumb-jump-map (kbd "o") 'dumb-jump-go-other-window)
(define-key dumb-jump-map (kbd "c") 'dumb-jump-go-current-window)
(define-key dumb-jump-map (kbd "b") 'dumb-jump-back)
(define-key dumb-jump-map (kbd "p") 'dumb-jump-back)
(define-key dumb-jump-map (kbd "x") 'dumb-jump-go-prefer-external)
(define-key dumb-jump-map (kbd "z") 'dumb-jump-go-prefer-external-other-window)

(setq
 helm-gtags-ignore-case nil
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-suggested-key-mapping t)

(define-prefix-command 'tags-jump-map)
(global-set-key (kbd "M-g t") 'tags-jump-map)
(global-set-key  (kbd "M-.") 'xref-find-definitions)
(global-set-key  (kbd "M-g .") 'helm-gtags-dwim)
(global-set-key  (kbd "M-g C-j") 'helm-gtags-select)
(global-set-key  (kbd "M-g j") 'helm-gtags-select)
(global-set-key  (kbd "M-g M-,") 'helm-gtags-show-stack)
(global-set-key  (kbd "M-g ,") 'helm-gtags-pop-stack)
(global-set-key  (kbd "M-g b") 'helm-gtags-previous-history)
(global-set-key  (kbd "M-g f") 'helm-gtags-next-history)
(global-set-key  (kbd "M-g M-.") 'ggtags-find-tag-dwim)
(define-key tags-jump-map  (kbd "g") 'counsel-gtags-dwim)
(define-key tags-jump-map  (kbd "t") 'counsel-gtags-dwim)
(define-key tags-jump-map  (kbd "r") 'counsel-gtags-find-reference)
(define-key tags-jump-map  (kbd "r") 'counsel-gtags-find-reference)
(define-key tags-jump-map  (kbd "o") 'helm-gtags-find-tag-other-window)
(define-key tags-jump-map  (kbd "i") 'helm-gtags-tags-in-this-function)
(define-key tags-jump-map  (kbd "j") 'helm-gtags-select)
(define-key tags-jump-map  (kbd "c") 'helm-gtags-create-tags)
(define-key tags-jump-map  (kbd "u") 'helm-gtags-update-tags)
(define-key tags-jump-map  (kbd "U") 'ggtags-update-tags)
(define-key tags-jump-map  (kbd "d") 'counsel-gtags-find-definition)
(define-key tags-jump-map  (kbd "s") 'counsel-gtags-find-symbol)
(define-key tags-jump-map  (kbd "b") 'counsel-gtags-go-backward)
(define-key tags-jump-map  (kbd "f") 'counsel-gtags-go-forward)

;; (use-package pdf-tools
;;   :pin manual ;; manually update
;;   :config
;;   ;; initialise
;;   (pdf-tools-install)
;;   ;; open pdfs scaled to fit page
;;   (setq-default pdf-view-display-size 'fit-page)
;;   ;; automatically annotate highlights
;;   (setq pdf-annot-activate-created-annotations t)
;;   ;; use normal isearch
;;   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;;   ;; turn off cua so copy works
;;   (add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))
;;   ;; more fine-grained zooming
;;   (setq pdf-view-resize-factor 1.1)
;;   ;; keyboard shortcuts
;;   (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
;;   (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
;;   (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))
(pdf-tools-install)
;; open pdfs scaled to fit page
(setq-default pdf-view-display-size 'fit-page)
;; automatically annotate highlights
(setq pdf-annot-activate-created-annotations t)
;; use normal isearch
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;; turn off cua so copy works
(add-hook 'pdf-view-mode-hook (lambda () (cua-mode 0)))
;; more fine-grained zooming
(setq pdf-view-resize-factor 1.1)
;; keyboard shortcuts
(define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
(define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
(define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete)


(require 'counsel-projectile)
(counsel-projectile-mode)
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

;; turn off auto-save-messages
(setq auto-save-no-message t)
;; auto save often
;; save every 20 characters typed (this is the minimum)
(setq auto-save-interval 60)
;; number of seconds before auto-save when idle
(setq auto-save-timeout 10)
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

(defvar jj/backup-exclude-regexp "\\.\\(vcf\\|gpg\\|pdf\\)$"
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
      (append '(("\\.gpg$" . sensitive-mode)
		;; ("\\.pdf$" . sensitive-mode)
		)
	      auto-mode-alist))

(setq wg-use-default-session-file nil)
;; don't open last workgroup automatically in `wg-open-session',
;; I only want to check available workgroups! Nothing more.
(setq wg-session-file "~/Programs/scimax/user/emacs_workgroups")
(setq wg-load-last-workgroup nil)
(setq wg-open-this-wg nil)

;;(workgroups-mode 1) ; put this one at the bottom of .emacs
;; by default, the sessions are saved in "~/.emacs_workgroups"
(autoload 'wg-create-workgroup "workgroups2" nil t)

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

;; Possibly use this to solve the above problem
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

(setq peep-dired-max-size (* 8 1024 1024))
(setq peep-dired-ignored-extensions '("mkv" "iso" "mp4" "xls" "avi" "mpg" "mpg" "mp3" "xlsx" "wav" "psd" "ppt" "pptx" "doc" "docx" "m4a"))
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
;; (setq dired-listing-switches "-a -lhG")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using but remove with upgrade to new version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
