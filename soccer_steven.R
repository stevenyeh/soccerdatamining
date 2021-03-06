setwd('/Users/Stevenstuff/Downloads')
#setwd("/Users/Stevenstuff/soccerdatamining")
soccer <- read.csv('Soccerdata.csv')

# fill in blanks with NA's
soccer[soccer==""] <- NA

# betting data as numeric instead of factor
for(i in rep(20:49)) {
  soccer[,i] <- as.numeric(soccer[,i])
}

# remove "diff" columns: time since last update
soccer <- subset(soccer, select=-c(rank_Update_diff1, rank_Update_diff11, 
                                   Update_diff1, Update_diff11))

# buildUpPlayDribbling_home and buildUpPlayDribbling1_away has 19088 NA's
soccer <- subset(soccer, select=-c(buildUpPlayDribbling_home, buildUpPlayDribbling1_away))

# remove duplicate columns
soccer <- subset(soccer, select=-c(country_id1, league_id, team_api_id, 
                                   team_api_id1, team_api_id1_away_away, 
                                   id3_home, id4, team_fifa_api_id2_home,
                                   team_api_id2_home, team_fifa_api_id3_away,
                                   team_api_id3_away))

# new variables
soccer$outcome <- ifelse(soccer$home_team_goal-soccer$away_team_goal > 0, 1, 
                         ifelse(soccer$home_team_goal-soccer$away_team_goal<0, 2, 3))
soccer$outcome <- as.factor(soccer$outcome)
soccer$win <- as.factor(ifelse(soccer$home_team_goal-soccer$away_team_goal > 0, 1, 0))
soccer$lose <- as.factor(ifelse(soccer$home_team_goal-soccer$away_team_goal < 0, 1, 0))
soccer$tie <- as.factor(ifelse(soccer$home_team_goal-soccer$away_team_goal == 0, 1, 0))
soccer$goal_diff_diff <- soccer$Goal_Diff_Home_10.Games-soccer$Goal_Diff_away_10.Games

# remove useless columns
soccer <- subset(soccer, select=-c(id, date, match_api_id, home_team_goal, 
                                   away_team_goal, Goal_Diff_Home, 
                                   Goal_Diff_away, id1_home_home, team_fifa_api_id_home_home,
                                   team_long_name_home_home, team_short_name_home_home,
                                   id2_away_away,team_fifa_api_id1_away_away,team_long_name1_away_away,
                                   team_short_name1_away_away,Country_Name_home,League_name,id5,date1_home,
                                   id6_away,date2_away))

# remove columns with too many factors (messes up classification)
soccer <- subset(soccer, select=-c(home_team_api_id, away_team_api_id))

# factorize columns
names<-c("country_id", "season", "stage")
soccer[,names] <- lapply(soccer[,names], factor)

# EPL dataset
soccer_epl = subset(soccer,country_id==1729)
nan_columns = colnames(soccer_epl)[colSums(is.na(soccer_epl)) > 0]
soccer_epl_nonan <- soccer_epl[, !colnames(soccer_epl) %in% nan_columns]
soccer_epl_nobet <- subset(soccer_epl_nonan, select=-c(B365H,B365D,B365A,WHH,WHD,WHA,VCH,VCD,VCA))

# dataset with betting data removed
library(dplyr)
nan_columns = colnames(soccer)[colSums(is.na(soccer)) > 0]
soccer_nobet <- soccer[, !colnames(soccer) %in% nan_columns]
write.csv(soccer_nobet, 'soccer_nobet.csv', row.names=FALSE)

# dataset with NA rows removed
soccer_nona <- na.omit(soccer)
write.csv(soccer_nona, 'soccer_nona.csv', row.names=FALSE)

write.csv(soccer, 'soccer_clean.csv', row.names=FALSE)


library(nnet)
# doesn't work
test <- multinom(outcome ~ country_id+season+stage+Goal_Diff_Home_10.Games+Goal_Diff_away_10.Games+
                   B365H+B365D+B365A+BWH+BWD+BWA+IWH+IWD+IWA+LBH+LBD+LBA+PSH+PSD+PSA+
                   WHH+WHD+WHA+SJH+SJD+SJA+VCH+VCD+VCA+GBH+GBD+GBA+BSH+BSD+BSA+
                   buildUpPlaySpeed_home+buildUpPlaySpeedClass_home+
                   buildUpPlayDribblingClass_home+buildUpPlayPassing_home+buildUpPlayPassingClass_home+
                   buildUpPlayPositioningClass_home+chanceCreationPassing_home+chanceCreationPassingClass_home+
                   chanceCreationCrossing_home+chanceCreationCrossingClass_home+chanceCreationShooting_home+
                   chanceCreationShootingClass_home+chanceCreationPositioningClass_home+defencePressure_home+
                   defencePressureClass_home+defenceAggression_home+defenceAggressionClass_home+
                   defenceTeamWidth_home+defenceTeamWidthClass_home+defenceDefenderLineClass_home+
                   buildUpPlaySpeed1_away+buildUpPlaySpeedClass1_away+
                   buildUpPlayDribblingClass1_away+buildUpPlayPassing1_away+buildUpPlayPassingClass1_away+
                   buildUpPlayPositioningClass1_away+chanceCreationPassing1_away+chanceCreationPassingClass1_away+
                   chanceCreationCrossing1_away+chanceCreationCrossingClass1_away+chanceCreationShooting1_away+
                   chanceCreationShootingClass1_away+chanceCreationPositioningClass1_away+defencePressure1_away+
                   defencePressureClass1_away+defenceAggression1_away+defenceAggressionClass1_away+
                   defenceTeamWidth1_away+defenceTeamWidthClass1_away+defenceDefenderLineClass1_away, data=soccer_nobet)
# multinomial model
model <- multinom(outcome ~ country_id+season+stage+Goal_Diff_Home_10.Games+Goal_Diff_away_10.Games+
          buildUpPlaySpeed_home+buildUpPlaySpeedClass_home+
          buildUpPlayDribblingClass_home+buildUpPlayPassing_home+buildUpPlayPassingClass_home+
          buildUpPlayPositioningClass_home+chanceCreationPassing_home+chanceCreationPassingClass_home+
          chanceCreationCrossing_home+chanceCreationCrossingClass_home+chanceCreationShooting_home+
          chanceCreationShootingClass_home+chanceCreationPositioningClass_home+defencePressure_home+
          defencePressureClass_home+defenceAggression_home+defenceAggressionClass_home+
          defenceTeamWidth_home+defenceTeamWidthClass_home+defenceDefenderLineClass_home+
          buildUpPlaySpeed1_away+buildUpPlaySpeedClass1_away+
          buildUpPlayDribblingClass1_away+buildUpPlayPassing1_away+buildUpPlayPassingClass1_away+
          buildUpPlayPositioningClass1_away+chanceCreationPassing1_away+chanceCreationPassingClass1_away+
          chanceCreationCrossing1_away+chanceCreationCrossingClass1_away+chanceCreationShooting1_away+
          chanceCreationShootingClass1_away+chanceCreationPositioningClass1_away+defencePressure1_away+
          defencePressureClass1_away+defenceAggression1_away+defenceAggressionClass1_away+
          defenceTeamWidth1_away+defenceTeamWidthClass1_away+defenceDefenderLineClass1_away, data=train)

Testmulti <- mean(predict(model, test[,1:45]) == test$outcome)

###    save the TE values for all models in all $B=100$ loops
B= 50;            ### number of loops
TEALL = NULL;      ### Final TE values
n = dim(soccer_epl_nonan)[1]
n1 = round(n/10)

## everything

for (b in 1:B){
  ### randomly select 25 observations as testing data in each loop
  flag <- sort(sample(1:n, n1));
  train <- soccer_epl_nonan[-flag,];
  test  <- soccer_epl_nonan[flag,];
  logit_model <- multinom(win ~ country_id+season+stage+Goal_Diff_Home_10.Games+Goal_Diff_away_10.Games+
                     B365H+B365D+B365A+WHH+WHD+WHA+VCH+VCD+VCA+
                     buildUpPlaySpeed_home+buildUpPlaySpeedClass_home+
                     buildUpPlayDribblingClass_home+buildUpPlayPassing_home+buildUpPlayPassingClass_home+
                     buildUpPlayPositioningClass_home+chanceCreationPassing_home+chanceCreationPassingClass_home+
                     chanceCreationCrossing_home+chanceCreationCrossingClass_home+chanceCreationShooting_home+
                     chanceCreationShootingClass_home+chanceCreationPositioningClass_home+defencePressure_home+
                     defencePressureClass_home+defenceAggression_home+defenceAggressionClass_home+
                     defenceTeamWidth_home+defenceTeamWidthClass_home+defenceDefenderLineClass_home+
                     buildUpPlaySpeed1_away+buildUpPlaySpeedClass1_away+
                     buildUpPlayDribblingClass1_away+buildUpPlayPassing1_away+buildUpPlayPassingClass1_away+
                     buildUpPlayPositioningClass1_away+chanceCreationPassing1_away+chanceCreationPassingClass1_away+
                     chanceCreationCrossing1_away+chanceCreationCrossingClass1_away+chanceCreationShooting1_away+
                     chanceCreationShootingClass1_away+chanceCreationPositioningClass1_away+defencePressure1_away+
                     defencePressureClass1_away+defenceAggression1_away+defenceAggressionClass1_away+
                     defenceTeamWidth1_away+defenceTeamWidthClass1_away+defenceDefenderLineClass1_away, data=train)
  multi_model <- multinom(outcome ~ country_id+season+stage+Goal_Diff_Home_10.Games+Goal_Diff_away_10.Games+
                      B365H+B365D+B365A+WHH+WHD+WHA+VCH+VCD+VCA+
                      buildUpPlaySpeed_home+buildUpPlaySpeedClass_home+
                      buildUpPlayDribblingClass_home+buildUpPlayPassing_home+buildUpPlayPassingClass_home+
                      buildUpPlayPositioningClass_home+chanceCreationPassing_home+chanceCreationPassingClass_home+
                      chanceCreationCrossing_home+chanceCreationCrossingClass_home+chanceCreationShooting_home+
                      chanceCreationShootingClass_home+chanceCreationPositioningClass_home+defencePressure_home+
                      defencePressureClass_home+defenceAggression_home+defenceAggressionClass_home+
                      defenceTeamWidth_home+defenceTeamWidthClass_home+defenceDefenderLineClass_home+
                      buildUpPlaySpeed1_away+buildUpPlaySpeedClass1_away+
                      buildUpPlayDribblingClass1_away+buildUpPlayPassing1_away+buildUpPlayPassingClass1_away+
                      buildUpPlayPositioningClass1_away+chanceCreationPassing1_away+chanceCreationPassingClass1_away+
                      chanceCreationCrossing1_away+chanceCreationCrossingClass1_away+chanceCreationShooting1_away+
                      chanceCreationShootingClass1_away+chanceCreationPositioningClass1_away+defencePressure1_away+
                      defencePressureClass1_away+defenceAggression1_away+defenceAggressionClass1_away+
                      defenceTeamWidth1_away+defenceTeamWidthClass1_away+defenceDefenderLineClass1_away, data=train)
  xtrain <- train[c(4:15,18,21,23,25,28,30,32,35,38,41,43,45,48,50,52,59)]
  xtest <- test[c(4:15,18,21,23,25,28,30,32,35,38,41,43,45,48,50,52,59)]
  ytrain <- as.factor(train$win)
  ytest <- as.factor(test$win)
  svm_model_win <- svm(xtrain, ytrain, gamma = 0.1, kernel = 'radial') 
  ytrain2 <- as.factor(train$outcome)
  ytest2 <- as.factor(test$outcome)
  svm_model_outcome <- svm(xtrain, ytrain2, gamma = 0.1, kernel = 'radial') 
  
  Test_svm_win <- mean(predict(svm_model_win, xtest) == ytest)
  Test_svm_outcome <- mean(predict(svm_model_outcome, xtest) == ytest2)
  
  Testmulti <- mean(predict(multi_model, test[,1:54]) == test$outcome)
  predict_wins <- predict(logit_model,test[,1:54], type="probs")
  win_thresh <- quantile(predict_wins, perc)
  predict_wins <- ifelse(predict_wins > win_thresh,1,0)
  Testwins <- mean(predict_wins == test$win)
  TEALL = rbind(TEALL, cbind(Test_svm, Test_svm_outcome, Testmulti, Testwins))
}
# decision boundary for wins
summary(soccer_nobet$win)
perc = 8835/(10515+8835) #~0.2899225
win_thresh <- quantile(predict(wins,test[,1:45], type="response"), perc)

# determining decision boundary for loss
summary(soccer_nobet$lose)
perc = 5610/(5610+13740) #~0.2899225
loss_thresh <- quantile(predict(loss,test[,1:45], type="response"), perc)

# decision boundary for ties
summary(soccer_nobet$tie)
perc = 4905/(4905+14445) #~0.253
tie_thresh <- quantile(predict(tie,test[,1:45], type="response"), perc)

### df of home team api id, win, predicted win
