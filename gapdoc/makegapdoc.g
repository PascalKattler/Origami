Read("load.g");
path := Directory("gapdoc");
main := "origami.xml";
files := [];
bookname := "Origami";
doc := ComposedDocument("GAPDoc", path, main, files, true);;
r := ParseTreeXMLString(doc[1], doc[2]);
CheckAndCleanGapDocTree(r);
t := GAPDoc2Text(r, path);;
GAPDoc2TextPrintTextFiles(t, path);
l := GAPDoc2LaTeX(r);;
FileString(Filename(path, Concatenation(bookname, ".tex")), l);
quit;