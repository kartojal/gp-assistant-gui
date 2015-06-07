# gp-assister-gui
gpuPlotGenerator Front-End by Kartojal, with Zenity tools and bash scripting for gnu/linux systems, tested on Ubuntu 14.04

# Dependencies
- Bash
- zenity
- GpuPlotGenerator

# How-to
Easy way:
1. First, get OpenCL and propietary drivers for your graphics card, docs:
  - http://wiki.tiker.net/OpenCLHowTo
  - https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia
  - https://help.ubuntu.com/community/BinaryDriverHowto/AMD
2. Download gp-assistant-gui from [HERE](https://mega.co.nz/#!H4NRWZaT!y2g73kzurtv8k_S_nijN16TzCvFEQS91AZkJzRAJRWg)
3. ¡Extract it!
4. Double-click on gp-assistant-gui executable, reply the questions, select the directory where the plots will be written, and let the gp-assistant launch gpuPlotGenerator with the correct parameters.
5. ¡Mine!

If you already have gpuPlotGenerator:
1. Clone this repository, extract it.
2. Copy gp-assistant-gui and gpuminer_loop to your gpuPlotGenerator directory.
3. Add execution permissions: chmod +x gp-assistant-gui gpuminer_loop
4. Execute it via terminal:
  ./gp-assistant-gui

# How-to compile this Bash Script to binary
You can compile a bash script to binary, with shc by " Francisco Javier Rosales García "

1. Go here http://www.datsi.fi.upm.es/~frosal/
2. Download shc-3.8.9.tgz, uncompress, navigate to the dir, compile it ( make )
3. Then, with that tool, just do: shc -fT gp-assistant-gui
Now you have gp-assistant-gui script compiled in C!
