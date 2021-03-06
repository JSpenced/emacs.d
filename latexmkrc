# pdflatex and latex settings
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S; (test -f "%Z%R.synctex.gz") && (cp "%Z%R.synctex.gz" "%R.synctex.gz"); (test -f "%D") && (cp "%D" "%R.pdf")';

# lualatex settings
$lualatex = 'lualatex -interaction=nonstopmode -synctex=1 %O %S; (test -f "%Z%R.synctex.gz") && (cp "%Z%R.synctex.gz" "%R.synctex.gz"); (test -f "%D") && (cp "%D" "%R.pdf")';

# xelatex settings
$xelatex = 'xelatex -interaction=nonstopmode  -synctex=1 %O %S; (test -f "%Z%R.synctex.gz") && (cp "%Z%R.synctex.gz" "%R.synctex.gz")';
$xdvipdfmx = 'xdvipdfmx -o %D %S; (test -f "%D") && (cp "%D" "%R.pdf")';

# Output to a tmp folder and clean extensions
$out_dir = '/tmp';
$clean_ext = 'bbl rel %R-blx.bib %R.synctex.gz';


# Old settings from sublime/linux
# $pdf_mode = 1;
# $pdf_previewer = 'open -a skim';
# Settings for MAC from latexmk site
# $pdflatex = 'pdflatex  -interaction=nonstopmode -synctex=1 %O %S';
# $pdf_mode = 1;
# $pdf_previewer = 'open -a skim';
# $clean_ext = 'bbl rel %R-blx.bib %R.synctex.gz';
# @generated_exts = (@generated_exts, 'synctex.gz');

# Used for linux below
# $pdf_previewer = "start evince %O %S";
# $pdf_update_method = 1;
# $pdflatex = "pdflatex -interaction=nonstopmode -synctex=4"; 

# OLD BELOW
#$pdf_update_command = "evince %O %S";
# Need below if use epstopdf
#$pdflatex = "pdflatex -shell-escape -interaction=nonstopmode -synctex=4";
#$pdflatex = "pdflatex  -synctex=4";

# Not sure what file-line does
# $pdflatex = 'pdflatex -file-line-error -synctex=1 %O %S && (cp "%D" "%R.pdf") && (cp "%Z%R.synctex.gz" "%R.synctex.gz")';
