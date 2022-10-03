class UpgradeValue
{
    public var upgradeLevel:Int;
    public var upgradeCost:Int;
    public function new(upgradeCost:Int) 
    {
        upgradeLevel = 0;
        this.upgradeCost = upgradeCost;
    }
}