#! /bin/bash

echo 'UPDATING SOURCE FROM GITHUB...'

cd source
git pull -u
cd ..

echo 'COPYING SOURCE TO WORKING DIRECTORY...'

rm -rf build/html/
mkdir -p build/html/
cp -r source/text/* build/html/

echo 'RENAMING XML TO HTML...'

rename 's/.xml/.html/' build/html/*.xml
rename 's/.xml/.html/' build/html/appendices/*.xml
rename 's/.xml/.html/' build/html/monster_settings/*.xml

echo 'STORY TO body...'

find build/html/ -type f -exec perl -p -i -e 'BEGIN{undef $/;} s/<Story>/<body>/smi' {} \;
find build/html/ -type f -exec perl -p -i -e 'BEGIN{undef $/;} s/<\/Story>/<\/body>/smi' {} \;

echo 'CONVERT WRAPPER TO XHTML...'

indesign_root='<\?xml version=\"1\.0\" encoding=\"UTF-8\" standalone=\"yes\"\?>\r?\n(<\?xml-stylesheet type=\"text\/xsl\" href=\"dungeon-world.*\.xsl\"\?>\r?\n)?<Root xmlns:aid=\"http:\/\/ns\.adobe\.com\/AdobeInDesign\/4\.0\/\">'

xhtml_root='<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text\/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title><%= title %><\/title>
    <link href="\/css\/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="\/css\/bootstrap-responsive.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text\/css" href="\/css\/all.css">
	<link href="http:\/\/fonts.googleapis.com\/css?family=Neuton:200,300,400,700,400italic|Josefin+Sans:700" rel="stylesheet" type="text\/css">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="\/js\/html5shiv.js"><\/script>
    <![endif]-->
<\/head>
'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/$indesign_root/$xhtml_root/smi" {} \;
find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<\/Root>/<\/html>/smi" {} \;

echo 'COPY IN INDEX...'

cp resources/html/home.html build/html/index.html

echo 'INSERTING NAV...'

nav=`cat resources/html/nav-top.html | sed 's/\//\\\\\//g'`

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<body>/$nav/smi" {} \;

echo 'FIX MOVES FOOTER'

perl -p -i -e "s/(<Story>|<\/Story>|<\/body>)//gsi" build/html/Moves.html
perl -p -i -e "s/<\/html>/<\/body><\/html>/si" build/html/Moves.html

echo 'INSERTING FOOTER...'

xhtml_footer='
    <\/div>

    <script>
      (function(i,s,o,g,r,a,m){i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,"script","\/\/www.google-analytics.com\/analytics.js","ga");

      ga("create", "UA-42061955-1", "dwgazetteer.com");
      ga("send", "pageview");
    <\/script>

    <script src="http:\/\/code.jquery.com\/jquery-1.10.1.min.js"><\/script>
    <script src="http:\/\/code.jquery.com\/jquery-migrate-1.2.1.min.js"><\/script>
    <script src="\/js\/bootstrap.min.js"><\/script>
<\/body>
'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<\/body>/$xhtml_footer/smi" {} \;

echo 'DEMOTING H1s...'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/h1/h2/gsi" {} \;

echo 'PROMOTE FIRST H2...'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/h2/h1/i" {} \;
find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/h2/h1/i" {} \;

echo 'FIX OUT OF body CONTENT...'

#find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<\/head>(.*)<body>/<\/head><body>$1/smi" {} \;
find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<body>//smi" {} \;
find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<h1>/<body><h1>/smi" {} \;

echo 'INSERT TITLE ON PAGES...'

find build/html/ -type f -exec ./scripts/apply-title.sh {} \;

echo 'CONVERT INDESIGN CLASSES TO XHTML...'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/aid:[pc]style/class/gsi" {} \;

echo 'RENAMING ClassName TAG to H1'

class_files=( Bard Cleric Druid Fighter Paladin Ranger Thief Wizard )

for i in "${class_files[@]}"
do
	perl -p -i -e 's/ClassName/h1/smi' "./build/html/$i.html"
done
#find wip/ -type f -exec sed -i 's/ClassName/h1/Ig' {} \;

echo 'REFORMATTING MONSTERS...'

monster_files=( Caverns Depths Experiments Folk Hordes Planes Swamp Undead Woods )

for i in "${monster_files[@]}"
do
	perl -p -i -e 's/<p class="MonsterName">(.*)<\/p>/<h2>$1<\/h2>/smi' "./build/html/monster_settings/$i.html"
	perl -p -i -e 's/<span class="Tags">(.*)<\/span>/<em>$1<\/em>/smi' "./build/html/monster_settings/$i.html"
done

echo 'FIXING TITLES...'

perl -p -i -e 's/Moves in Detail/Class Moves in Detail/' ./build/html/Class_Moves_Discussion.html
perl -p -i -e 's/The world/The World/' ./build/html/The_World.html

echo 'FIXING TABLES...'

./scripts/fix-tables-in.py ./build/html/Character_Creation.html

echo 'COPYING HTML RESOURCES...'

cp -r resources/html/ build/html/