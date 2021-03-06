SetPackageInfo( rec(
	PackageName := "Origami",
	Subtitle := "Computing Veech groups of origamis",
	Version := "1.0.0",
	Date := "11/05/2020",
	AvailabilityTest := ReturnTrue,
	Status := "dev",

	PackageDoc := rec(
		BookName  := ~.PackageName,
		ArchiveURLSubset := ["doc"],
		HTMLStart := "doc/chap0.html",
		PDFFile   := "doc/Origami.pdf",
		SixFile   := "doc/manual.six",
		LongTitle := ~.Subtitle,
),

##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "1.0.0">
##  <!ENTITY RELEASEDATE "11 May 2020">
##  <!ENTITY RELEASEYEAR "2020">
##  <#/GAPDoc>

Dependencies := rec(
		GAP := "4.5.3",

		NeededOtherPackages := [["ModularGroup", "1.0.0"], ["Orb", "4.7.6"]],

		SuggestedOtherPackages := [
			["HomalgToCAS" ,"2018.06.15"],
			["IO_ForHomalg", "2017.09.02"],
			["IO", "4.5.1"],
			["RingsForHomalg", "2018.04.04"],
			["ArangoDBInterface", "2019.07.30"]
		],

		ExternalConditions := []

),

Persons := [
	rec(
		LastName      := "Junk",
		FirstNames    := "Luca",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "junk@math.uni-sb.de",
		WWWHome       := "http://www.math.uni-sb.de/ag/weitze/",
		PostalAddress := Concatenation( [
										 	"AG Weitze-Schmithüsen\n",
										 	"FR 6.1 Mathematik\n",
										 	"Universität des Saarlandes\n",
										 	"D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
),
  rec(
    LastName      := "Kattler",
    FirstNames    := "Pascal",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kattler@math.uni-sb.de",
    WWWHome       := "http://www.math.uni-sb.de/ag/weitze/",
    PostalAddress := Concatenation( [
                      "AG Weitze-Schmithüsen\n",
                      "FR 6.1 Mathematik\n",
                      "Universität des Saarlandes\n",
                      "D-66041 Saarbrücken" ] ),
    Place         := "Saarbrücken",
    Institution   := "Universität des Saarlandes"
  ),

	rec(
		LastName      := "Thevis",
		FirstNames    := "Andrea",
		IsAuthor      := true,
		IsMaintainer  := true,
		Email         := "thevis@math.uni-sb.de",
		WWWHome       := "http://www.math.uni-sb.de/ag/weitze/",
		PostalAddress := Concatenation( [
                       "AG Weitze-Schmithüsen\n",
                       "FR 6.1 Mathematik\n",
                       "Universität des Saarlandes\n",
                       "D-66041 Saarbrücken" ] ),
		Place         := "Saarbrücken",
		Institution   := "Universität des Saarlandes"
  ),
],



GithubUser := "PascalKattler",
GithubRepository := ~.PackageName,
GithubWWW := Concatenation("https://github.com/", ~.GithubUser, "/", ~.GithubRepository),

PackageWWWHome := Concatenation("https://", ~.GithubUser, ".github.io/", ~.GithubRepository, "/"),

ArchiveURL     := Concatenation( "https://github.com/PascalKattler/Origami/releases/download/Origami-", ~.Version, "/Origami-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML   := "<span class=\"pkgname\">Origami</span> is a package for computing the Veech group of square-tiled surfaces which are also known as origamis.",

ArchiveFormats := ".tar.gz .zip",
ArchiveURL     := Concatenation(~.GithubWWW,
                    "/releases/download/v", ~.Version, "/",
~.GithubRepository, "-", ~.Version),

) );
