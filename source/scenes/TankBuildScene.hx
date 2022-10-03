package scenes;

import haxepunk.input.Input;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.VarTween;
import ui.UIUpgradeBar;
import levels.LevelManager;
import haxepunk.graphics.Image;
import haxepunk.Entity;
import entities.Enemy;
import haxepunk.graphics.TextEntity;
import haxepunk.HXP;
import haxepunk.Scene;

class TankBuildScene extends Scene
{
    public var texts:Array<TextEntity>;
    
    public var costText:TextEntity;
    
    public var totalMoneyText:TextEntity;

    public var upgradeBars:Array<UIUpgradeBar>;

    public var activateSceneTween:VarTween;
    public var switchSceneTween:VarTween;

    public function new() 
    {
        super();

        bgAlpha = 0;
        bgColor = 0x353846;
        Globals.tankBuildScene = this;

        texts = new Array<TextEntity>();
        upgradeBars = new Array<UIUpgradeBar>();

        add(new Entity(160, 20, new Image("graphics/UISeparator.png")));
        costText = new TextEntity(160 + 20, 160, "Cost: ", 12);
        add(costText);

        totalMoneyText = new TextEntity(160, 5, "Total Money: ", 12);
        totalMoneyText.x = totalMoneyText.x - totalMoneyText.textBitmap.textWidth / 2;
        add(totalMoneyText);

        activateSceneTween = new VarTween();
        
        addTween(activateSceneTween);
        switchSceneTween = new VarTween();
        addTween(switchSceneTween);
    }

    override function begin()
    {
        super.begin();
        // Build the next wave
        if(!LevelManager.waveInProgress)
            Globals.gameScene.levelManager.buildNextWave();
        
        var columnLeftOffset:Int = 20;
        var columnBottomOffset:Int = 20;
        if(!LevelManager.waveInProgress)
            texts.push(new TextEntity(columnLeftOffset, columnBottomOffset, "Next Wave:"));
        else 
            texts.push(new TextEntity(columnLeftOffset, columnBottomOffset, "Current Wave:"));

        columnBottomOffset += 20;
        // Build the left column the next wave.
        for (miniWave in Globals.gameScene.levelManager.miniWaves)
        {
            for (waveType in miniWave.waveTypes)
            {
                // Amount
                texts.push(new TextEntity(columnLeftOffset, columnBottomOffset, "x" + waveType.amount + "- ", 12));
                
                // Icon of our guy TODO
                
                var icon:Enemy = new Enemy(columnLeftOffset + 33, columnBottomOffset + 4, waveType.waveType);
                icon.active = false;
                add(icon);
                
                var hpString:String = "";
                var speedString:String = "";

                if(waveType.waveType == 0)
                {
                    hpString = "Low";
                    speedString = "High";
                }

                if(waveType.waveType == 1)
                {
                    hpString = "Med";
                    speedString = "Med";
                }

                if(waveType.waveType == 2)
                {
                    hpString = "High";
                    speedString = "Low";
                }

                if(waveType.waveType == 3)
                {
                    hpString = "Tank";
                    speedString = "Low";
                }

                texts.push(new TextEntity(columnLeftOffset + 40, columnBottomOffset, "HP: " + hpString, 8));
                texts.push(new TextEntity(columnLeftOffset + 40, columnBottomOffset + 8, "Speed: " + speedString, 8));
                

                columnBottomOffset += 25;
            }
            
        }



        //bgAlpha = 1;

        //add(new TextEntity(160, 0, "Total Money: " + LevelManager.totalMoney));



        //////////////////
        // RIGHT COLUMN
        //////////////////

        var columnRightOffset:Int = 20;
        var columnBottomOffset:Int = 40;
        var spacingUpgrade:Int = 17;
        
        texts.push(new TextEntity(160 + columnRightOffset + 23, columnBottomOffset - 20, "Tank Build:"));
        


        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Movement Speed ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 0));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Rotation Speed ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 1));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Blasts Amount ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 2));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Blast Power ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 3));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Rate Of Fire ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 4));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Shots Damage ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 5));

        columnBottomOffset += spacingUpgrade;

        // Movement speed
        texts.push(new TextEntity(160 + columnRightOffset, columnBottomOffset, "Shield ", 8));
        upgradeBars.push(new UIUpgradeBar(160 + columnRightOffset + 80, columnBottomOffset, 6));

        texts.push(new TextEntity(160 + 30, 220, "Space To Start"));
        texts[texts.length - 1].textBitmap.color = 0xFFA144;
        texts.push(new TextEntity(160 + 15, 200, "Middle Click to Sell"));
        
        for (text in texts)
        {
            add(text);
        }
        
        for (upgradeBar in upgradeBars)
        {
            add(upgradeBar);
        }

        activateSceneTween.tween(this, "bgAlpha", 0.8, 0.9, Ease.cubeInOut);
    }
    
    override function update() 
    {
        Globals.tankBuildScene.costText.currentText = "Cost: ";
        super.update();
        totalMoneyText.currentText = "Total money: " + LevelManager.totalMoney;
        totalMoneyText.x = 160 - totalMoneyText.textBitmap.textWidth / 2.0;

        if(Input.pressed("Space") && !switchSceneTween.active)
        {
            switchSceneTween.tween(this, "bgAlpha", 0, 0.5, Ease.cubeOut);
                switchSceneTween.onComplete.bind(function() {
                    Globals.gameScene.levelManager.switchToGame();
                    HXP.engine.popScene();
                });
        }
        
        for (e in _update)
        {
            e.graphic.alpha = bgAlpha;
        }
    }
}