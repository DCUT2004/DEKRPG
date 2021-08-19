//Pawns with this inventory item are undetected by monsters
//Check DCMonsterController for references to this inventory item
class InvisibilityInv extends Inventory;

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
