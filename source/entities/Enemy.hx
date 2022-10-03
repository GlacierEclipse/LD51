package entities;

import haxepunk.graphics.Spritemap;
import haxepunk.math.Random;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;
import haxepunk.HXP;
import haxepunk.Entity;

class Enemy extends GameEntity
{
    public var speed:Float;
    public var hp:Float;
    public var damage:Float;
    public var knockbackVel:Vector2;

    public var alive:Bool;

    public var deathTween:MultiVarTween;

    public var separating:Bool;

    public var enemType:Int;

    public function new(x:Float, y:Float, type:Int = 0)
    {
        super(x, y, "graphics/Enemy1.png", 16, 16);

        hp = 1;
        speed = 0.5;
        damage = 2;
        // Base Swarm enemy
        if(type == 0)
        {
            damage = 2;
            hp = 3;
            speed = 0.8;
            spriteMap = new Spritemap("graphics/Enemy1.png", width, height);
            setHitbox(6, 13);
        }
        else if(type == 1)
        {
            // MED
            hp = 25;
            speed = 0.6;
            spriteMap = new Spritemap("graphics/Enemy2.png", width, height);
            setHitbox(6, 15);
        }
        else if(type == 2)
        {
            // HIGH
            hp = 75;
            speed = 0.5;
            spriteMap = new Spritemap("graphics/Enemy3.png", width, height);
            setHitbox(8, 15);
        }
        else if(type == 3)
        {
            // TANK
            hp = 300;
            speed = 0.3;
            spriteMap = new Spritemap("graphics/Enemy4.png", width, height);
            
            setHitbox(10 * 2, 16 * 2);
            spriteMap.scale = 2;
        }

        enemType = type;
        graphic = spriteMap;



        knockbackVel = new Vector2();
        this.type = "enemy";
        alive = true;

        deathTween = new MultiVarTween();
        addTween(deathTween);

        graphic.centerOrigin();
        centerOrigin();
    }

    override function initVars() 
    {
        super.initVars();
        
    }

    override function update() 
    {
        super.update();
        
        if(alive)
        {
            var player:Entity = Globals.gameScene.getInstance("player");
            velocity.x = player.x - x;
            velocity.y = player.y - y;
            velocity.normalize();
            velocity.scale(speed);
        }
        else 
        {
            velocity.x = MathUtil.lerp(velocity.x, 0, 0.08);
            velocity.y = MathUtil.lerp(velocity.y, 0, 0.08);
        }
        
        velocity.x += knockbackVel.x;
        velocity.y += knockbackVel.y;

        if(velocity.length > 2)
            velocity.normalize(2);

        //if(separating)
        //{
        //    velocity = knockbackVel;
        //}

        knockbackVel.x = MathUtil.lerp(knockbackVel.x, 0, 0.08);
        knockbackVel.y = MathUtil.lerp(knockbackVel.y, 0, 0.08);

        handleCollision();
        
        applyVelocity();
    }

    public function receiveDamage(dmg:Float, dirX:Float, dirY:Float, blastOffset:Float = 0.2) 
    {
        var dir:Vector2 = new Vector2(dirX, dirY);
        dir.normalize();
        if(knockbackVel.length < 0.01)
        {
            knockbackVel.setTo(dir.x, dir.y);
            knockbackVel.scale(blastOffset);
        }

        hp -= dmg;

        if(hp <= 0 && alive)
        {
            deathTween.tween(spriteMap, {angle: 90, alpha:0.4 + Random.randFloat(0.3)}, 0.5, Ease.bounceOut);
            deathTween.onComplete.bind(function() {
                //Globals.gameScene.remove(this);
            }

            );
            deathTween.start();
            
            alive = false;

            if(enemType == 0)
            {
                // 5% chance for loot
                var dropLoot:Bool = Random.randInt(101) < 5 ? true : false;
                if(dropLoot)
                {
                    Globals.gameScene.add(new Loot(x, y));
                }
            }

            if(enemType > 0)
            {
                // 15% chance for loot
                var dropLoot:Bool = Random.randInt(101) < 15 ? true : false;
                if(dropLoot)
                {
                    Globals.gameScene.add(new Loot(x, y));
                }
            }
        }
    }
    
    public function handleCollision() 
    {
        var collided:Entity = collide("player", x + velocity.x, y + velocity.y);
        if(collided != null && alive)
        {
            cast(collided, Player).receiveDamage(damage);

            receiveDamage(damage, 0 ,0);
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
        }


        var collided:Enemy = cast collide("enemy", x + velocity.x, y + velocity.y);
        if(collided != null && !collided.separating && knockbackVel.length < 0.01 && alive && collided.alive)
        {
            knockbackVel.x = ((x + velocity.x) - collided.x);
            knockbackVel.y = ((y + velocity.y) - collided.y);
            knockbackVel.normalize();
            knockbackVel.scale(0.7);
            //knockbackVel.x = -velocity.x ;
            //knockbackVel.y = -velocity.y ;
            //velocity.x = velocity.x / 2;
            //velocity.y = velocity.y / 2;
            //velocity.normalize();
            //velocity.scale(2);
            separating = true;
            //knockbackVel.setTo(1,0).rotate(Random.randFloat(360) * MathUtil.DEG);
            //knockbackVel.normalize();
            //knockbackVel.scale(1);
            //velocity.setToZero();
            
        }
        else 
            separating = false;


    }
}