library(ggplot2)

f8_path <- "sizes-8.csv"
df8 <- read.csv(file=f8_path)
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), alpha=1/2) + geom_point(size=.2)
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), alpha=I(.5), size=I(1)) + stat_smooth(se=FALSE, normalize=FALSE)
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), size=I(1.2)) + stat_smooth(se=FALSE, normalize=FALSE) + scale_color_brewer(palette="Set1")
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), size=I(1.2)) + stat_summary(fun.y=mean, geom="line") + scale_color_brewer(palette="Set1")		
