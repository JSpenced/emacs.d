;;; Compiled snippets and support files for `rst-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'rst-mode
					 '(("tit" "${1:$(make-string (string-width text) ?\\=)}\n${1:Title}\n${1:$(make-string (string-width text) ?\\=)}\n\n$0" "Document title" nil nil nil "/Users/spence/Programs/scimax/user/snippets/rst-mode/tit" nil nil)
					   ("sec" "${1:Section}\n${1:$(make-string (string-width text) ?\\-)}\n\n$0" "Section title" nil nil nil "/Users/spence/Programs/scimax/user/snippets/rst-mode/sec" nil nil)
					   ("chap" "${1:Chapter}\n${1:$(make-string (string-width text) ?\\=)}\n\n$0" "Chapter title" nil nil nil "/Users/spence/Programs/scimax/user/snippets/rst-mode/chap" nil nil)))


;;; Do not edit! File generated at Sat Mar  6 11:29:12 2021
