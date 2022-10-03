package entities;

import haxepunk.input.Input;
import haxepunk.HXP;
import haxepunk.math.MinMaxValue;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;
import haxepunk.utils.Draw;
import haxepunk.Camera;
import haxepunk.input.Mouse;

class TankBarrel extends GameEntity
{
    public var currentPos:Vector2;
    public var targetPos:Vector2;

    // BLAST
    public var radiusOfDamage:Float;
    public var damageBlast:Float;
    public var blastCooldown:MinMaxValue;
    public var blastAmount:Int;

    // SHOTS
    public var damageShots:Float;
    public var shotsCooldown:MinMaxValue;


    public var rotationSpeed:Float;
    public var canShootShots:Bool;
    public var canShootBlast:Bool;

    public var player:Player;

    public var dmgResistence:Float;

    public function new(player:Player) 
    {
        super(0, 0, "graphics/TankBarrel.png", 16, 16);
        this.player = player;
        centerOrigin();
        graphic.centerOrigin();

        //Mouse.hideCursor();
        active = false;
        targetPos = new Vector2();
        currentPos = new Vector2();
        
    }

    override function initVars() 
    {
        super.initVars();
        radiusOfDamage = 90.0;

        canShootShots = false;
        
        // BLAST
        damageBlast = 2;
        blastAmount = Upgrades.blastsAmount.upgradeLevel * 2;
        blastCooldown = new MinMaxValue(0, 0.1, 1.0, 0);

        switch(Upgrades.blastPower.upgradeLevel)
        {
            case 0:
            { 
                damageBlast = 5;
            }
        
            case 1:
            { 
                damageBlast = 15;
            }
        
            case 2:
            { 
                damageBlast = 25;
            }
        
            case 3:
            { 
                damageBlast = 50;
            }
        
            case 4:
            { 
                damageBlast = 80;
            }
            
        }
        
        // SHOTS
        shotsCooldown = new MinMaxValue(0, 0.1, 1.0, 0);
        switch(Upgrades.rateOfFire.upgradeLevel)
        {
            case 0:
            { 
                shotsCooldown.maxValue = 0.17;
            }
        
            case 1:
            { 
                shotsCooldown.maxValue = 0.12;
            }
        
            case 2:
            { 
                shotsCooldown.maxValue = 0.09;
            }
        
            case 3:
            { 
                shotsCooldown.maxValue = 0.07;
            }
        
            case 4:
            { 
                shotsCooldown.maxValue = 0.05;
            }
            
        }
        shotsCooldown.initToMax();

        damageShots = 0.8;
        switch(Upgrades.damageShots.upgradeLevel)
        {
            case 0:
            { 
                damageShots = 0.5;
            }
        
            case 1:
            { 
                damageShots = 1.5;
            }
        
            case 2:
            { 
                damageShots = 3;
            }
        
            case 3:
            { 
                damageShots = 5;
            }
        
            case 4:
            { 
                damageShots = 8;
            }
            
        }
        

        // DMG Res
        switch(Upgrades.shield.upgradeLevel)
        {
            case 0:
            { 
                dmgResistence = 0.9;
            }
        
            case 1:
            { 
                dmgResistence = 0.8;
            }
        
            case 2:
            { 
                dmgResistence = 0.7;
            }
        
            case 3:
            { 
                dmgResistence = 0.6;
            }
        
            case 4:
            { 
                dmgResistence = 0.5;
            }
            
        }
        

        // Rotation Speed
        rotationSpeed = 0.05;

        switch(Upgrades.rotationSpeed.upgradeLevel)
        {
            case 0:
            { 
                rotationSpeed = 0.03;
            }
        
            case 1:
            { 
                rotationSpeed = 0.07;
            }
        
            case 2:
            { 
                rotationSpeed = 0.11;
            }
        
            case 3:
            { 
                rotationSpeed = 0.15;
            }
        
            case 4:
            { 
                rotationSpeed = 0.2;
            }
            
        }
    }

    override function update() 
    {
        super.update();
        shotsCooldown.currentValue -= HXP.elapsed;
        shotsCooldown.clamp();
        if(shotsCooldown.currentValue <= shotsCooldown.minValue)
            canShootShots = true;

        blastCooldown.currentValue -= HXP.elapsed;
        blastCooldown.clamp();
        if(blastCooldown.currentValue <= blastCooldown.minValue && blastAmount > 0)
            canShootBlast = true;
        
        handleInput();

    }

    public function handleInput() 
    {
        var aimDir:Vector2 = new Vector2((Mouse.mouseX + HXP.camera.x) - x, (Mouse.mouseY + HXP.camera.y) - y);
        aimDir.normalize();
        targetPos.setTo(Mouse.mouseX + HXP.camera.x, Mouse.mouseY + HXP.camera.y);
        trace(Mouse.mouseX);
        currentPos.x = MathUtil.lerp(currentPos.x, targetPos.x, rotationSpeed);
        currentPos.y = MathUtil.lerp(currentPos.y, targetPos.y, rotationSpeed);

        var currentPosDir:Vector2 = new Vector2(currentPos.x - x, currentPos.y - y);
        currentPosDir.normalize();

        if(aimDir.x >= 0)
        {
            spriteMap.angle = MathUtil.angle(x, y, currentPos.x, currentPos.y);
            spriteMap.flipX = false;
        }
        else
        {
            spriteMap.angle = MathUtil.angle(x, y, currentPos.x, currentPos.y) - 180;
            spriteMap.flipX = true;
        }

        if(Mouse.mouseDown && canShootShots)
        {
            //Globals.gameScene.add(new TankBlast(currentPos.x, currentPos.y, radiusOfDamage, damageBlast));
            Globals.gameScene.add(new TankBullet(x, y, currentPosDir.x, currentPosDir.y, damageShots));
            shotsCooldown.initToMax();
            canShootShots = false;
            HXP.camera.shake(0.1, 1);
            player.knockbackVel.add(new Vector2(x - currentPos.x, y - currentPos.y).normalize().scale(0.02));
        }

        if((Mouse.middleMousePressed || Input.pressed("Space")) && canShootBlast)
        {
            Globals.gameScene.add(new TankBlast(currentPos.x, currentPos.y, radiusOfDamage, damageBlast));
            //Globals.gameScene.add(new TankBullet(centerX, centerY, aimDir.x, aimDir.y, damageShots));
            shotsCooldown.initToMax();
            canShootBlast = false;
            HXP.camera.shake(0.1, 1);
            player.knockbackVel.add(new Vector2(x - currentPos.x, y - currentPos.y).normalize().scale(0.4));
            blastAmount--;
        }
    }

    override function render(camera:Camera) 
    {
        super.render(camera);
        Draw.setColor(0xE0A74C, MathUtil.lerp(1.0, 0.1, shotsCooldown.currentValue / shotsCooldown.maxValue));
        Draw.circle(currentPos.x - HXP.camera.x, currentPos.y - HXP.camera.y, radiusOfDamage);


    }
}