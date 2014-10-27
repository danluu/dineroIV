library(ggplot2)

df8 <- read.csv(file="sizes-8b.csv")
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), alpha=1/2) + geom_point(size=.2)
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), alpha=I(.5), size=I(1)) + stat_smooth(se=FALSE, normalize=FALSE)
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), size=I(1.2)) + stat_smooth(se=FALSE, normalize=FALSE) + scale_color_brewer(palette="Set1")
qplot(data=df8, x=size, y=miss, color=policy, position=position_jitter(h=0, w=.1), size=I(1.2)) + stat_summary(fun.y=mean, geom="line") + scale_color_brewer(palette="Set1")		

qplot(data=df8, x=size, y=miss_ratio, color=policy, position=position_jitter(h=0, w=.1), size=I(1.2)) + stat_summary(fun.y=mean, geom="line") + scale_color_brewer(palette="Set1")

df2 <- read.csv(file="sandy-2.csv")
 qplot(data=df2, x=name, y=miss, color=policy, position=position_jitter(h=0, w=.2), size=I(1.2)) + scale_color_brewer(palette="Set1") + theme(axis.text.x = element_text(angle = 45, vjust=1, hjust=1))
