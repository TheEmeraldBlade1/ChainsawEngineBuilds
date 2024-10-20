import funkin.play.PlayState;
import funkin.play.event.SongEvent;

import funkin.modding.module.Module;
import funkin.modding.module.ModuleHandler;

import funkin.play.character.CharacterDataParser;
import funkin.play.character.CharacterType;
import funkin.play.components.HealthIcon;

class ChangeCharacterEvent extends SongEvent {

	public override function handleEvent(data) {
		if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
		if (PlayState.instance.isMinimalMode) return;

        var crh = ModuleHandler.getModule("CharacterResetHandler");

        var charData = CharacterDataParser.parseCharacterData(data.value.newchar.toLowerCase());
        CharacterDataParser.characterCache.h[CharacterDataParser.characterCache.h.length+1] = charData;

        // trace("CHARACTER ZINDEXES TWO THE SEQUEL: " + crh.scriptGet("characterZIndexes"));

		switch(data.value.character) {
			case 'bf':
                PlayState.instance.currentStage.getBoyfriend().destroy();
				var boyfriend = CharacterDataParser.fetchCharacter(data.value.newchar.toLowerCase());
                if (boyfriend != null) {
                    boyfriend.set_characterType(CharacterType.BF);
                    boyfriend.initHealthIcon(false);
                    PlayState.instance.currentStage.addCharacter(boyfriend, CharacterType.BF);
                    PlayState.instance.currentStage.getBoyfriend().zIndex = crh.scriptGet("characterZIndexes")["bf"];
                }
			case 'gf':
				PlayState.instance.currentStage.getGirlfriend().destroy();
				var girlfriend = CharacterDataParser.fetchCharacter(data.value.newchar.toLowerCase());
                if (girlfriend != null) {
                    girlfriend.set_characterType(CharacterType.GF);
                    PlayState.instance.currentStage.addCharacter(girlfriend, CharacterType.GF);
                    PlayState.instance.currentStage.getGirlfriend().zIndex = crh.scriptGet("characterZIndexes")["gf"];
                }
			case 'dad':
				PlayState.instance.currentStage.getDad().destroy();
				var dad = CharacterDataParser.fetchCharacter(data.value.newchar.toLowerCase());
                if (dad != null) {
                    dad.set_characterType(CharacterType.DAD);
                    dad.initHealthIcon(true);
                    PlayState.instance.currentStage.addCharacter(dad, CharacterType.DAD);
                    PlayState.instance.currentStage.getDad().zIndex = crh.scriptGet("characterZIndexes")["dad"];
                }
		}

        PlayState.instance.currentStage.refresh();
	}

	public function getEventSchema() {
		return [
            {
                name: "character",
                title: "Old Character",
                defaultValue: "bf",
				type: "enum",
				keys: [
					"boyfriend" => "bf",
					"girlfriend" => "gf",
					"dad" => "dad"
				]
            },
            {
                name: "newchar",
                title: "New Character (JSON)",
                defaultValue: "bf",
                type: "string",
            }
		];
	}

	public function getTitle() {
		return "Change Character";
	}
	
	public function new() {
		super('ChangeCharacter');
	}
}