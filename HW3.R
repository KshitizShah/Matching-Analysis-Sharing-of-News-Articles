#install.packages('MatchIt')

library(MatchIt)

#work space preliminaries
rm(list=ls())

#set corresponding working directory
setwd("C:\\Users\\kshit\\Documents\\JHU Class\\Spring 1\\Customer Analytics\\Homework\\Homework 3\\Dataset")

original_ds <- read.csv("D5.2 Mashable.csv")

nrow(original_ds)
ncol(original_ds)
summary(original_ds$shares)
#Task1 
# a) create a dummy variable that equals 1 if number of videos included in the article are > 0

task1_ds <- original_ds

View(task1_ds) #before

task1_ds$treatment = ifelse(task1_ds$num_videos >0 ,1, 0)

View(task1_ds)
#Try taking log of shares (because shares is skewed right)
 task1_ds$lnshares = log(task1_ds$shares)
 summary(task1_ds$lnshares)
 ncol(task1_ds)

 ds<- task1_ds
# b) run a linear regression to determine a correlational estimate of whether an article
# is shared more if it contains a video

# checking initially with just the treatment indicator variable
summary(glm(shares~treatment, family = "gaussian", data=task1_ds))

# The inclusion of at least one video is associated with 14.9% more shares.
 summary(lm(lnshares ~ treatment, data = ds))

 # Now when we control for other factors we get that including a video causes a 15.8% increase in shares.
 summary(lm(lnshares ~ treatment+category+weekday+num_imgs+num_keywords+n_tokens_title+n_tokens_content+kwshares_avg,data = ds))
# we get a large t-stat value, and the beta for the treatment indicator = 1418.71. Since the P-value is 
# significant we can say that from a correlational estimate, articles with videos generally do have higher views


#adding significant variables to reduce standard error
summary(glm(shares~treatment+num_videos+num_imgs+num_keywords+kwshares_avg, family = "gaussian", data=task1_ds))
summary(glm(shares~., family = "gaussian", data=task1_ds))

# when we run this regression, we see an interesting outcome: the number of videos do not seem to matter
# in estimating the correlational estimate. We also see the beta for the treatment variable change significantly
# suggesting there might be something else at play here. In general, however, we do see a positive relationship
# between the treatment variable (having a video or not) and the number of shares (the outcome)

#Task2
#a)Create the matched sample
matched = matchit(treatment~ category+weekday+num_imgs+num_keywords+n_tokens_title+n_tokens_content+kwshares_avg, 
            method = 'nearest', data = task1_ds )
matched

#b)Balancing assessment
plot(summary(matched, standardize = TRUE))
summary(matched)

#c)Overlap Assessment
plot(matched, type = 'jitter', interactive = FALSE)
plot(matched, type = 'histogram', interactive = FALSE)


#Task3

#a) Estimate the ATE for treatment defined as an article including at least one video.
ds_matched = match.data(matched, distance = 'pscore')

dim(ds_matched)
View(ds_matched)
#equally divided
table(ds_matched$treatment)

#outcome: number of shares  

summary(glm(shares~treatment, family = "gaussian", data=ds_matched))

#From the analysis of matched dataset, we can know the beta for the ATE (treatment indicator) = 1306.6 with a significant 
#p-value. Therefore, the video do increase the number of shares. 

#b) Does the ATE differ from the correlational estimate of 1.a? If so, what may explain this difference?
# Comparing to the ATE is 1418.71 in task 1.a, the ATE of task 3.a is smaller. The difference may because changes in 
#'shares' are also influenced by other factors (Z's or confounds). For example, articles on established pages might have videos
#'Since these pages are established, the number of shares would already be higher than other pages who also have articles with videos. 
#'in this case, the traffic of consumers on a website can act as a confound for number of shares which may be why the co-relational estimate 
#'is different that the causal estimate

#c)Compare the ATEs obtained in two cases:

task3i <- original_ds[original_ds$num_videos<=1,]
task3ii <- original_ds[original_ds$num_videos>=1,]

#create new data subsets for comparision
task3i$treatment = ifelse(task3i$num_videos == 1 ,1, 0)
task3ii$treatment = ifelse(task3ii$num_videos >= 2 ,1, 0)


#task3: ci) articles that include no videos versus article that contain 1 video

#create matched datasets:
matched3i = matchit(treatment~ category+weekday+num_imgs+num_keywords+n_tokens_title+n_tokens_content+kwshares_avg, 
                  method = 'nearest', data = task3i )
plot(summary(matched3i, standardize = TRUE))
ds_matched3i = match.data(matched3i, distance = 'pscore')
dim(ds_matched3i)
table(ds_matched3i$treatment) # lesser number of observations

#running regression: num_videos 0 v/s 1
summary(glm(shares~treatment, family = "gaussian", data=ds_matched3i))

# We observe an ATE of 1091.8. Implying articles with 1 video do significantly better than articles
# with no videos

#task3: cii) articles with 1 video v/s articles with 2 or more videos
#create matched datasets:
matched3ii = matchit(treatment~ category+weekday+num_imgs+num_keywords+n_tokens_title+n_tokens_content+kwshares_avg, 
                    method = 'nearest', data = task3ii )
plot(summary(matched3ii, standardize = TRUE))
ds_matched3ii = match.data(matched3ii, distance = 'pscore')
dim(ds_matched3ii)
table(ds_matched3ii$treatment) # lesser number of observations

#running regression: num_videos 1 v/s greater than 2
summary(glm(shares~treatment, family = "gaussian", data=ds_matched3ii))

# here we see that the treatment indicator is not significant even at 10%. therefore
# having more than 1 video (treatment =1 in this case), can be deemed to be not any more beneficial
# than just having 1 video in the article (treatment = o)









