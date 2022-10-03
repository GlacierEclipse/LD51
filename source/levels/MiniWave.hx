package levels;

import haxepunk.math.MathUtil;
import haxepunk.math.Random;
import entities.Enemy;

class MiniWave 
{
    public var waveTypes:Array<WaveType>;
    public var enemies:Array<Enemy>;

    public function new() 
    {
        waveTypes = new Array<WaveType>();
        enemies = new Array<Enemy>();
    }

    public function buildMiniWave(waveNum:Int)
    {
        // Types are up to 2
        var amountOfTypes:Int = 1 + Random.randInt(2);

        for (i in 0...amountOfTypes)
        {
            var waveType:Int = Random.randInt(Std.int(MathUtil.scale(waveNum, 0, 10, 0, 4)));

            var amountOfType:Int = 10 + Random.randInt(10);
            if(waveType == 0)
            {
                // Swarms
                amountOfType = 30 + Random.randInt(waveNum * 7);
            }
            else if(waveType == 1)
            {
                // Med
                amountOfType = 10 + Random.randInt(waveNum * 5);
            }
            else if(waveType == 2)
            {
                // High - Fast and damaging
                amountOfType = 5 + Random.randInt(waveNum * 4);
            }
            else if(waveType == 3)
            {
                // Tanks
                amountOfType = 2 + Random.randInt(waveNum * 3);
            }
            
            var waveType:WaveType = new WaveType(waveType, amountOfType);
            waveTypes.push(waveType);
        }
    }

    public function spawnWave() 
    {
        for (waveType in waveTypes)
        {
            // Pick random pos on the outside
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

            // Spawn the enemies

            for (i in 0...waveType.amount)
            {
                var e:Enemy = new Enemy(randX + (- 16 + Random.randFloat(32)), randY + (- 16 + Random.randFloat(32)), waveType.waveType);
                Globals.gameScene.add(e);
                enemies.push(e);
            }
        }


    }
}