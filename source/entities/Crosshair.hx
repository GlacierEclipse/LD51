package entities;

import haxepunk.Camera;
import haxepunk.input.Mouse;

class Crosshair extends GameEntity
{
    public function new() 
    {
        super(0, 0, "", 16, 16);
        Mouse.hideCursor();
    }

    override function render(camera:Camera) 
    {
        super.render(camera);
        
    }
}