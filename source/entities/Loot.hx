package entities;

import haxepunk.math.MathUtil;
import levels.LevelManager;

class Loot extends GameEntity
{
    public function new(x:Float, y:Float)
    {
        super(x, y, "graphics/Loot.png", 16, 16);
        graphic.centerOrigin();
        centerOrigin();
    }

    override function update() 
    {
        super.update();
        var player:Player = cast Globals.gameScene.getInstance("player");
        if(distanceFrom(player) < 20)
        {
            velocity.x = player.x - x;
            velocity.y = player.y - y;
            velocity.normalize();
            velocity.scale(0.4);
        }
        else 
        {
            velocity.x = MathUtil.lerp(velocity.x, 0, 0.08);
            velocity.y = MathUtil.lerp(velocity.y, 0, 0.08);
        }


        if(collide("player", x, y) != null)
        {
            LevelManager.lootCollected++;
            Globals.gameScene.remove(this);
        }
    }
}