running_platform<-"guicluster"
running_platform<-"computecluster"
running_bigdata_computation<-FALSE
running_bigdata_computation<-TRUE

source_sharedfuncs_r_path<-try(here::here())
if(is(source_sharedfuncs_r_path, 'try-error')) source_sharedfuncs_r_path<-"."
source(file = paste0(source_sharedfuncs_r_path,"/13_merge_all_datasets.R"), encoding="UTF-8")

# plotting for responsive data --------------------------------

#des <- overalldf_to_implist_func(overall_nonagenda_df, usinglib="survey") %>%
#  survey::svydesign(ids=~1, weight=~myown_wr, data=.)

if (FALSE) {
  load(file=paste0(save_dataset_in_scriptsfile_directory, "ordinallogisticmodelonrespondopinion_des.RData"), verbose=TRUE)
  load(file=paste0(save_dataset_in_scriptsfile_directory, "survey_summary_statistics.RData"), verbose=TRUE)
  allmodelvars<-c(modelvars_ex_conti,modelvars_ex_catg,modelvars_latentrelated,modelvars_clustervars,modelvars_controllclustervars,"respondopinion")
  allmodelvars_catg<-c(modelvars_ex_catg,modelvars_clustervars,modelvars_controllclustervars,"respondopinion")
  allmodelvars_catg_formula<-paste0(allmodelvars_catg,collapse="+") %>%
    paste0("~",.) %>% as.formula()
  allmodelvars_numeric<-c(modelvars_ex_conti,modelvars_latentrelated)
  allmodelvars_numeric_formula<-paste0(allmodelvars_numeric,collapse="+") %>%
    paste0("~",.) %>% as.formula()
  res.survey_summary_statistics<-list()
  #categorical var
  res.survey_summary_statistics[["catgvars_mean"]]<-survey:::with.svyimputationList(des,survey::svymean(allmodelvars_catg_formula),multicore=TRUE)
  res.survey_summary_statistics[["catgvars_total"]]<-survey:::with.svyimputationList(des,survey::svytotal(allmodelvars_catg_formula),multicore=TRUE)
  #conti var
  res.survey_summary_statistics[["contivars_mean"]]<-survey:::with.svyimputationList(des,survey::svymean(allmodelvars_numeric_formula),multicore=TRUE)
  res.survey_summary_statistics[["contivars_quantile"]]<-survey:::with.svyimputationList(des,survey::svyquantile(allmodelvars_numeric_formula, quantiles=c(.25,.5,.75), ci=TRUE),multicore=TRUE)
  save(res.survey_summary_statistics, file=paste0(save_dataset_in_scriptsfile_directory, "survey_summary_statistics.RData"))
  
}


if (FALSE) {
  plotvars<-base::setdiff(
    names(overall_nonagenda_df), 
    c("myown_wr","billid_myown","days_diff_survey_bill","id_wth_survey")
  )
  for (plotvar in plotvars) {
    message(plotvar)
    n_bins<-if(plotvar %in% c("party_pressure_overallscaled","seniority_overallscaled")) 80 else ""
    n_bins<-if(plotvar %in% c("myown_age_overallscaled")) 80 else ""
    for (weightvar in c("myown_wr","")) {
      filename_prefix<-if(weightvar=="") paste0(plotvar,"_before_wr") else plotvar
      resplot<-custom_plot(overall_nonagenda_df, fvar=plotvar, weightvar=weightvar, fillvar="respondopinion", n_bins=n_bins)
      targetsavefilename<-here::here(paste0("plot/responsiveness/",filename_prefix,".png"))
      ggplot2::ggsave(filename=targetsavefilename, plot=resplot)
      print(resplot)
    }
  }
}

# plotting for idealpoint and participation data --------------------------------

needimps<-custom_ret_appro_kamila_clustering_parameters()
survey_with_idealpoint_name<-paste0(save_dataset_in_scriptsfile_directory, "miced_survey_2surveysonly_mirt_lca_clustering_idealpoints.RData")
load(file=survey_with_idealpoint_name, verbose=TRUE)
merged_acrossed_surveys_list<-ret_merged_for_idealpoint_and_pp_df_list(survey_data_imputed, dataset_in_scriptsfile_directory, minuspolicy=FALSE)
plotvars<-base::intersect(plotvars, names(merged_acrossed_surveys_list[[1]])) %>%
  c("policyidealpoint_cos_similarity_to_median_scaled", "policyidealpoint_eucli_distance_to_median_scaled")
#https://cran.r-project.org/web/packages/srvyr/vignettes/srvyr-vs-survey.html
#https://dcava.github.io/wpp/production_code.html

if (FALSE) {
  implist<-mitools::imputationList(merged_acrossed_surveys_list)
  des<-survey::svydesign(ids=~1,weight=~myown_wr,data=implist)
  
  custom_return_var_from_svyimp<-function (formula, design, breaks = "Sturges", include.lowest = TRUE, 
                                           right = TRUE, xlab = NULL, main = NULL, probability = TRUE, 
                                           freq = !probability, ...)  {
    mf <- stats::model.frame(
      formula,
      stats::model.frame(design),
      na.action = na.pass)
    #if (ncol(mf) > 1) 
    #  stop("Only one variable allowed.")
    variable <- mf[, 1]
    varname <- names(mf)
    return(variable)
  }
  t<-survey:::with.svyimputationList(des,custom_return_var_from_svyimp(~myown_age_overallscaled))
  t<-survey:::with.svyimputationList(des,survey::svyhist(~policyidealpoint_cos_similarity_to_median,freq=TRUE))
  t<-survey:::with.svyimputationList(des,survey::svyboxplot(myown_factoredparticip~myown_factoredses_scaled))
  plot(t)
  
}


sourcedatadf<-merged_acrossed_surveys_list[[1]]
sourcedatadf<-lapply(merged_acrossed_surveys_list, dplyr::select, -policyidealpoint_cos_similarity_to_median_ordinal) %>%
  plyr::rbind.fill()  %>%
  dplyr::mutate(policyidealpoint_cos_similarity_to_median_ordinal=cut(policyidealpoint_cos_similarity_to_median,breaks=17,right=TRUE,include.lowest=TRUE,ordered_result=TRUE))

for (plotvar in plotvars) {
  message(plotvar)
  for (fillvar in c("policyidealpoint_cos_similarity_to_median_ordinal","myown_factoredparticip_ordinal")) {
    savepath_after<-if (fillvar=="policyidealpoint_cos_similarity_to_median_ordinal") "idp/" else "pp/"
    for (usingweightvar in c("myown_wr","")) {
      if_wr_filename_suffix<-if(usingweightvar=="myown_wr") "" else "_before_wr"
      n_bins<-if(plotvar %in% c("myown_age_overallscaled")) 80 else ""
      resplot<-sourcedatadf %>%
        custom_plot(., fvar=plotvar, weightvar=usingweightvar, fillvar=fillvar, n_bins=n_bins)
      targetsavefilename<-here::here(paste0("plot/idp_pp/",savepath_after,plotvar,"_fill_",fillvar,if_wr_filename_suffix,".png"))
      message(paste("saving to",targetsavefilename))
      ggplot2::ggsave(filename=targetsavefilename, plot=resplot)
      print(resplot)
    }
  }
}

# boxplot and scatter and trend plot --------
for (plotvar in plotvars) {
  for (fillvar in c("myown_factoredparticip_overallscaled","policyidealpoint_cos_similarity_to_median")) {
    savepath_after<-if (fillvar=="myown_factoredparticip_overallscaled") "pp/" else "idp/"
    fillvar_title<-if(fillvar=="myown_factoredparticip_overallscaled") "political participation" else "ideal point(cosine similarity to L1median)"
    plotvar_title<-gsub(pattern="myown_",replacement="",plotvar)
    for (usingweightvar in c("","myown_wr")) {
      if_wr_filename_suffix<-if(usingweightvar=="myown_wr") "" else "_before_wr"
      if (usingweightvar!="") {
        df_weight<-sourcedatadf %>%
          magrittr::extract2(.,usingweightvar)
        sum_df_weight<-sum(df_weight)
        ggplotweight<-df_weight/sum_df_weight
      }
      message(paste("now in",plotvar,"and weight is",usingweightvar))
      if ("factor" %in% class(sourcedatadf[,plotvar])) {
        outputplot<-ggplot2::ggplot(sourcedatadf,ggplot2::aes(
          x=.data[[plotvar]],
          y=.data[[fillvar]],
          colour=.data[[plotvar]],
          weight={if (usingweightvar=="") 1 else ggplotweight}
        ))+#,weight=.data[[usingweightvar]]
          ggplot2::geom_boxplot(width=.5,outlier.shape = 1)+
          ggplot2::labs(title=paste("Boxplot of",fillvar_title,"by",plotvar_title))+
          ggplot2::theme(plot.title=ggplot2::element_text(hjust = 0.5,face="bold",size=11))
      } else if ("numeric" %in% class(sourcedatadf[,plotvar])) {
        outputplot<-sourcedatadf %>%
          ggplot2::ggplot(.,ggplot2::aes(
            x=.data[[plotvar]],
            y=.data[[fillvar]],
            weight={if (usingweightvar=="") 1 else ggplotweight}
          ))+
          ggplot2::geom_point()+
          ggplot2::geom_smooth()+
          ggplot2::labs(title=paste("Scatter plot of",fillvar_title,"and",plotvar_title))+
          ggplot2::theme(plot.title=ggplot2::element_text(hjust = 0.5,face="bold",size=12))
      }
      targetsavefilename<-here::here(paste0("plot/idp_pp/inf_plot_",savepath_after,"infplot_",fillvar,"_by_",plotvar,if_wr_filename_suffix,".png"))
      message(paste("saving to",targetsavefilename))
      ggplot2::ggsave(filename=targetsavefilename, plot=outputplot)
      print(outputplot)
    }
  }
}

for (needfvar in c("policyidealpoint_cos_similarity_to_median","policyidealpoint_euclid_distance_to_median")) {
  outputplot<-custom_plot(sourcedatadf, fvar=needfvar, weightvar="myown_wr")
  targetsavefilename<-here::here(paste0("plot/idealpoints/",needfvar,".png"))
  ggplot2::ggsave(filename=targetsavefilename, plot=outputplot)
  print(outputplot)
}

# plotting for different issues ----------------
df <- data.frame(y=abs(rnorm(8)),
                 x=as.factor(rep(c(0,100,200,500),times=2))) 
ggplot(aes(y=y,x=x), data=df) + 
  geom_boxplot()