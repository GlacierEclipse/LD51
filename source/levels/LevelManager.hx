package levels;

import entities.TilesEntity;
import haxepunk.math.MathUtil;
import scenes.GameCompleteScene;
import haxepunk.input.Input;
import scenes.TankBuildScene;
import scenes.WaveCompleteScene;
import haxepunk.math.Random;
import haxepunk.HXP;
import haxepunk.math.MinMaxValue;
import entities.Enemy;
import entities.Player;

enum MenuState
{
    TANKBUILD;
    PLAYPLAYERSPAWN;
    PLAY;
    WAVECOMPLETED;
}

class LevelManager 
{
    public static var totalMoney:Int;


    public var menuState:MenuState;

    public var player:Player;
    public var miniWaves:Array<MiniWave>;
    public var nextWaveTimer:MinMaxValue;

    public var currentMiniWaveNum:Int;

    public static var currentWaveNum:Int;

    public static var damageTaken:Int;
    public static var lootCollected:Int;
    public static var waveCompleted:Bool;
    public static var waveInProgress:Bool;
    
    public var mapTiles:TilesEntity;
    

    public function new() 
    {
        menuState = MenuState.PLAYPLAYERSPAWN;
        totalMoney = 2;
        mapTiles = new TilesEntity();
    }

    public function buildNextWave()
    {
        buildWave(currentWaveNum + 1);
        switchToGame();
    }

    public function resumeWave()
    {
        LevelManager.waveInProgress = false;
        //buildWave(currentWaveNum + 1);
        //currentMiniWaveNum = 0;
        //currentWaveNum = wave;
    }

    public function buildWave(wave:Int)
    {
        lootCollected = 0;
        player = new Player(160, 120);
        Globals.gameScene.add(player);



        // RESET THE UPGRADES
        for (upgrade in Upgrades.upgrades)
        {
            upgrade.upgradeLevel = 0;
        }

        miniWaves = new Array<MiniWave>();
        nextWaveTimer = new MinMaxValue(0, 4, 4, 0);



        Globals.mapWidth = Std.int((320 + Random.randInt(320)) / 16) * 16;
        Globals.mapHeight = Std.int((240 + Random.randInt(240)) / 16) * 16;

        mapTiles.initTiles(Globals.mapWidth, Globals.mapHeight);
        mapTiles.tileMap.setRect(0, 0, Std.int(Globals.mapWidth / 16), Std.int(Globals.mapHeight / 16), 0);

        // UP DOWN
        mapTiles.tileMap.setRect(0, 0, Std.int(Globals.mapWidth / 16), 1, 2);
        mapTiles.tileMap.setRect(0, Std.int(Globals.mapHeight / 16) - 1, Std.int(Globals.mapWidth / 16), 1, 4);
        // LR
        mapTiles.tileMap.setRect(0, 0, 1, Std.int(Globals.mapWidth / 16), 1);
        mapTiles.tileMap.setRect(Std.int(Globals.mapWidth / 16) - 1, 0, 1, Std.int(Globals.mapWidth / 16), 3);

        mapTiles.tileMap.setTile(0, 0, 6);
        mapTiles.tileMap.setTile(Std.int(Globals.mapWidth / 16) - 1, 0, 7);
        mapTiles.tileMap.setTile(0, Std.int(Globals.mapHeight / 16) - 1, 5);
        mapTiles.tileMap.setTile(Std.int(Globals.mapWidth / 16) - 1, Std.int(Globals.mapHeight / 16) - 1, 8);

        mapTiles.layer = 5;
        Globals.gameScene.add(mapTiles);

        // WAVES

        currentMiniWaveNum = 0;
        currentWaveNum = wave;
        
        // Build the waves.
        // 4 Waves Max
        var miniWavesNum:Int = Std.int(MathUtil.scale(wave, 0, 10, 1, 5));

        for (i in 0...miniWavesNum)
        {
            var miniWave:MiniWave = new MiniWave();
            miniWave.buildMiniWave(wave);
            miniWaves.push(miniWave);
        }
    }

    public function clearEverything() 
    {
        Globals.gameScene.removeAll();
        Globals.gameScene.camera.x = 0;
        Globals.gameScene.camera.y = 0;
    }

    public function clearForResume() 
    {
        Globals.gameScene.remove(player);
        Globals.gameScene.remove(player.tankBarrel);
        Globals.gameScene.remove(player.uiHPBar);
        Globals.gameScene.remove(player.blastUI);
        Globals.gameScene.remove(player.blastUIText);
        player = new Player(160, 120);
        Globals.gameScene.add(player);
        
        Globals.gameScene.camera.x = 0;
        Globals.gameScene.camera.y = 0;
        for (miniWave in miniWaves)
        {
            for (enemy in miniWave.enemies)
            {
                if(!enemy.alive)
                    continue;
                var randWall:Int = Random.randInt(4);

                var randX:Float = Random.randFloat(Globals.mapWidth);
                var randY:Float = Random.randFloat(Globals.mapHeight);
    
                // Walls are = Right - Down - Left - Up
                if(randWall == 0)
                    randX = Globals.mapWidth;
                else if(randWall == 1)
                    randY = Globals.mapHeight;
                else if(randWall == 2)
                    randX = 0;
                else if(randWall == 3)
                    randY = 0;

                enemy.x = randX;
                enemy.y = randY;
            }
        }
    }

    public function switchToGame() 
    {
        resumeWave();
        menuState = MenuState.PLAYPLAYERSPAWN;
        player.initVars();
        
    }

    public function spawnNextWave() 
    {
        // Grab the next wave.
        var currentWave:MiniWave = miniWaves[currentMiniWaveNum];

        currentWave.spawnWave();

        currentMiniWaveNum++;
    }

    public function newGame() 
    {
        menuState = MenuState.TANKBUILD;
        HXP.engine.pushScene(new TankBuildScene());
        currentWaveNum = 0;

        // INIT EVERYTHING HERE 
        // Base Money
        totalMoney = 60;
    }

    public function switchToWaveComplete() 
    {
        if(currentWaveNum > 10 && player.hp > 0)
        {
            // GAME COMPLETED
            HXP.scene = new GameCompleteScene();
            return;
        }
        menuState = MenuState.WAVECOMPLETED;

        damageTaken = 100 - Std.int(player.hp);
        //lootCollected = 0;
        waveCompleted = true; 
        if(player.hp <= 0)
        {
            waveCompleted = false;
        }

        HXP.engine.pushScene(new TankBuildScene());
        HXP.engine.pushScene(new WaveCompleteScene());
    }

    public function update() 
    {
        //if(Input.pressed("Space"))
        //    switchToWaveComplete();
        if(menuState == MenuState.TANKBUILD)
        {

        }
        if(menuState == MenuState.PLAYPLAYERSPAWN)
        {
            if(!player.playerSpawnTween.active)
                menuState = MenuState.PLAY;
        }
        if(menuState == MenuState.PLAY)
        {
            nextWaveTimer.currentValue -= HXP.elapsed;
            nextWaveTimer.clamp();
            if(nextWaveTimer.currentValue <= 0 && currentMiniWaveNum < miniWaves.length)
            {
                // Spawn the next wave
                spawnNextWave();
                nextWaveTimer.initToMax();
            }

            if(currentMiniWaveNum == miniWaves.length)
            {
                // Count if all the enemies are still in the scene.
                var countAlive:Int = 0;
                for (miniWave in miniWaves)
                {
                    for (enemy in miniWave.enemies)
                    {
                        if(enemy.alive)
                            countAlive++; 
                    }
                }

                if(countAlive == 0)
                {
                    switchToWaveComplete();
                }
            }

            if(player.hp <= 0)
            {
                switchToWaveComplete();
            }
        }
    }

}