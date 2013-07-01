#! /bin/bash

echo 'BUILDING EPUB...'

pandoc -S --epub-stylesheet=resources/epub/epub.css --epub-metadata=resources/epub/metadata.xml -o build/dungeon-world.epub \
	build/html/Introduction.html \
	build/html/Playing_the_Game.html \
	build/html/Character_Creation.html \
	build/html/Moves.html \
	build/html/Bard.html \
	build/html/Cleric.html \
	build/html/Cleric_Spells.html \
	build/html/Druid.html \
	build/html/Fighter.html \
	build/html/Paladin.html \
	build/html/Ranger.html \
	build/html/Thief.html \
	build/html/Wizard.html \
	build/html/Wizard_Spells.html \
	build/html/GM.html \
	build/html/First_Session.html \
	build/html/Fronts.html \
	build/html/The_World.html \
	build/html/Monsters.html \
	build/html/monster_settings/Caverns.html \
	build/html/monster_settings/Swamp.html \
	build/html/monster_settings/Undead.html \
	build/html/monster_settings/Woods.html \
	build/html/monster_settings/Hordes.html \
	build/html/monster_settings/Experiments.html \
	build/html/monster_settings/Depths.html \
	build/html/monster_settings/Planes.html \
	build/html/monster_settings/Folk.html \
	build/html/Equipment.html \
	build/html/Advanced_Delving.html \
	build/html/appendices/Thanks.html \
	build/html/appendices/Teaching.html \
	build/html/appendices/Conversion.html \
	build/html/appendices/NPCs.html
