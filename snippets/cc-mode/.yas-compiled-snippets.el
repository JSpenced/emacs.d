;;; Compiled snippets and support files for `cc-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
					 '(("struct" "struct ${1:name}\n{\n    $0\n};" "struct ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/struct" nil nil)
					   ("once" "#ifndef ${1:_`(upcase (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))`_H_}\n#define $1\n\n$0\n\n#endif /* $1 */" "#ifndef XXX; #define XXX; #endif" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/once" nil nil)
					   ("main" "int main(int argc, char *argv[])\n{\n    $0\n    return 0;\n}\n" "int main(argc, argv) { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/main" nil nil)
					   ("inc.1" "#include <$1>\n" "#include <...>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/inc.1" nil nil)
					   ("inc" "#include \"$1\"\n" "#include \"...\"" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/inc" nil nil)
					   ("if" "if (${1:condition})\n{\n    $0\n}" "if (...) { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/if" nil nil)
					   ("for" "for (${1:int i = 0}; ${2:i < N}; ${3:++i})\n{\n    $0\n}" "for (...; ...; ...) { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/for" nil nil)
					   ("do" "do\n{\n    $0\n} while (${1:condition});" "do { ... } while (...)" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/do" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
					 '(("using" "using namespace ${std};\n$0" "using namespace ..." nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c++-mode/using" nil nil)
					   ("template" "template <typename ${T}>" "template <typename ...>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c++-mode/template" nil nil)
					   ("ns" "namespace " "namespace ..." nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c++-mode/ns" nil nil)
					   ("class" "class ${1:Name}\n{\npublic:\n    ${1:$(yas/substr text \"[^: ]*\")}($2);\n    virtual ~${1:$(yas/substr text \"[^: ]*\")}();\n};" "class ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c++-mode/class" nil nil)
					   ("beginend" "${1:v}.begin(), $1.end" "v.begin(), v.end()" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c++-mode/beginend" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
					 '(("printf" "printf (\"${1:%s}\\\\n\"${1:$(if (string-match \"%\" text) \",\" \"\\);\")\n}$2${1:$(if (string-match \"%\" text) \"\\);\" \"\")}" "printf" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c-mode/printf" nil nil)
					   ("fopen" "FILE *${fp} = fopen(${\"file\"}, \"${r}\");\n" "FILE *fp = fopen(..., ...);" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/c-mode/fopen" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
					 '(("using.2" "using System.$1;\n" "using System....;" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/using.2" nil nil)
					   ("using.1" "using System;\n" "using System;" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/using.1" nil nil)
					   ("using" "using $1;\n" "using ...;" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/using" nil nil)
					   ("region" "#region $1\n$0\n#endregion\n" "#region ... #endregion" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/region" nil nil)
					   ("prop" "/// <summary>\n/// $5\n/// </summary>\n/// <value>$6</value>\n$1 $2 $3\n{\n    get {\n        return this.$4;\n    }\n    set {\n        this.$4 = value;\n    }\n}\n" "property ... ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/prop" nil nil)
					   ("namespace" "namespace $1\n{\n$0\n}\n" "namespace .. { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/namespace" nil nil)
					   ("method" "/// <summary>\n/// ${5:Description}\n/// </summary>${2:$(if (string= (upcase text) \"VOID\") \"\" (format \"%s%s%s\" \"\\n/// <returns><c>\" text \"</c></returns>\"))}\n${1:public} ${2:void} ${3:MethodName}($4)\n{\n$0\n}\n" "public void Method { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/method" nil nil)
					   ("comment.3" "/// <exception cref=\"$1\">$2</exception>\n" "/// <exception cref=\"...\"> ... </exception>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/comment.3" nil nil)
					   ("comment.2" "/// <returns>$1</returns>\n" "/// <param name=\"...\"> ... </param>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/comment.2" nil nil)
					   ("comment.1" "/// <param name=\"$1\">$2</param>\n" "/// <param name=\"...\"> ... </param>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/comment.1" nil nil)
					   ("comment" "/// <summary>\n/// $1\n/// </summary>\n" "/// <summary> ... </summary>" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/comment" nil nil)
					   ("class" "${5:public} class ${1:Name}\n{\n    #region Ctor & Destructor\n    /// <summary>\n    /// ${3:Standard Constructor}\n    /// </summary>\n    public $1($2)\n    {\n    }\n\n    /// <summary>\n    /// ${4:Default Destructor}\n    /// </summary>    \n    public ~$1()\n    {\n    }\n    #endregion\n}\n" "class ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/class" nil nil)
					   ("attrib.2" "/// <summary>\n/// $3\n/// </summary>\nprivate $1 ${2:$(if (> (length text) 0) (format \"_%s%s\" (downcase (substring text 0 1)) (substring text 1 (length text))) \"\")};\n\n/// <summary>\n/// ${3:Description}\n/// </summary>\n/// <value><c>$1</c></value>\npublic ${1:Type} ${2:Name}\n{\n    get {\n        return this.${2:$(if (> (length text) 0) (format \"_%s%s\" (downcase (substring text 0 1)) (substring text 1 (length text))) \"\")};\n    }\n    set {\n        this.${2:$(if (> (length text) 0) (format \"_%s%s\" (downcase (substring text 0 1)) (substring text 1 (length text))) \"\")} = value;\n    }\n}\n" "private _attribute ....; public Property ... ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/attrib.2" nil nil)
					   ("attrib.1" "/// <summary>\n/// $3\n/// </summary>\nprivate $1 $2;\n\n/// <summary>\n/// $4\n/// </summary>\n/// <value>$5</value>\npublic $1 $2\n{\n    get {\n        return this.$2;\n    }\n    set {\n        this.$2 = value;\n    }\n}\n" "private attribute ....; public property ... ... { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/attrib.1" nil nil)
					   ("attrib" "/// <summary>\n/// $3\n/// </summary>\nprivate $1 $2;\n" "private attribute ....;" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/csharp-mode/attrib" nil nil)))


;;; Snippet definitions:
;;;
(yas-define-snippets 'cc-mode
					 '(("prop" "- (${1:id})${2:foo}\n{\n    return $2;\n}\n\n- (void)set${2:$(capitalize text)}:($1)aValue\n{\n    [$2 autorelease];\n    $2 = [aValue retain];\n}\n$0" "foo { ... } ; setFoo { ... }" nil nil nil "/Users/spence/Programs/scimax/user/snippets/cc-mode/objc-mode/prop" nil nil)))


;;; Do not edit! File generated at Sat Mar  6 11:29:11 2021
