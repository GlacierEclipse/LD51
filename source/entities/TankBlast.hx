package entities;

import haxepunk.HXP;
import haxepunk.utils.Ease;
import haxepunk.utils.Color;
import haxepunk.tweens.misc.ColorTween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Draw;
import haxepunk.Camera;
import haxepunk.masks.Circle;

class TankBlast extends GameEntity
{
    public var radius:Float;
    public var damage:Float;
    public var blastTween:ColorTween;

    public function new(x:Float, y:Float, radius:Float, dmg:Float)
    {
        super(x, y, "", 16, 16);
        this.radius = radius;
        this.damage = dmg;

        mask = new Circle(Std.int(radius / 2), Std.int(-(radius / 2)), Std.int(-(radius / 2)));
        centerOrigin();
        
        blastTween = new ColorTween();
        blastTween.tween(0.8, Color.getColorRGB(224, 167, 76), Color.getColorRGB(221, 196, 157), 0.15, 0, Ease.quintInOut);
        blastTween.onComplete.bind(function() {
            Globals.gameScene.remove(this);
        });
        addTween(blastTween, true);
    }

    override function update() 
    {
        super.update();
        handleCollision();
    }

    public function handleCollision() 
    {
        var collided:Array<Enemy> = new Array();
        collideInto("enemy", x, y, collided);

        for (collide in collided)
        {
            collide.receiveDamage(damage, velocity.x, velocity.y);
        }

        collidable = false;
    }

    override function render(camera:Camera) 
    {
        super.render(camera);
        Draw.setColor(blastTween.color, blastTween.alpha);
        Draw.circleFilled(x - HXP.camera.x, y - HXP.camera.y, radius);
    }
}