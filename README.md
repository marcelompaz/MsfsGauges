# Air Manager Gauges for MSFS 2020

Here are some gauges and equipment I've done for the EMB-110 (NextGen) to be used with Air Manager. 
Most of the important gauges are done, but I haven't done some very generic ones (altimeter, EADI, vertical speed, radar altimeter, VOR/ADF, HSI). Those ones I'm using from other aircrafts and specifically for the HSI I'm using the payware version of the G5 because there is none of the stock ones that works when using GPS. The vertical speed can be popped-out directly from MSFS. 

For Flaps, Propeller Sync and Autofeather I used some screenshots directly from MSFS and that's why they look bad, but I'm terrible with graphical design so I didn't even try do draw it by myself

I play with two monitors, so here it's an example how I use those gauges: 

![Bandeirante Main](https://github.com/marcelompaz/MsfsGauges/assets/18484523/6bad19b5-7bb3-44c8-bfe3-9e59060d6aad)

![Bandeirante Secondary](https://github.com/marcelompaz/MsfsGauges/assets/18484523/f590c26f-084a-42be-8b15-17a46b1a0279)

The GNS530/430 I use the default ones from MSFS

# KAS297 (altitude/vertical speed selector) and KMC321 (auto-pilot)
The KAS297 display can be popped-out from MSFS, but there is no SDK event to control the switch between VS and ALTITUDE, so I wrote the display myself. There is no need to pop-out the KAS297 with this version. But the VS/ALTITUDE (knob press) selection will not be reflected on the real airplane. But the opposite (pressing the knob inside MSFS) will be reflected on AirManager. 
On KMC321 I added Proppeller Sync/Autofeather to the Soft Ride and Half Bank buttons because those are not operational on the simulator, so why not? :D

# Custom Gauges
As I mentioned, my graphical skills are very poor, so instead of drawing gauges manually, I wrote a library to generate them (lib folder). The library contain a part for gauges (gauges.lua) and the needles (needle.lua). You can have multiple gauges and needles in the same instrument. Graphically is not very pretty, but it's very fast to draw a new gauge if needed. And it can be used for any airplane, just copy the content of the lib folder to your gauge and it's ready to be used. 
There is a README file inside the lib folder explaining how to use the lib 

# Maybe future developments 
- Annunciator panels
- Buttons on the middle panel (crossfeed, fuel, etc), maybe together with the already created fuel gauges
- Top panels
- EADI and HSI that matches more the ones from the real airplane

But even with some things missing, the most important is already done and working! Feel free to use and collaborate

