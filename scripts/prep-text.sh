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

echo 'STORY TO BODY...'

find build/html/ -type f -exec sed -i 's/<Story>/<Body>/ig' {} \;
find build/html/ -type f -exec sed -i 's/<\/Story>/<\/Body>/ig' {} \;

echo 'CONVERT WRAPPER TO XHTML...'

indesign_root='<\?xml version=\"1\.0\" encoding=\"UTF-8\" standalone=\"yes\"\?>\r?\n(<\?xml-stylesheet type=\"text\/xsl\" href=\"dungeon-world.*\.xsl\"\?>\r?\n)?<Root xmlns:aid=\"http:\/\/ns\.adobe\.com\/AdobeInDesign\/4\.0\/\">'

xhtml_root='<!DOCTYPE html PUBLIC "-\/\/W3C\/\/DTD XHTML 1.0 Transitional\/\/EN"
"http:\/\/www.w3.org\/TR\/xhtml1\/DTD\/xhtml1-transitional.dtd">
<html xmlns="http:\/\/www.w3.org\/1999\/xhtml">
<head>
	<meta http-equiv="content-type" content="text\/html; charset=utf-8"\/>
	<title><%= title %><\/title>	
	<link rel="stylesheet" type="text\/css" href="\/css\/all.css">
	<link href="http:\/\/fonts.googleapis.com\/css?family=Neuton:200,300,400,700,400italic|Josefin+Sans:700" rel="stylesheet" type="text\/css">
<\/head>
'

find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/$indesign_root/$xhtml_root/smi" {} \;
find build/html/ -type f -exec sed -i 's/<\/Root>/<\/html>/ig' {} \;

echo 'DEMOTING H1s...'

find build/html/ -type f -exec sed -i 's/h1/h2/ig' {} \;

echo 'PROMOTE FIRST H2...'

find build/html/ -type f -exec sed -i '0,/h2/s/h2/h1/' {} \;
find build/html/ -type f -exec sed -i '0,/h2/s/h2/h1/' {} \;

echo 'FIX OUT OF BODY CONTENT...'

#find build/html/ -type f -exec perl -p -i -e "BEGIN{undef $/;} s/<\/head>(.*)<Body>/<\/head><Body>$1/smi" {} \;
find build/html/ -type f -exec sed -i 's/<Body>//i' {} \;
find build/html/ -type f -exec sed -i 's/<h1>/<Body><h1>/i' {} \;

echo 'INSERT TITLE ON PAGES...'

find build/html/ -type f -exec ./scripts/apply-title.sh {} \;

echo 'CONVERT INDESIGN CLASSES TO XHTML...'

find build/html/ -type f -exec sed -i 's/aid:[pc]style/class/ig' {} \;

echo 'RENAMING ClassName TAG to H1'

class_files=( Bard Cleric Druid Fighter Paladin Ranger Thief Wizard )

for i in "${class_files[@]}"
do
	sed -i 's/ClassName/h1/ig' "./build/html/$i.html"
done
#find wip/ -type f -exec sed -i 's/ClassName/h1/ig' {} \;

echo 'REFORMATTING MONSTERS...'

monster_files=( Caverns Depths Experiments Folk Hordes Planes Swamp Undead Woods )

for i in "${monster_files[@]}"
do
	perl -p -i -e 's/<p class="MonsterName">(.*)<\/p>/<h2>$1<\/h2>/smi' "./build/html/monster_settings/$i.html"
	perl -p -i -e 's/<span class="Tags">(.*)<\/span>/<em>$1<\/em>/smi' "./build/html/monster_settings/$i.html"
done

echo 'FIXING TITLES...'

sed -i 's/Moves in Detail/Class Moves in Detail/' ./build/html/Class_Moves_Discussion.html
sed -i 's/The world/The World/' ./build/html/The_World.html

echo 'FIXING TABLES...'

./scripts/fix-tables-in.py ./build/html/Character_Creation.html

echo 'COPYING HTML RESOURCES...'

cp -r resources/html/ build/html/