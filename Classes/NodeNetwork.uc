class NodeNetwork extends Object
     config(UT2004RPG);

var Array < Node > Nodes;     //All Nodes in the map
var config float MinimumSpawnRadius;
var config float PacketDistancePerSecond;

static function InsertNode(Node Node)
{
     if (Node == None)
          return;
     default.Nodes.Insert(0, 1);
     default.Nodes[0] = Node;
}

static function RemoveNode(Node Node)
{
     local int i;
     for (i = 0; i < default.Nodes.Length; i++)
          if (default.Nodes[i] == Node)
               default.Nodes.Remove(i, 1);
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

defaultproperties
{
     MinimumSpawnRadius=1000.00
     PacketDistancePerSecond=1000.00
}
