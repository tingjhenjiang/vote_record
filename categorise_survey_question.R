t_sessioninfo_running<-gsub("[>=()]","",gsub(" ","",sessionInfo()$running))
t_sessioninfo_running_with_cpu<-paste0(t_sessioninfo_running,benchmarkme::get_cpu()$model)
filespath<-switch(
  t_sessioninfo_running_with_cpu,
  "Windows8x64build9200Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz"="E:\\Software\\scripts\\R\\vote_record\\",
  "Windows10x64build17763Intel(R) Core(TM) i5-4210U CPU @ 1.70GHz"="E:\\Software\\scripts\\R\\vote_record\\",
  "Ubuntu18.04.1LTSIntel(R) Core(TM) i5-4210U CPU @ 1.70GHz"="/mnt/e/Software/scripts/R/vote_record/",
  "Ubuntu18.04.2LTSIntel(R) Core(TM) i5-4210U CPU @ 1.70GHz"="/mnt/e/Software/scripts/R/vote_record/",
  "Ubuntu18.04.1LTSIntel(R) Core(TM) i5-7400 CPU @ 3.00GHz"="/home/j/rscripts/vote_record/",
  "Ubuntu18.04.2LTSIntel(R) Core(TM) i5-7400 CPU @ 3.00GHz"="/home/j/rscripts/vote_record/",
  "Windows7x64build7601ServicePack1Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz"="C:\\Users\\r03a21033\\DOWNLOADS\\vote_record\\",
  "Windows7x64build7601ServicePack1Intel(R) Xeon(R) CPU E5-2660 v4 @ 2.00GHz"="C:\\Users\\r03a21033\\DOWNLOADS\\vote_record\\",
  "Windows8x64build9200Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz"="C:\\Users\\r03a21033\\Downloads\\vote_record\\",
  "Windows10x64build17134Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz"="C:\\Users\\r03a21033\\Downloads\\vote_record\\"
)
source(file = paste(filespath, "shared_functions.R", sep = ""))
origdata<-read_csv(
  custompaste0(dataset_file_directory, "surveyquestiontype.csv"),
  col_names=TRUE
)

#去除英文、數字、符號
questions<-customgsub(origdata$QUESTION,"[A-Za-z0-9]", "") %>%
    customgsub("[[:punct:][:punct:][:space:][:digit:]]", "")

#分詞
cutter = worker(bylines = T,
                stop_word=custompaste0(dataset_file_directory, "stop_word.txt"),
                user=custompaste0(dataset_file_directory, "user.dict.utf8")
                )
article_words = sapply(questions,function(x) cutter <= x) %>%
  sapply(custompaste0,collapse=" ")

q_to_class_df<-data.frame(
  "survey"=origdata$SURVEY,
  "id"=origdata$ID,
  "orig_question"=origdata$QUESTION,
  "answer"=origdata$ANSWER,
  "parsed_question"=article_words,
  "categorych"=as.factor(origdata$CATEGORY),
  "category"=origdata$CATEGORYID)
#,trainSize = 1:812,testSize = 813:1219
trainmatrix <- create_matrix(q_to_class_df$parsed_question, minWordLength=1,removeNumbers=TRUE, stemWords=FALSE, weighting=weightTfIdf)
traincontainer<-create_container(trainmatrix,q_to_class_df$category,trainSize=1:2936,virgin=FALSE)
models <- train_models(traincontainer,
                       algorithm=c("SVM","SLDA","BOOSTING","BAGGING","RF","TREE","NNET","MAXENT"),
                       method = "C-classification",
                       cross = 0, cost = 100, kernel = "radial", maxitboost = 100, 
                       maxitglm = 10^5, size = 1, maxitnnet = 1000, MaxNWts = 10000, 
                       rang = 0.1, decay = 5e-04, trace=FALSE, ntree = 200, 
                       l1_regularizer = 0, l2_regularizer = 0, use_sgd = FALSE, 
                       set_heldout = 0, verbose = FALSE)
#"GLMNET",

#GLMNET <- train_model(container,"GLMNET")
#SVM <- train_model(container,"SVM")
#MAXENT <- train_model(container,"MAXENT")
#SLDA <- train_model(container,"SLDA")
#BOOSTING <- train_model(container,"BOOSTING")
#BAGGING <- train_model(container,"BAGGING")
#RF <- train_model(container,"RF")
#NNET <- train_model(container,"NNET")
#TREE <- train_model(container,"TREE")

results <- classify_models(traincontainer, models)
analytics <- create_analytics(traincontainer, results)
#分析
summary(analytics)
create_ensembleSummary(analytics@document_summary)
#儲存模型
saveRDS(models,custompaste0(dataset_file_directory, "survey_question_classification_model.rds"))
#save(models,"D:\\OneDrive\\OnedriveDocuments\\NTU\\Work\\thesis\\可用dataset(需要2004-2016)\\survey_question_classification_model.rds")

models<-readRDS(custompaste0(dataset_file_directory, "survey_question_classification_model.rds"))

#預測
predictdata<-read_csv(
  custompaste0(dataset_file_directory, "survey_predict_questions.csv"),
  col_names=TRUE
) %>%
  as.data.frame()
predict_question <- sapply(predictdata$QUESTION,customgsub,"[A-Za-z0-9]", "") %>%
    sapply(customgsub,"[[:punct:][:punct:][:space:][:digit:]]", "")
predict_words <-sapply(predict_question,function(x) cutter <= x) %>%
  sapply(custompaste0,collapse=" ")
predict_question_length<-length(predictdata$QUESTION)
predict_q_to_class_df<-data.frame(
  "survey"=predictdata$SURVEY,
  "id"=predictdata$ID,
  "orig_question"=predictdata$QUESTION,
  "parsed_question"=as.character(predict_words),
  "answer"=predictdata$ANSWER,
  "categorych"=predictdata$CATEGORY,
  "category"=predictdata$CATEGORYID
  )
trace("create_matrix", edit=T)
#Then new window will appear with the lib code, go to line 42 and change Acronym to acronym.
predict_matrix <- create_matrix(predict_q_to_class_df$parsed_question, originalMatrix=trainmatrix, minWordLength=1,removeNumbers=TRUE, stemWords=FALSE, weighting=weightTfIdf)
predict_container<-create_container(predict_matrix,predict_q_to_class_df$category,testSize = 1:predict_question_length,virgin = TRUE)
to_predict_data<-classify_models(predict_container,models)

#建立詞庫
a = article_words
a.token <- itoken(a)
a.vocab <- create_vocabulary(a.token,
                             ngram = c(1, 1))
head(a.vocab$vocab)


#訓練
m <- dim(traindata)[1]
val <- sample(1:m, size = round(m/3), replace = FALSE, prob = rep(1/m, m))
learn <- traindata[-val,]
valid <- traindata[val,]
trainLabels <- factor(learn$CATEGORY)
kv <- round(sqrt(nrow(traindata)))
prediction <- knn(learn, valid, cl=trainLabels, k=kv)

#找接近字詞
#pmatch(), and agrep(), grep(), grepl(), amatch from stringdist
