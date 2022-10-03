package entities;

import haxepunk.graphics.Spritemap;
import haxepunk.Entity;

class GameEntity extends Entity
{
    public var spriteMap:Spritemap;
    public function new(x:Float, y:Float, assetString:String, width:Int, height:Int) 
    {
        super(x, y);
        if(assetString != "")
            spriteMap = new Spritemap(assetString, width, height);
        initVars();
        
        setHitbox(width, height);

        graphic = spriteMap;

        addEntitiesToScene();
    }

    public function initVars() 
    {
        
    }

    public function addEntitiesToScene() 
    {
        
    }

    public function applyVelocity()
    {
        x += velocity.x;
        y += velocity.y;
    }
}