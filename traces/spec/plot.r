library(ggplot2)

# color scheme used below is from http://colorbrewer2.org/
# "qualatative", red blue green purple...

dev.copy(png,"both.png",width=640,height=480)

# Plot sandy bridge miss rates
df2 <- read.csv(file="sandy-2.csv")
qplot(data=df2, x=name, y=miss, color=policy, shape=policy, position=position_jitter(h=0, w=.2), size=I(4)) + 
labs(x="Benchmark",y="Miss rate") +
scale_y_continuous(limits=c(0,.35)) +
  scale_colour_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")) +
  scale_shape_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c(15, 16, 17, 23)) +
theme_minimal() +
theme(axis.text.x = element_text(angle = 45, vjust=1, hjust=1))


# Plot miss rates with different sizes (one cache)
df8 <- read.csv(file="sizes-8b.csv")
qplot(data=df8[df8$size <= 24,], x=size, y=miss, color=policy, shape=policy, size=I(4), position=position_jitter(h=0, w=.1))  + 
labs(x="Cache size (single cache)",y="Miss rate") +
scale_x_continuous(breaks=16:24, limits=c(16,24), labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(limits=c(0,.35)) +
  scale_colour_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")) +   
  scale_shape_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c(15, 16, 17, 23)) +
theme_minimal()

# Plot miss rates with different sizes (3-level cache)
dfm8b <- read.csv(file="sizes-multi-8b.csv")
qplot(data=dfm8b[dfm8b$size <= 24 & dfm8b$size > 18,], x=size, y=miss, color=policy, shape=policy, size=I(4), position=position_jitter(h=0, w=.1))  +
labs(x="L3 cache size (64k L1-d/L1-i, 256k L2)",y="Miss rate") +
scale_x_continuous(breaks=16:24, limits=c(16,24), labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(limits=c(0,.37)) +
  scale_colour_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")) +
  scale_shape_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c(15, 16, 17, 23)) +
theme_minimal()

# Ratio of means (single cache)
df8mean <- read.csv(file="size-ratio-means.csv")
qplot(data=df8mean[df8mean$size <= 24,], x=size, y=miss_ratio, color=policy, shape=policy, size=I(4)) + stat_summary(fun.y=mean, geom="line") + 
labs(x="Cache size (single cache)",y="Miss ratio (vs. random)") +
scale_x_continuous(breaks=16:24, limits=c(16,24), labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(limits=c(.9,1.05)) +
  scale_colour_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")) +   
  scale_shape_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c(15, 16, 17, 23)) +
theme_minimal()

# Ratio of means (multi-level cache)
dfm8mean <- read.csv(file="sizes-multi-8-mean.csv")
qplot(data=dfm8mean[dfm8mean$size <= 24 & dfm8mean$size >= 19,], x=size, y=miss_ratio, color=policy, shape=policy, size=I(4)) + stat_summary(fun.y=mean, geom="line") + 
labs(x="L3 cache size (64k L1-d/L1-i, 256k L2)",y="Miss ratio (vs. random)") +
scale_x_continuous(breaks=16:24, limits=c(16,24), labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(limits=c(.9,1.05)) +
  scale_colour_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3")) +   
  scale_shape_manual(name = "Eviction Policy",
                      labels = c("2 random\nchoices", "FIFO", "LRU", "random"),
                      values = c(15, 16, 17, 23)) +
theme_minimal()


# Ratio of means (multi-level cache)
dfpm8mean <- read.csv(file="sizes-p-multi-8-mean.csv")
dfpm8mean_sub <- dfpm8mean[(dfpm8mean$size <= 24 & dfpm8mean$size >= 19) & 
	      (dfpm8mean$policy == "2" | dfpm8mean$policy == "b" | dfpm8mean$policy == "c" | dfpm8mean$policy == "l"),]
qplot(data=dfpm8mean_sub, x=size, y=miss_ratio, color=policy, shape=policy, size=I(4)) + stat_summary(fun.y=mean, geom="line") + 
labs(x="L3 cache size (64k L1-d/L1-i, 256k L2)",y="Miss ratio (vs. random)") +
scale_x_continuous(breaks=16:24, limits=c(16,24), labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(limits=c(.9,1.05)) + 
  scale_colour_manual(name = "Eviction Policy",
		      labels = c("2 choices", "pseudo 2", "psuedo 3", "LRU"),
                      values = c("#e41a1c", "#ff7f00", "#a65628", "#4daf4a")) +   
  scale_shape_manual(name = "Eviction Policy",
		      labels = c("2 choices", "pseudo 2", "psuedo 3", "LRU"),
                      values = c(15, 7, 9, 17)) +
theme_minimal()

dfsam <- read.csv("size-assoc-means.csv")
dfsam_sub <-dfsam[dfsam$size <= 24,]
# dfsam_sub$cut <- cut(dfsam_sub$miss_ratio, breaks=c(seq(.94,1.06,by=.01)),right=FALSE)

qplot(data=dfsam_sub,x=size,y=assoc) + geom_tile(aes(fill=miss_ratio),color="white") + 
scale_fill_gradient2(low="darkgreen",high="darkred",midpoint=1.0) +
scale_x_continuous(breaks=16:24, labels=c("64k","128k","256k","512k","1M","2M","4M","8M","16M")) +
scale_y_continuous(trans="log2", breaks=c(4,8,16,32,64), labels=c(4,8,16,32,64))

