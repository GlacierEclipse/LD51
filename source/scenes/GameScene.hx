package scenes;

import haxepunk.ParticleManager;
import haxepunk.debug.Console;
import haxepunk.input.Input;
import levels.LevelManager;
import haxepunk.Scene;

class GameScene extends Scene
{
	public var levelManager:LevelManager;

	override public function begin()
	{
		Upgrades.upgrades = new Array();
		Upgrades.upgrades.push(Upgrades.movementSpeed = new UpgradeValue(5));
		Upgrades.upgrades.push(Upgrades.rotationSpeed = new UpgradeValue(5));
		Upgrades.upgrades.push(Upgrades.blastsAmount = new UpgradeValue(20));
		Upgrades.upgrades.push(Upgrades.blastPower = new UpgradeValue(10));
		Upgrades.upgrades.push(Upgrades.rateOfFire = new UpgradeValue(5));
		Upgrades.upgrades.push(Upgrades.damageShots = new UpgradeValue(10));
		Upgrades.upgrades.push(Upgrades.shield = new UpgradeValue(10));

		Globals.gameScene = this;
		levelManager = new LevelManager();

		levelManager.newGame();

		//levelManager.buildWave(1);
		//levelManager.switchToGame();

		ParticleManager.initParticleEmitter("graphics/particles.png", 3, 2);
		
		var e = new ParticleManager();
		e.layer = 1;
		add(e);

		var testParticle = ParticleManager.addType("trail", [0]);
		testParticle.setMotion(0, 0, 4.5);
		testParticle.setAlpha();
		//testParticle.setScale(0.5, 1.0, 3.0, Ease.quadOut);
		//testParticle.setMotion(0, 2, 0.5, 360, 2, 1.0);
		//testParticle.setAlpha();
	}

	override function update() 
	{
		super.update();
		levelManager.update();

		//if(Input.pressed("console"))
		//	Console.enabled = !Console.enabled;
	}
}
