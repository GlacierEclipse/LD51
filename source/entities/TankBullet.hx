package entities;

import haxepunk.math.MathUtil;

class TankBullet extends GameEntity
{
    public var speed:Float;
    public var dmg:Float;

    public function new(x:Float, y:Float, dirX:Float, dirY:Float, dmg:Float) 
    {
        super(x, y, "graphics/TankBullet.png", 16, 16);

        speed = 7;
        this.dmg = dmg;
        velocity.x = dirX * speed;
        velocity.y = dirY * speed;

        spriteMap.angle = MathUtil.angle(0, 0, dirX, dirY);
        setHitbox(16, 16);

        spriteMap.centerOrigin();
        centerOrigin();
    }

    override function update() 
    {
        super.update();
        handleCollision();
        applyVelocity();
    }

    public function handleCollision() 
    {
        var collided:Enemy = cast collide("enemy", x + velocity.x, y + velocity.y);
        if(collided != null && collided.alive)
        {
            collided.receiveDamage(dmg, velocity.x, velocity.y);
            Globals.gameScene.remove(this);
        }
    }
}