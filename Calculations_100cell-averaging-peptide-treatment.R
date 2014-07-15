##Calculations and data workings for ~100 cell averaging for Atg8 dot counting between hl5c and diluted mediums
##each medium taken with and without peptide (first peptide) treatement at 30 and 60 min peptide incubation

library(MASS)
library(ggplot2)
library(gdata)
library(car)
library(lmtest)
library(stats)
library(foreign)
library(vcd)
library(extrafont)
library(directlabels)
library(graphics)
library(tikzDevice)
library(xtable)
path <- "/Users/genovillafano/Dropbox/1Current/AG_Hagedorn/140710-Dilute-and-HL5c-Wpeptide-fixed/points/Counting-CSVs/"
file.list <- list.files(path)
file.list

#paste0() used to concatenate two strings and convert to characters, removes a space that breaks the file path otherwise 
#creating list containing all data from counting in order seen in file.list and names vectors
counts <- c()
for(i in 1:length(file.list)){ 
  counts[i] <- read.csv(paste0(path, file.list[i]))
}

#creating vector of cell counts in order of names vector
names <- c("Dilute \n Control 30'", "Dilute \n Control 60'", "Dilute \n Peptide 30'", "Dilute \n Peptide 60'", 
           "HL5c Control \n 60'", "HL5c Peptide \n 30'", "HL5c Peptide \n 60'")
#cell counts for each image from each set, with order matching the names vector
cells <- list(c(11, 11, 9,11,14,11,12,18), c(14,25,17,12,13,22), c(26,25,26,20), c(16,14,19,17,25,16), 
              c(12,13,14,11.5,13,11,15.5), c(15,17,19,21,26,33), c(12,20,14,16,20,25))

#with 5 counts per image (due to 5 slices per image counted) and varying numbers of images per set, every 5 counts
#are summed within each subset of  the'counts' list
sequence <- list()
sum.counts <- list()
#'sequence' list being a list of vectors corresponding to the range of each count vector split by 5
#This vector is then used to generate the ranges at which each count vector should be summed as to group
#each summation by the image that generated it, hence the count for all slices per image are summed
#This allows the number of dots per cell to be evaluated on an image to image bases for each image set
for(i in 1:length(counts)){
  a = i
  sequence[[a]] <- c(seq(from = 0, to = length(counts[[a]]),  by =5)) 
  for(b in 1:((length(sequence[[a]])-1))){
    sum.counts[[c(a,b)]] <- sum(counts[[a]][sequence[[c(a,b)]]:sequence[[c(a,(b+1))]]])
      }
}
##list of each 5 countings summed, representing the sum of dots per image per set (order still matches names vector)
sum.counts
##Getting the average number of dots per cell from each image for each set (order still matches names vector)
avg.dots <- list()
for(i in 1:length(cells)){
  a = i
  avg.dots[[a]] <- round(c(sum.counts[[a]]/cells[[a]])) 
}
##list of the average dots per cell per image in each set (same order as names vector)
avg.dots
#notice that most of the vectors are close in number to each other indicating method works rather well

##Getting the averges for each treatment across all images in each set (order still follows name vector)
avg.for.plot <- list()
for(i in 1:length(avg.dots)){
  avg.for.plot[[i]] <- round(sum(avg.dots[[i]])/length(avg.dots[[i]]),1) 
}
#list of colours
sequence.numbers <- round(seq(from = 10, to = 88, by = 11))
colour.list <- c()
for(i in 1:length(sequence.numbers)){colour.list[i] <- colours()[sequence.numbers[i]]}
unlist(avg.for.plot)
colour.list

barplot(unlist(avg.for.plot[5:7]), names.arg = names[5:7], col = c('sienna', 'slateblue1', 'slateblue') ) 

######----SCRAP----######

colours()
names
length(avg.dots[[1]])
length(sum.counts[[8]])
sum.counts[7]
sum.counts[[2]]/cells[[2]]

length(sum.counts) == length(cells)
sequence[[c(1,1)]]
sum(counts[[1]][0:5])
counts[[1]]
sequence[2]

counts[[1]]
 c(seq(from = 0, to = length(counts[[1]]),  by =5))
sequence

for(i in 1:length(cells)){print(length(cells[[i]]))}
for(i in 1:length(sum.counts)){print(length(sum.counts[[i]]))}

sum.counts <-c(c())
counts[[1]][0:5]
sum(counts[[1]][sequence[a]:sequence[a+1]])
sequence <- c(c())

length(counts[[7]])
length(counts[[c(1)]])
counts
list[sequence[2]:sequence[3]]

list
list <-c(counts[[c(1,1)]])
cut(seq_along(list), 5, labels= FALSE)
split(counts[[c(1,1)]], ceiling(seq_along(counts[[c(1,1)]]/5)))
split(d, ceiling(seq_along(d)/20))

#accesses first index in first list of list one
counts[[c(1,1,1)]]
