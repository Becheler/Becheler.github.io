
############################# Quetzal Model 1 #################################################################

# 1 - Copy the executable "quetzal/build/model1" into a new directory
# 2 - Create a subdirecotry "output" to store the results
      system("mkdir output")
      system("mkdir treatment")
# 3 - In the following line, change "home/dev/quetzal" by your own path towards the library and run it
      system("./model_1 /home/becheler/dev/quetzal/test/data/europe_precipitation.tif")


############################## Print the gif for the demography #####################################

library("raster")
library("rgdal")
library(rasterVis)
library(ggplot2)

N_stack <- stack("output/N.tif")

# Get range of data values across the two rasters
rng <- c()
for(i in 1:99){
  rng = range( c( rng, getValues( N_stack[[i]] ) ), na.rm = TRUE )
}

gif_plot <- function(raster, rng, title, subtitle){
  gplot(raster) + 
    geom_tile(aes(fill=value)) +
    ggtitle(title, subtitle) +
    labs(x = "lon") +
    labs(y = "lat") +
    scale_fill_gradient(name = "N value", low="white", high="green",
                        breaks=seq(0,1000,20),  # Set whatever breaks you want
                        limits=c(floor(rng[1]), ceiling(rng[2])))  # Set the same limits for each plot
}


for(i in 1:min(99, nlayers(N_stack))){
  if(i < 11){
    file= paste0(0, i-1, ".png")
  }else{
    file= paste0(i-1, ".png")
  }
  png( filename = paste0(getwd(), "/treatment/", file), width=4, height=3.352, units="in", res=300)
  print( gif_plot( N_stack[[i]], rng, "", paste("Generation", i)) )
  dev.off() #only 129kb in size
}

# To get the animated GIF, run in a terminal
system("convert treatment/*.png -delay 1 -loop 0 history.gif")


#################################### Printing the sampling schemes #############################################

spain_sampling <- readOGR(dsn = "output", layer = "spain")
sicilia_sampling <- readOGR(dsn = "output", layer = "sicilia")

png( filename = "sampling.png")

gplot(N_stack[[nlayers(N_stack)]]) + 
  geom_tile(aes(fill=value)) +
  geom_point(data=as.data.frame(spain_sampling), aes(x=coords.x1, y=coords.x2), pch=20, col="blue") +
  geom_point(data=as.data.frame(sicilia_sampling), aes(x=coords.x1, y=coords.x2), pch=20, col="orange") +
  labs(x = "lon") +
  labs(y = "lat") +
  scale_fill_gradient(name = "N value", low="white", high="grey",
                      breaks=seq(0,1000,20),  # Set whatever breaks you want
                      limits=c(floor(rng[1]), ceiling(rng[2])))  # Set the same limits for each plot

dev.off() #only 129kb in size

################################### Visualizing trees #########################################################

library("ggtree")

tree <- read.tree("output/trees.txt")
tree

dd <- data.frame(taxa  = tree$tip.label, 
                 place = factor(tree$tip.label)
)

png( filename = paste0(getwd(), "/sampling_viz/tree.png"))
p <- ggtree(tree)
p <- p %<+% dd + geom_tippoint(aes(color=place), alpha=0.25)
p + theme(legend.position="right")
dev.off() #only 129kb in size

################################### Simulating sequences #######################################################

#### Using Seq - Gen

setwd("/home/becheler/dev/sampling_project")
system("./seq-gen -mHKY -l70 -n1 -of -s0.0002 < output/trees > output/seqgen.fasta")

#### Adding identifier to the FASTA file

lines = readLines("output/seqgen.fasta",-1)
for(i in seq(1, length(lines), 2)){
  lines[i] = paste0(lines[i], " ", ceiling(i/2))
}
writeLines(lines,"output/sequences.fasta")

#### Plot sequences

library("apex")
data <- read.multiFASTA(c("output/sequences.fasta"))
png( filename = paste0(getwd(), "/output/sampling_viz/sequences.png"))
plot(data, cex = 0.2)
dev.off() #only 129kb in size
