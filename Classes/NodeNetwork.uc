class NodeNetwork extends Object
     config(UT2004RPG);

var Array < Node > Nodes;     //All Nodes in the map
var config float MinimumSpawnRadius;
var config float PacketDistancePerSecond;
var float TotalDrainPerSecond;       //Sum of ChargeDrainPerSecond across all Nodes

static function InsertNode(Node Node)
{
     if (Node == None)
          return;
     default.Nodes.Insert(0, 1);
     default.Nodes[0] = Node;
     Log("Node added. Nodes Length: " $ default.Nodes.Length $ ". TotalDrainPerSecond: " $ default.TotalDrainPerSecond);
}

static function RemoveNode(Node Node)
{
     local int i;
     if (Node == None)
     {
          Log("No Node found in RemoveNode");
     }
     for (i = 0; i < default.Nodes.Length; i++)
          if (default.Nodes[i] == Node)
          {
               default.Nodes.Remove(i, 1);
               Log("Removed Node. Nodes Length: " $ default.Nodes.Length $ ". TotalDrainPerSecond: " $ default.TotalDrainPerSecond);
          }
}

//Check whether a Node can be spawned at the provided NodeLocation by checking against all other Nodes
static function bool CanSpawnNode(vector NodeLocation)
{
     local int i;

     for (i = 0; i < default.Nodes.Length; i++)
          if (VSize(default.Nodes[i].Location - NodeLocation) < default.MinimumSpawnRadius)
               return false;
     return true;
}

// return the lowest amount of charge for a node on the network, adjusted for Drain rate
static function float GetLowestChargeValue()
{
    local float MinCharge;
    local float ThisNodeCharge;
    local float ChargeDrainPerSecond;
    local int i;
    
    if (default.Nodes.length == 0)
        return 0;
        
    MinCharge = -1;    
	for (i = 0; i < default.Nodes.length; i ++)
    {
        if (default.Nodes[i] != None)
       {
            ThisNodeCharge = default.Nodes[i].Charge;
            if (ThisNodeCharge == 0)
                if (MinCharge < 0)
                    MinCharge = 0; 

            ChargeDrainPerSecond = 0;            
            if (NodeController(default.Nodes[i].Controller) != None)
                ChargeDrainPerSecond = NodeController(default.Nodes[0].Controller).ChargeDrainPerSecond;    

            if (ChargeDrainPerSecond > 0)    
            {
                if (MinCharge < 0 || ThisNodeCharge / ChargeDrainPerSecond < MinCharge)
                    MinCharge = ThisNodeCharge / ChargeDrainPerSecond;    
            }    
            else
            {
                if (MinCharge < 0 || ThisNodeCharge < MinCharge)
                    MinCharge  = ThisNodeCharge;
            }
       }
    }

    if (MinCharge < 0)
        return 0;
    else
        return MinCharge;
}

defaultproperties
{
     MinimumSpawnRadius=1000.00
     PacketDistancePerSecond=1000.00
}
