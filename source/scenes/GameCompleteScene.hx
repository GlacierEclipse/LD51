package scenes;

import haxepunk.HXP;
import haxepunk.input.Input;
import haxepunk.graphics.TextEntity;
import haxepunk.Scene;

class GameCompleteScene extends Scene
{
    public var texts:Array<TextEntity>;

    public function new() 
    {
        super();
        texts = new Array<TextEntity>();
        bgColor = 0x31393A;
        texts.push(new TextEntity(0, 0, "Congratulations for beating the game!", 12));
        texts.push(new TextEntity(0, 0, "Thank you for playing!", 12));
        texts.push(new TextEntity(0, 0, "Created for LD51 :)", 12));
        texts.push(new TextEntity(0, 0, "By GlacierEclipse", 12));
        texts.push(new TextEntity(0, 0, "Enter to return to Menu", 12));

        var yOffset:Float = 30;
        for (text in texts)
        {
            text.x = 160 - text.textBitmap.textWidth / 2;
            text.y = yOffset;
            add(text);
            yOffset += 30;
        }

    }

    override function update() 
    {
        super.update();

        if(Input.pressed("Enter"))
        {
            HXP.scene = new MainMenuScene();
        }
    }
}