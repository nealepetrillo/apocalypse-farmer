# Introduction #

Generating the hex board quickly so other program components can reference it.

# Details #

Although the temptation for vector based board generation is strong due to the resize ability of vectors, in the interest of time, I think we should stay with using bitmaps.

Here is my suggestion on how a quick hex environment could be generated.

The freeware program **Draw Hexgrid 2.3** can be used to generate a bitmap board
that can establish the structure of the game at an early stage so other game
components can reference the board as quickly as possible.

During the early development phase, the hexes can have numbers on them (row/col).
Then when the game is closer to being complete, the board can be re-generated
without those numbers and replaced with cut-paste bitmap artwork representing the
various terrain types.  (That would be tedious but simple work)  The default size
of **44 pixles per hex side** is ideal for the size required for artwork.

The initialization game code would consist of the bitmap being put on the layer
as an object referencing the bitmap.  Then, each actionscript hex object would
be updated with the terrain data for each hex.  Initially, one map would be all that
would be needed.  However, an additional map and map data could easily be added (perhaps
as a more difficult level).

Terrain improvements such as new structures, player pieces and of course
ownership outlines would simply be added on top of the original map on a
different layer on the stage.

A copy of the hex generator program is available at:

http://cryhavocgames.net/Tutorials_Utilities.htm

Since the map will likely be larger than the screen area can display, a decision on scrolling will need to be made.  I think flash has the performance to handle a scrolling bitmap.  If not, the hex board could be moved by hex sized jumps.

A useful trick from the earlier days of video games is to populate the pieces on a
a layer when it is not visible, then toggle the visibility since such a toggle is very quick.

Once scale is decided (100ft vs. 10,000ft hex size) artwork of the terrain modifiers and player pieces can be started.