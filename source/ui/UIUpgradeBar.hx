package ui;

import haxepunk.HXP;
import haxepunk.math.MathUtil;
import levels.LevelManager;
import haxepunk.input.Mouse;
import haxepunk.graphics.ui.UIBar;

class UIUpgradeBar extends UIBar
{
    public var upgradeIndex:Int;

    public var mouseOn:Bool;
    public var mouseClick:Bool;

    public function new(x:Float, y:Float, upgradeIndex:Int)
    {
        super("graphics/UIUpgradeBar.png", 29, 6);
        this.upgradeIndex = upgradeIndex;

        this.x = x;
        this.y = y;
        setHitbox(36, 6);

        //if(upgradeIndex == 0)
        //{
        //    fill = 20 * Upgrades.movementSpeed.upgradeLevel;
        //}
    }
    
    override function update() 
    {
        super.update();
        
        if(collidePoint(x, y, Mouse.mouseX + HXP.camera.x, Mouse.mouseY + HXP.camera.y))
        {
            mouseOn = true;
        }
        else 
            mouseOn = false;

        if(mouseOn)
        {
            Globals.tankBuildScene.costText.currentText = "Cost: " + Upgrades.upgrades[upgradeIndex].upgradeCost;
            if(Mouse.mousePressed)
            {
                clickBuy();
            }
        
            if(Mouse.middleMousePressed)
            {
                clickSell();
            }
        }
         
            
        fill = MathUtil.lerp(fill, 25 * Upgrades.upgrades[upgradeIndex].upgradeLevel, 0.09);
    }

    public function clickBuy() 
    {
        if(LevelManager.totalMoney - Upgrades.upgrades[upgradeIndex].upgradeCost >= 0 && 
            Upgrades.upgrades[upgradeIndex].upgradeLevel < 4)
        {
            Upgrades.upgrades[upgradeIndex].upgradeLevel++;
            LevelManager.totalMoney -= Upgrades.upgrades[upgradeIndex].upgradeCost;
        }
    }

    public function clickSell() 
    {
        if(Upgrades.upgrades[upgradeIndex].upgradeLevel > 0)
        {
            Upgrades.upgrades[upgradeIndex].upgradeLevel--;
            LevelManager.totalMoney += Upgrades.upgrades[upgradeIndex].upgradeCost;
        }
    }
}