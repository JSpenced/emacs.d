;;; Compiled snippets and support files for `snippet-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'snippet-mode
					 '(("vars" "# name : $1${2:\n# key : ${3:expand-key}}${4:\n# group : ${5:group}} \n# contributor : $6\n# --\n$0" "Snippet header" nil nil nil "/Users/spence/Programs/scimax/user/snippets/snippet-mode/vars" nil nil)
					   ("$m" "\\${${2:n}:${4:\\$(${5:reflection-fn})}\\}$0" "${n:$(...)} mirror" nil nil nil "/Users/spence/Programs/scimax/user/snippets/snippet-mode/mirror" nil nil)
					   ("$f" "\\${${1:${2:n}:}$3${4:\\$(${5:lisp-fn})}\\}$0" "${ ...  } field" nil nil nil "/Users/spence/Programs/scimax/user/snippets/snippet-mode/field" nil nil)))


;;; Do not edit! File generated at Sat Mar  6 11:29:12 2021
