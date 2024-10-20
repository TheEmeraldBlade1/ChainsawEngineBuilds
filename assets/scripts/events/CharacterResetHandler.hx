import funkin.modding.module.Module;
import funkin.modding.module.ModuleHandler;
import funkin.modding.events.SongLoadScriptEvent;
import funkin.play.PlayState;

import funkin.play.character.CharacterDataParser;
import funkin.play.character.CharacterType;
import funkin.play.components.HealthIcon;

class CharacterResetHandler extends Module {

    function new() {
        super("CharacterResetHandler");
    }

    private var currentCharacterData;
    private var characterZIndexes = null;

    public override function onCountdownStart(event) {
        if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
		if (PlayState.instance.isMinimalMode) return;

        characterZIndexes = ["bf" => PlayState.instance.currentStage.getBoyfriend().zIndex, "gf" => PlayState.instance.currentStage.getGirlfriend().zIndex, "dad" => PlayState.instance.currentStage.getDad().zIndex];

        // trace("ZINDEXES: " + characterZIndexes);

        super.onCountdownStart(event);

        currentCharacterData = PlayState.instance.get_currentChart().characters;
    }

    override function onSongRetry(event) {
        if (PlayState.instance == null || PlayState.instance.currentStage == null) return;
		if (PlayState.instance.isMinimalMode) return;
        super.onSongRetry(event);
        
        // GF reset

        PlayState.instance.currentStage.getGirlfriend().destroy();
		var girlfriend = CharacterDataParser.fetchCharacter(currentCharacterData.girlfriend);
        if (girlfriend != null) {
            girlfriend.set_characterType(CharacterType.GF);
            PlayState.instance.currentStage.addCharacter(girlfriend, CharacterType.GF);
        }

        // BF reset

        PlayState.instance.currentStage.getBoyfriend().destroy();
		var boyfriend = CharacterDataParser.fetchCharacter(currentCharacterData.player);
        if (boyfriend != null) {
            boyfriend.set_characterType(CharacterType.BF);
            boyfriend.initHealthIcon(false);
            PlayState.instance.currentStage.addCharacter(boyfriend, CharacterType.BF);
        }

        // DAD reset

        PlayState.instance.currentStage.getDad().destroy();
		var dad = CharacterDataParser.fetchCharacter(currentCharacterData.opponent);
        if (dad != null) {
            dad.set_characterType(CharacterType.DAD);
            dad.initHealthIcon(true);
            PlayState.instance.currentStage.addCharacter(dad, CharacterType.DAD);
        }
    }
}