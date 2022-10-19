use strict;
use warnings;
use File::Find::Rule;
use File::Slurp qw(read_dir);
use Data::Dumper::Simple;
 
my $outputFilename = './latex/Cookbook.tex';

my $author = "author";
my $title = "title";
my $preface = "Lorem ipsum dolor sit amet,";
my $recipeTitle = "";
my $photoName = "";
my $portions = "";
my $cookTime = "";
my $quantity = "";
my $units = "";
my $ingredient = "";
my $anAction = "";
my $aNote = "";
my @files;
my $workingDir;
my $foreward;
my @fields = ();
my $root = 'Chapters';
my @chapterArr = "";

my $file = "./LaTeX/frontMatter.txt";

open(my $fh, '<:encoding(UTF-8)', $file)
  	or die "Could not open file '$file' $!";

sub recipeCheck 
{
    # passing argument
    my $var = $_[0];
	my $varName = $_[1];
	my $file = $_[2];
      
	if (!defined($var) or length($var) == 0)
	{
		print "Error with $varName in $file\n";
		die;
	}
}

# grab the front matter out of the frontMatter.txt file.
while (my $row = <$fh>) {
	
	chomp $row;
	@fields = split />/, $row;
	
	# Trim leading and trailing whitespace
	foreach $a (@fields){
	$a =~ s/^\s+|\s+$//g
	}
			
	if ( $fields[0] =~ /^a$/i ){
		$author = $fields[1];
	}
	
	if ( $fields[0] =~ /^t$/i ){
		$title = $fields[1];
	}
	
	if ( $fields[0] =~ /^p$/i ){
		$preface = $fields[1];
	}
}

close $fh;




open(my $fw, '>', $outputFilename) or die "Could not open file '$outputFilename' $!";

print $fw "%Created with csv2Latex.pl\n";
print $fw "%Pete Mills 2017\n";

print $fw "\n\n";

print $fw "\\documentclass[12pt,oneside]{memoir}\n";
print $fw "\n";
print $fw "\\usepackage{palatino}\n";
print $fw "\\usepackage[letterpaper,left=1.0in,right=1.0in,bindingoffset=0.0in]{geometry}\n";
print $fw "\\usepackage[nonumber]{cuisine}\n";
print $fw "\\usepackage{xcolor}\n";
print $fw "\\usepackage{float}\n";
print $fw "\\usepackage{graphicx}\n";
print $fw "\\graphicspath{ {images/} }\n";

print $fw "\n";

print $fw "\\setcounter{tocdepth}{2}\n";
print $fw "%\\setcounter{secnumdepth}{4}\n";

print $fw "\\newcommand\\invisiblesection[1]{%\n";
  print $fw "\\refstepcounter{section}%\n";
  print $fw "\\addcontentsline{toc}{section}{\\protect\\numberline{\\thesection}#1}%\n";
  print $fw "\\sectionmark{#1}}\n";

print $fw "\n\n";

print $fw "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%_BEGIN TITLE_%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%\n";

print $fw "\\makeatletter\n";

print $fw "\n";

print $fw "\\def\\maketitle{%\n";
  print $fw "\t\\null\n";
  print $fw "\t\\thispagestyle{empty}\n";
  print $fw "\t\\vfill\n";
  print $fw "\t\\begin{center}\\leavevmode\n";
    print $fw "\t\t\\normalfont\n";
    print $fw "\t\t{\\LARGE\\raggedleft \\\@author\\par}\n";
    print $fw "\t\t\\hrulefill\\par\n";
    print $fw "\t\t{\\huge\\raggedright \\\@title\\par}\n";
    print $fw "\t\t\\vskip 1cm\n";
    print $fw "\t\t%{\\Large \\\@date\\par}%\n";
  print $fw "\t\\end{center}%\n";
  print $fw "\t\\vfill\n";
  print $fw "\t\\null\n";
  print $fw "\t\\cleardoublepage\n";
print $fw "}\n";

print $fw "\n";

print $fw "\\makeatother\n";

print $fw "\n";

print $fw "\\author{$author}\n";
print $fw "\\title{$title}\n";
print $fw "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%_END TITLE_%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%\n";

print $fw "\n\n\n";

print $fw "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%_BEGIN DOCUMENT_%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%\n";

print $fw "\\begin{document}\n";

print $fw "\n";

print $fw "\\newcommand{\\recipeName}{blank}\n";
print $fw "\\newcommand{\\myImageScalar}{0.75}\n";

print $fw "\n";

print $fw "\\let\\cleardoublepage\\clearpage\n";
print $fw "\\maketitle\n";
print $fw "\\frontmatter\n";
print $fw "\\chapter*{Preface}\n";

#print $fw "\n";

print $fw "$preface";
print $fw "\\newpage";

#print $fw "\n";

print $fw "\% the asterisk means that the contents itself isn't put into the ToC\n";
print $fw "\\tableofcontents*\n";
print $fw "\\mainmatter\n";


# Read a list of directories to create the chapter names for the book
for my $dir (grep { -d "$root/$_" } read_dir($root)) {
    #print "$dir\n";
    push ( @chapterArr, $dir ); 
}

@chapterArr = grep /\S/, @chapterArr;	# Remove whitespace



#_+_+_+_+_+_+_ Loop this for each directory found _+_+_+_+_+_+_+_+#

foreach $workingDir ( @chapterArr ){
#print $workingDir . "\n";


	@files = File::Find::Rule->file()
							->name('*.txt')	# Get only these file types.
							->maxdepth(1)					# Directory depth to search.
							->in('./Chapters/'.$workingDir);
	
	# Use only the portion of the directory name to the right of the hyphen
	my @labelArr = split /-/, $workingDir;
	my $chapterLabel = $labelArr[1];
	$chapterLabel =~ s/^\s+|\s+$//g;	#trim whitespace
	
	print $fw "\n\n\n";
	
	print $fw "\\chapter{$chapterLabel}";
	#print $chapterLabel . "\n";
	
    foreach $a (@files){
		#print $a . "\n";
		
		# Start scanning directories for recipes
		my $inputFilename = $a;
		
		open(my $fr, '<:encoding(UTF-8)', $inputFilename)
  		or die "Could not open file '$inputFilename' $!";
		
		my @fields = ();
	
		#@#@#@#@#@#@#@#@# Loop this for each recipe found #@#@#@#@#@#@#@#@
		# Recipe Start
		print $fw "\n\n\n";
		print $fw "%_______________START RECIPE______________\n";
		print $fw "\n";

		print $fw "% Setup recipe name and image filename\n";

        # clear variables
        $aNote = "";
        $photoName = "none";
        
		# Build the recipe from the input file
		while (my $row = <$fr>) {
            
			# skip empty or whitespace lines
			next if ($row =~ /^\s*$/);
	
			chomp $row;
			@fields = split />/, $row;
	
			# Trim leading and trailing whitespace
			foreach $a (@fields){
			$a =~ s/^\s+|\s+$//g
			}
	
			# Index can be 'f' for forward or 't' for title, 'p' for picture, 's' for setup, 
			# 'i' for ingredient, 'a' for action, 'n' for note

			if ( $fields[0] =~ /^T$/i ){
				$recipeTitle = $fields[1];

                recipeCheck($recipeTitle, Dumper($recipeTitle), $inputFilename);

				print $fw "\\invisiblesection{$recipeTitle}\n";	# Add an invisible subsection to add to the TOC but wont show up here.
				print $fw "\\renewcommand{\\recipeName}{$recipeTitle}\n";
			}
	
			if ( $fields[0] =~ /^P$/i ){
				$photoName = $fields[1];
				
				print $fw "\\def \\imageName {./images/$photoName}\n";
				print $fw "% If no image, use a placeholder image instead\n";
				print $fw "\\IfFileExists{\\imageName}{}{\\def \\imageName{./images/placeHolder.jpg}} \n";
				print $fw "% End setup recipe name and image filename\n";
				print $fw "\n";
			}
	
			if ( $fields[0] =~ /^S$/i ){
				$portions = $fields[1];
				$cookTime = $fields[2];

                recipeCheck($portions, Dumper($portions), $inputFilename);
                recipeCheck($cookTime, Dumper($cookTime), $inputFilename);

				print $fw "\\begin{recipe}{\\recipeName}{$portions}{$cookTime} \n";
			}
			
			if ( $fields[0] =~ /^F$/i ){
				$foreward = $fields[1];
				print $fw "\\freeform $foreward";
			}
	
			if ( $fields[0] =~ /^I$/i ){
				$quantity = $fields[1];
				$units = $fields[2];
				$ingredient = $fields[3];

				recipeCheck($quantity, Dumper($quantity), $inputFilename);
				#recipeCheck($units, Dumper($units), $inputFilename);
				recipeCheck($ingredient, Dumper($ingredient), $inputFilename);

				print $fw "\t\\ingredient[$quantity]{$units}{$ingredient}\n";
			}
	
			if ( $fields[0] =~ /^A$/i ){
				$anAction = $fields[1];
				print $fw "\t$anAction\n";
			}
	
			if ( $fields[0] =~ /^N$/i ){
				$aNote = $fields[1];
				print $fw "\\end{recipe}\n";
				print $fw "\n";
		
				print $fw "\\begin{flushleft}\n";
					print $fw "\tNote: $aNote\n";
				print $fw "\\end{flushleft}\n";
			}
	
			#print "@fields\n"
		}

		close $fr;

		# If there is no note, end the recipe here. Otherwise, the recipe already ended in the note above.
		if ($aNote eq "")
		{
		  print $fw "\\end{recipe}\n";
		}

		print $fw "\n";

		if( $photoName ne "none" ){
			print $fw "\\begin{figure}[H]\n";
			print $fw "\t\\centering\n";
			print $fw "\t\\edef\\tmp{\\noexpand\\includegraphics[width=\\myImageScalar\\textwidth]{\\imageName}}\\tmp\n";
			print $fw "\t\\caption{\\recipeName}\n";
			print $fw "\\end{figure}\n";
		}
		
		print $fw "\n";

		print $fw "\\newpage\n";

		print $fw "\n";
		print $fw "%________________END RECIPE_______________\n";
		print $fw "\n\n\n";
		# Recipe End
		#@#@#@#@#@#@#@#@# Loop this for each recipe found #@#@#@#@#@#@#@#@
	}
}


#_+_+_+_+_+_+_ Loop this for each directory found _+_+_+_+_+_+_+_+#


print $fw "\n";

print $fw "\\end{document}\n";
print $fw "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%_END DOCUMENT_%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%\n";

close $fw;


print "LaTeX file generation complete.\n";