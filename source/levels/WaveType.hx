package levels;

import entities.Enemy;

class WaveType 
{
    public var waveType:Int;
    public var amount:Int;

    public function new(waveType:Int, amount:Int)
    {
        this.waveType = waveType;
        this.amount = amount;
    }
}