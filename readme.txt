in this folder:

run the prep:

prep_asq_spreadsheet_for_merge.sps

prep_asqse_spreadsheet_for_merge.sps


the merge:

pulling_together_followup_file.sps
(with a call to getting_rid_of_year_9999_observations.sps)
(using the information in quality_checking_followup_file.sps)

adding the ASQ concerns as calculated variables
whether each one is present:

adding_concern_codes_to_followup_file.sps

putting this file alongside the file of first test results:
(caution: Philly followup data is not included yet)
/* the Philly folder is H:\prep_phillyasq */
pulling_together_later_to_first.sps

          >> then have statewide_followup_file.sav

/* run some quality checks on the data */
quality_checking_statewide_file.sps

/* make tables to add the weights */
tabulating_obs_to_create_weights.sps

/* code to add the weights */
adding_weights_to_statewide_file.sps

/* make tables with frequencies */
tabulating_freqs_weighted.sps


/* to check the values past the first follow-up */
/* what is the highest value for which anyone has a non-missing value? */
checking_higher_val_of_concerns.sps

/* putting in the value of the highest valid answer */
/* to have a non-missing value */
/* also needs to be consecutive */
checking_max_number_of_valid_values.sps

/* creating the strings of assessment results */
tabulating_status_histories_for_later_assessments.sps

/* go back into previous file to get more frequencies */
/* now using more than two results */
tabulating_freqs_weighted.sps