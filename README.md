# VisClaw with Julia
This repository aims to become one of the Clawpack visualization tools (see http://www.clawpack.org).  
This allows us to make animations with the Julia language as shown below.   
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/gif/demo_chile2010.gif" width="480">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/gif/demo_ike.gif" width="480">   
(chile2010 and ike, the examples of geoclaw)   
Please contact the author if you find a bug.  

# Requirements
## Julia Packages
- Julia (>=0.6.2)
- Plots
- GR  

## Others  
In order to make animations, the following softwares are necessary.  
- bash
- convert (ImageMagick)
- ffmpeg

# Usage
- Install the required packages and softwares
- Clone this repository
```bash
git clone https://github.com/hydrocoast/visclaw_julia
cd visclaw_julia
```
- Set the appropreate paths in the main \*.jl file
- Execute the main \*.jl file
- `./animation.sh` to make an animation if you want

# License
BSD 3-Clause  

# Author
Takuya Miyashita   
miyashita(at)hydrocoast.jp  
Doctoral student, Kyoto University  
([personal web site](https://hydrocoast.jp))  
