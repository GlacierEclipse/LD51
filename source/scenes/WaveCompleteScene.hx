package scenes;

import haxepunk.math.MathUtil;
import haxepunk.graphics.Image;
import haxepunk.Entity;
import haxepunk.input.Input;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.VarTween;
import levels.LevelManager;
import haxepunk.graphics.TextEntity;
import haxepunk.HXP;
import haxepunk.Scene;

class WaveCompleteScene extends Scene
{
    public var texts:Array<TextEntity>;
    public var ents:Array<Entity>;

    public var activateSceneTween:VarTween;
    public var switchSceneTween:VarTween;

    public var damageTakenText:TextEntity;
    public var damageTakenSumText:TextEntity;

    public var lootCollectedText:TextEntity;
    public var lootCollectedSumText:TextEntity;

    public var outcomeText:TextEntity;
    public var outcomeSumText:TextEntity;

    public var totalSumText:TextEntity;
    public var totalMoneyEndText:TextEntity;

    public var reportOutcomeText:TextEntity;

    public var continueText:TextEntity;

    public var startingMoney:Float;

    public var showCaseTween:VarTween;

    public var gameOver:Bool;
    public var gameCompleted:Bool;


    public function new() 
    {
        super();
        gameCompleted = false;
        bgColor = 0x3B3B3B;
        bgAlpha = 0;
        texts = new Array<TextEntity>();
        ents = new Array<Entity>();
        // Wave completed text:
        texts.push(new TextEntity(110, 40, "Wave " + LevelManager.currentWaveNum + " Report"));
        //texts.push(new TextEntity(0,0, "HP Left " + LevelManager.currentWaveNum + " Completed!"));
        //texts.push(new TextEntity(0,0, "Money Collected " + LevelManager.lootCollected + " Completed!"));

        var offsetXSums = 160 + 50;
        var offsetXTexts = 160 - 80;
        var offsetYTexts = 80;

        var finalAddSum:Int = 0;

        // DAMAGE
        damageTakenText = new TextEntity(offsetXTexts, offsetYTexts, "Damage Taken: " + LevelManager.damageTaken, 12);
        if(LevelManager.damageTaken == 100)
            damageTakenText.currentText = "Damage Taken: --";
        var damageSum:Int = Std.int((100 - LevelManager.damageTaken) / 20) * 5;
        damageTakenSumText = new TextEntity(offsetXSums, offsetYTexts, "+" + damageSum, 12);
        add(damageTakenText);
        add(damageTakenSumText);


        damageTakenText.textBitmap.alpha = 0;
        damageTakenSumText.textBitmap.alpha = 0;

        finalAddSum += damageSum;

        offsetYTexts += 20;
        // LOOT 
        lootCollectedText = new TextEntity(offsetXTexts, offsetYTexts, "Loot Collected: " + LevelManager.lootCollected, 12);
        var lootSum:Int = Std.int(LevelManager.lootCollected * 5);
        lootCollectedSumText = new TextEntity(offsetXSums, offsetYTexts, "+" + lootSum, 12);
        add(lootCollectedText);
        add(lootCollectedSumText);
        lootCollectedText.textBitmap.alpha = 0;

        finalAddSum += lootSum;

        offsetYTexts += 20;

        outcomeText = new TextEntity(offsetXTexts, offsetYTexts, "", 12);
        outcomeSumText = new TextEntity(offsetXSums, offsetYTexts, "", 12);
        
        if(LevelManager.waveCompleted)
        {
            outcomeText.currentText = "Wave Completed!";
            outcomeSumText.currentText = "+15";
            finalAddSum += 15;
        }
        else 
        {
            outcomeText.currentText = "Tank Destroyed!";
            outcomeSumText.currentText = "-20";
            finalAddSum -= 20;
            outcomeText.textBitmap.color = 0xFF0000;
            outcomeSumText.textBitmap.color = 0xFF0000;
        }
        outcomeText.textBitmap.alpha = 0;
        add(outcomeText);
        add(outcomeSumText);

        offsetYTexts += 28;

        totalSumText = new TextEntity(offsetXSums, offsetYTexts, (finalAddSum > 0 ? "+" : "")  + finalAddSum, 12);
        add(totalSumText);
        totalSumText.textBitmap.alpha = 0;
        



        startingMoney = LevelManager.totalMoney;
        totalMoneyEndText = new TextEntity(offsetXTexts, offsetYTexts, "Total Money: " + startingMoney, 12);
        add(totalMoneyEndText);
        totalMoneyEndText.textBitmap.alpha = 0;

        LevelManager.totalMoney += finalAddSum;

        continueText = new TextEntity(160, 210, "Space to Continue", 12);
        if(LevelManager.totalMoney > 0 && LevelManager.damageTaken < 100)
        {
            reportOutcomeText = new TextEntity(160, 180, "Wave Successful!", 12);
            reportOutcomeText.textBitmap.color = 0x00FF00;
            add(reportOutcomeText);

            
        }
        else if(LevelManager.totalMoney > 0)
        {
            reportOutcomeText = new TextEntity(160, 180, "Wave In progress..", 12);
            reportOutcomeText.textBitmap.color = 0xC8FF00;
            add(reportOutcomeText);
            LevelManager.waveInProgress = true;
        }
        else 
        {
            continueText.currentText = "Survived " + (LevelManager.currentWaveNum - 1) + " / 10 Out of waves.\nSpace to restart the game";
            reportOutcomeText = new TextEntity(110, 180, "Game Over!", 12);
            reportOutcomeText.textBitmap.color = 0xFF0000;
            add(reportOutcomeText);
            gameOver = true;
        }

        
        add(continueText);

        reportOutcomeText.x = 160;
        continueText.x = continueText.x - (continueText.textBitmap.textWidth / 2);
        reportOutcomeText.x = reportOutcomeText.x - (reportOutcomeText.textBitmap.textWidth / 2);
        reportOutcomeText.textBitmap.alpha = 0;

        //add(lootCollectedText);
        //add(outcomeText);
        //add(totalSumText);
        //add(totalMoneyEndText);

        ents.push(new Entity(160 + 43, 35 + 40, new Image("graphics/UISeparator2.png")));
        ents.push(new Entity(160 - 85, 100 + 40, new Image("graphics/UISeparator3.png")));


        activateSceneTween = new VarTween();
        activateSceneTween.tween(this, "bgAlpha", 0.8, 1.5, Ease.cubeInOut);

        
        switchSceneTween = new VarTween();
        addTween(activateSceneTween, true);
        addTween(switchSceneTween);

        for (text in texts)
        {
            add(text);
        }

        for (ent in ents)
        {
            add(ent);
        }

        var tweenDur:Float = 0.5;
        showCaseTween = new VarTween();
        showCaseTween.tween(damageTakenText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
        showCaseTween.onComplete.bind(function() {
            showCaseTween.tween(lootCollectedText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
            showCaseTween.start();
            showCaseTween.onComplete.clear();
            showCaseTween.onComplete.bind(function() {
                showCaseTween.tween(outcomeText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
                showCaseTween.start();
                showCaseTween.onComplete.clear();
                showCaseTween.onComplete.bind(function() {
                    showCaseTween.tween(totalSumText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
                    showCaseTween.start();
                    showCaseTween.onComplete.clear();
                    showCaseTween.onComplete.bind(function() {
                        showCaseTween.tween(totalMoneyEndText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
                        showCaseTween.start();
                        showCaseTween.onComplete.clear();
                        showCaseTween.onComplete.bind(function() {
                            showCaseTween.tween(reportOutcomeText.textBitmap, "alpha", 1, tweenDur, Ease.circInOut);
                            showCaseTween.start();
                            showCaseTween.onComplete.clear();
                        });
                    });
                });
            });
        });
        addTween(showCaseTween);

        activateSceneTween.onComplete.bind(function () {
            showCaseTween.start();
        });
    }

    override function update() 
    {
        super.update();
        
        if(!showCaseTween.active)
            startingMoney = MathUtil.lerp(startingMoney, LevelManager.totalMoney, 0.08);
        if(Math.abs(startingMoney - LevelManager.totalMoney) < 0.1)
            startingMoney = LevelManager.totalMoney;
        totalMoneyEndText.currentText = "Total Money: " + Std.int(startingMoney);
        if(startingMoney <= 0)
            totalMoneyEndText.textBitmap.color = 0xFF0000;

        damageTakenSumText.textBitmap.alpha = damageTakenText.textBitmap.alpha;
        lootCollectedSumText.textBitmap.alpha = lootCollectedText.textBitmap.alpha;
        outcomeSumText.textBitmap.alpha = outcomeText.textBitmap.alpha;
        continueText.textBitmap.alpha = reportOutcomeText.textBitmap.alpha;

        if(!activateSceneTween.active && !showCaseTween.active)
        {
            if(Input.pressed("Space"))
            {
                if(!gameOver)
                {
                    switchSceneTween.tween(this, "bgAlpha", 1, 0.5, Ease.cubeOut);
                    switchSceneTween.onComplete.bind(function() {
                        if(!LevelManager.waveInProgress)
                            Globals.gameScene.levelManager.clearEverything();
                        else
                            Globals.gameScene.levelManager.clearForResume();
                        Globals.gameScene.updateLists();
                        //Globals.gameScene.update();
                        Globals.gameScene.render();
                        switchSceneTween.tween(this, "bgAlpha", 0, 0.5, Ease.cubeOut);
                        switchSceneTween.start();
                        switchSceneTween.onComplete.clear();
                        switchSceneTween.onComplete.bind(function() {
                            HXP.engine.popScene();
                        });
                    });
                }
                else
                {
                    HXP.engine.popScene();
                    HXP.engine.popScene();
                    HXP.scene = new MainMenuScene();
                }
            }
        }

        if(switchSceneTween.active )
        {
        for (e in _update)
            {
                e.graphic.alpha = bgAlpha;
            }
        }

        for (text in texts)
        {
            text.textBitmap.alpha = bgAlpha;
        }
    
        for (ent in ents)
        {
            ent.graphic.alpha = bgAlpha;
        }
    }
}