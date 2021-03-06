/// terrain_create_ext(x,y, width, height, scale)
/// Creates a destructable terrain grid over a given region of the room
/// @param x The left position of the terrain in the room
/// @param y The top position of the terrain in the room 
/// @param width the width of the terrain grid (in grid cells not pixels)
/// @param height the height of the terrain grid (in grid cells not pixels)
/// @scale The size of a cell in the terrain grid
/// @return The terrain id

var arg_x = argument0;
var arg_y = argument1;
var arg_width = argument2;
var arg_height = argument3;
var arg_scale = argument4;

// Create the terrain object
var terrain = instance_create(arg_x,arg_y, oTerrain);
terrain.width = arg_width;
terrain.height = arg_height;
terrain.scale = arg_scale;
terrain.triangles = 0;
terrain.wireframe = false;
terrain.image = noone;

// The surface that the terrain will be redrawn to
// Will not be created until needed - helps recover
// from errors when the surface is freed
terrain.surface = noone;

// Create a viewport to clip terrain drawing
terrain.view_gx1 = 0;
terrain.view_gy1 = 0;
terrain.view_gx2 = terrain.width;
terrain.view_gy2 = terrain.height;

// The number of regions that need repainting
terrain.dirty_regions = 0;

// TODO reverse array initialization - faster to allocate array
// memory in reverse (one big memory allocation rather than lots
// of little increments)

// TODO more documentation of what we're doing at each step

var i = 0;
// Create a lookup for terrain position position gx,gy = i
for (var gx = 0; gx <= terrain.width; gx++)
for (var gy = 0; gy <= terrain.height; gy++)
{
    terrain.grid_index[gx,gy] = i++;    
}

// Initializing density
for (var gx = 0; gx <= terrain.width; gx++)
for (var gy = 0; gy <= terrain.height; gy++)
{
    var i = terrain.grid_index[gx,gy];
    terrain.density[i] = 0;
    terrain.polygons[i] = 0;
    
    // Max. 3 triangles per square
    for (var k = 0; k < 3; k++)
    {
        terrain.px1[i,k] = 0;
        terrain.py1[i,k] = 0;
        terrain.px2[i,k] = 0;
        terrain.py2[i,k] = 0;
        terrain.px3[i,k] = 0;
        terrain.py3[i,k] = 0;
    }
}

return terrain;
