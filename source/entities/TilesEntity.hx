package entities;

import haxepunk.graphics.tile.Tilemap;
import haxepunk.Entity;

class TilesEntity extends Entity
{
    public var tileMap:Tilemap;
    public function new() 
    {
        super();
        
    }

    public function initTiles(mapWidth:Int, mapHeight:Int) 
    {
        tileMap = new Tilemap("graphics/Tiles.png", mapWidth, mapHeight, 16, 16, 1, 0, 0, 0);
        graphic = tileMap;
    }
}