#! /bin/bash

echo 'UPDATING SOURCE FROM GITHUB...'

cd source
git pull
cd ..

echo 'COPYING SOURCE TO WORKING DIRECTORY...'

rm -rf wip/
mkdir wip/
cp source/* wip/

echo 'RENAMING XML TO HTML...'

rename 's/.xml/.html/' wip/*.xml

echo 'RENAMING ClassName TAG to H1'

find wip/ -type f -exec sed -i 's/ClassName/h1/ig' {} \;

echo 'FIXING TITLES...'

sed -i 's/The world/The World/' wip/16-The\ World.html
#sed -i 's/Cavern Dwellers/Denizens of the Murky Swamp/' wip/17b-Denizens\ of\ the\ Murky\ Swamp.html
#sed -i 's/Cavern Dwellers/Legions of the Undead/' wip/17c-Legions\ of\ the\ Undead.html

sed -i 's/Moves in Detail/Class Moves in Detail/' wip/18a-Class\ Moves\ Discussion.html

echo 'DEMOTING H1s...'

find wip/ -type f -exec sed -i 's/h1/h2/ig' {} \;

echo 'PROMOTE FIRST H2...'

find wip/ -type f -exec sed -i '0,/h2/s/h2/h1/' {} \;
find wip/ -type f -exec sed -i '0,/h2/s/h2/h1/' {} \;

echo 'BUILDING EPUB...'

pandoc -S --epub-stylesheet=epub.css --epub-metadata=metadata.xml -o dungeon-world.epub title.txt \
	wip/1-Introduction.html \
	wip/2-Character\ Creation.html \
	wip/3-Moves.html \
	wip/4-Bard.html \
	wip/5-Cleric.html \
	wip/5a-Cleric\ Spells.html \
	wip/6-Fighter.html \
	wip/7-Paladin.html \
	wip/8-Ranger.html \
	wip/9-Thief.html \
	wip/10-Wizard.html \
	wip/10a-Wizard\ Spells.html \
	wip/11-Equipment.html \
	wip/12-GM\ Rules.html \
	wip/13-First\ Session.html \
	wip/14-Fronts.html \
	wip/15-Blood\ and\ Guts.html \
	wip/16-The\ World.html \
	wip/17-Monsters.html \
	wip/17a-Cavern\ Dwellers.html \
	wip/17b-Denizens\ of\ the\ Murky\ Swamp.html \
	wip/17c-Legions\ of\ the\ Undead.html \
	wip/17d-Gnarled\ Woods.html \
	wip/17e-The\ Ravenous\ Hordes.html \
	wip/17f-Twisted\ Experiments.html \
	wip/17g-Creatures\ of\ the\ Lower\ Depths.html \
	wip/17h-Planar\ Powers.html \
	wip/17i-Folk.html \
	wip/18-Moves\ Discussion.html \
	wip/18a-Class\ Moves\ Discussion.html \
	wip/19-Advanced\ Delving.html \
	wip/a1-Thanks.html \
	wip/a2-Teaching.html \
	wip/a3-Conversion.html \
	wip/a4-NPCs.html