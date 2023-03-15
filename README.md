
The sharing of news articles is a great way to increase website traffic for newsproviders. In this study, we test the claim that having one or 
more videos in your article increases shares by a tremendous amount. 

Main methodologies used in this analysis are: Matching Analysis and Multivariate regression to hold confounds (Z's) fixed.

The process was as follows:
1.Defined a treatment indicator variable that equals 1 if the number of videos 
included in an article (num_videos) is larger than zero, and which equals 0 otherwise.
2.Explored data and adjusted for skewness
3.Calculated correlational estimates between shares and number of articles
4.Created a matched sample based on logistic propensity scores and checked for balance and overlap issues
5.Calculated Average Treatment Effect (ATE) based on whether or not the articles contained one or more videos.
6.Compared the ATEs obtained in two more cases: 
(i) articles that include no  videos  versus  articles  that  contain  1  video,  and  
(ii)  articles  that  include  1  video  versus articles that contain 2 or more videos 

INFORMATION ON THE DATASET:

Data Set Information:
The dataset contains information of articles published by Mashable (www.mashable.com) and
their content as the rights to reproduce it belongs to them. This dataset does not share the original
content of the covered articles, but some statistics associated with it. The key outcome variable is
“shares”, defined at the bottom of the list below.

Attribute Information:
1. n_tokens_title: Number of words in the title
2. n_tokens_content: Number of words in the content
3. num_imgs: Number of images
4. num_videos: Number of videos
5. num_keywords: Number of keywords in the metadata
6. category: lifestyle, entertainment, etc. (categorical)
7. weekday: day-of-week of publication (categorical)
8. kwshares_avg: avg shares of the average-performing included keyword
9. shares: Number of shares
