package scenes;

import haxepunk.HXP;
import haxepunk.input.Input;
import haxepunk.graphics.Image;
import haxepunk.Entity;
import haxepunk.Scene;

class MainMenuScene extends Scene
{

    public function new() 
    {
        super();
        var e = new Entity(0, 0, new Image("graphics/MainMenu.png"));
        e.graphic.smooth = false;
        add(e);
    }

    override function update() 
    {
        super.update();
        if(Input.pressed("Enter"))
        {
            HXP.scene = new GameScene();
        }
    }
}