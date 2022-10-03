package entities;

import haxepunk.ParticleManager;
import haxepunk.graphics.TextEntity;
import haxepunk.graphics.Image;
import haxepunk.graphics.ui.UIBar;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.HXP;
import haxepunk.input.Input;
import haxepunk.graphics.Spritemap;
import haxepunk.math.MathUtil;
import haxepunk.input.Mouse;
import haxepunk.math.Vector2;
import haxepunk.Entity;

class Player extends GameEntity
{
    //public var currentDir:Vector2;
    //public var currentAngleDeg:Float;
    //public var targetAngleDeg:Float;

    public var tankBarrel:TankBarrel;

    public var acceleration:Float;
    public var speed:Float;
    public var switchToVel:Bool;
    public var knockbackVel:Vector2;
    public var hp:Float;

    public var playerSpawnTween:MultiVarTween;

    public var uiHPBar:UIBar;

    public var blastUI:Entity;
    public var blastUIText:TextEntity;

    public var spawnAmountTimer:Float;
    
    public function new(x:Float, y:Float)
    {
        super(x, y, "graphics/Player.png", 16, 16);
        centerOrigin();
        graphic.centerOrigin();

        name = "player";
        type = "player";

        knockbackVel = new Vector2();

        //currentDir = new Vector2();
        //spriteMap.alpha = 0.0;

        spriteMap.alpha = 0;
        playerSpawnTween = new MultiVarTween();
        
        spriteMap.scale = 5;
        playerSpawnTween.tween(spriteMap, {scale: 1, alpha:1}, 0.8, Ease.bounceOut);
        addTween(playerSpawnTween, true);
    }

    override function addEntitiesToScene() 
    {
        super.addEntitiesToScene();
        tankBarrel = new TankBarrel(this);
        tankBarrel.layer = layer - 1;
        Globals.gameScene.add(tankBarrel);

        uiHPBar = new UIBar("graphics/UIHPBar.png", 25, 4);
        uiHPBar.x = -100;
        Globals.gameScene.add(uiHPBar);

        blastUI = new Entity(-100, 0, new Image("graphics/UIBlast.png"));
        cast(blastUI.graphic, Image).scale = 0.5;
        Globals.gameScene.add(blastUI);

        blastUIText = new TextEntity(-100, 0, "", 8);
        Globals.gameScene.add(blastUIText);
    }

    override function initVars() 
    {
        super.initVars();
        //currentAngleDeg = 0;
        //targetAngleDeg = 0;
        speed = 2;
        acceleration = 0.08;
        
        switch(Upgrades.movementSpeed.upgradeLevel)
        {
            case 0:
            { 
                speed = 0.8;
                acceleration = 0.04;
            }
        
            case 1:
            { 
                speed = 1.5;
                acceleration = 0.08;
            }
        
            case 2:
            { 
                speed = 2;
                acceleration = 0.1;
            }
        
            case 3:
            { 
                speed = 2.5;
                acceleration = 0.15;
            }
        
            case 4:
            { 
                speed = 3;
                acceleration = 0.2;
            }
        }
        

        hp = 100;

        if(tankBarrel != null)
            tankBarrel.initVars();
    }

    override function update() 
    {
        super.update();
        if(playerSpawnTween.active)
            return;
        handleInput();

        handleAnimation();
        
        tankBarrel.x = x;
        tankBarrel.y = y;
        tankBarrel.update();

        velocity.x += knockbackVel.x;
        velocity.y += knockbackVel.y;
        knockbackVel.x = MathUtil.lerp(knockbackVel.x, 0, 0.08);
        knockbackVel.y = MathUtil.lerp(knockbackVel.y, 0, 0.08);

        if(x + velocity.x - halfWidth < 0)
            velocity.x = 0;

        if(x + velocity.x > Globals.mapWidth - halfWidth)
            velocity.x = 0;

        if(y + velocity.y - halfHeight < 0)
            velocity.y = 0;

        if(y + velocity.y > Globals.mapHeight - halfHeight)
            velocity.y = 0;


        applyVelocity();

        uiHPBar.x = x - uiHPBar.barWidth / 2;
        uiHPBar.y = y - 16;
        uiHPBar.fill = hp;


        blastUI.x = x - 6;
        blastUI.y = y + 8;

        blastUIText.x = x + 2;
        blastUIText.y = y + 8;
        blastUIText.currentText = Std.string(tankBarrel.blastAmount);



        handleCamera();

        if(velocity.length > 0.1)
        {
            spawnAmountTimer -= HXP.elapsed;
            if(spawnAmountTimer <= 0)
                spawnAmountTimer = 0;
            if(spawnAmountTimer <= 0)
            {
                ParticleManager.particleEmitter.emit("trail", x, y - 3, spriteMap.angle);
                ParticleManager.particleEmitter.emit("trail", x, y + 3, spriteMap.angle);
                spawnAmountTimer = 0.2;
            }
        }
    }

    public function handleCamera() 
    {
        HXP.camera.x = MathUtil.lerp(HXP.camera.x, x - HXP.halfWidth, 0.08);
        HXP.camera.y = MathUtil.lerp(HXP.camera.y, y - HXP.halfHeight, 0.08);

        HXP.camera.x = MathUtil.clamp(HXP.camera.x, 0, Globals.mapWidth - HXP.width);
        HXP.camera.y = MathUtil.clamp(HXP.camera.y, 0, Globals.mapHeight - HXP.height);
    }

    public function handleInput() 
    {
        var targetDir = new Vector2(Mouse.mouseX + HXP.camera.x - x, Mouse.mouseY + HXP.camera.y - y);
        targetDir.normalize();
        
        //targetAngleDeg = MathUtil.angle(0, 0, targetDir.x, targetDir.y);

        //acceleration = MathUtil.lerp(0.02, 0.08, (velocity.length / 2.0));
        //////////////////////
        // Tank Movement
        //////////////////////

        var anyInputPressed = false;
        var rightPressed = Input.check("right");
        var leftPressed = Input.check("left");
        var downPressed = Input.check("down");
        var upPressed = Input.check("up");
        anyInputPressed = rightPressed || leftPressed || downPressed || upPressed;

        var currentInputDir:Vector2 = new Vector2(0,0);
        //if(anyInputPressed)
        //    velocity.setToZero();

        if(rightPressed)
        {
            currentInputDir.x = 1.0;
        }

        if(leftPressed)
        {
            currentInputDir.x = -1.0;
        }

        if(upPressed)
        {
            currentInputDir.y = -1.0;
        }

        if(downPressed)
        {
            currentInputDir.y = 1.0;
        }

        if(anyInputPressed)
        {
            currentInputDir.normalize();
            //currentInputDir.scale(speed);
            //if(!switchToVel)
                velocity += currentInputDir.scale(acceleration);
            //else 
            //    velocity = currentInputDir.scale(speed);
        }
        else 
        {
            velocity.x = MathUtil.lerp(velocity.x, 0.0, 0.08);
            velocity.y = MathUtil.lerp(velocity.y, 0.0, 0.08);
        }

        if(velocity.length > speed)
            velocity.normalize().scale(speed);
        //if(velocity.length > 0.5)
        //    //switchToVel = true;
        //    acceleration = 4;
        //else if(!anyInputPressed)
        //    //switchToVel = false;
        //   acceleration = 0.08;
            velocity.x = MathUtil.lerp(velocity.x, 0.0, 0.08);
            velocity.y = MathUtil.lerp(velocity.y, 0.0, 0.08);
        /////////////////////////////
        // Tank Barrel
        /////////////////////////////

        
    }

    public function receiveDamage(dmg:Float)
    {
        hp -= (dmg * tankBarrel.dmgResistence);
        hp = MathUtil.clamp(hp, 0, 100);
    }

    public function handleAnimation() 
    {
        //currentAngleDeg = MathUtil.lerpAngleDeg(currentAngleDeg, targetAngleDeg, 0.08);
        //currentDir.setTo(1, 0).rotate(currentAngleDeg);
        //currentAngleDeg = targetAngleDeg;
        //tankBarrel.spriteMap.angle = currentAngleDeg;

        spriteMap.angle = MathUtil.lerpAngleDeg(spriteMap.angle, MathUtil.angle(0, 0, velocity.x, velocity.y), 0.2);
    }
}