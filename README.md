##datacleansingproject
====================

###Repo for the Data Cleansing Course Project

###The script run_analysis.R reads the train and test data from the files x_train.txt and and x_test.txt respectively and outputs two data files;

###1)	tidy_all_data.txt – contains the merged, tidy data from both files.  
###2)	tidy_avg.data.txt – contains the averages each variable for each activity and each subject from the merged data.

###The second file is the one required for the project.

###The content of both files is described in details in codebook.md.

###The script reads performs the following steps and data transformation in order to create the output files.  Note that the order of the statements in the script doesn’t necessarily reflect exactly the same order of the steps listed:

1)	Reads the content of the file feature.txt to obtain the column names for the data files.  It uses the names to determine which columns to extract from the data files.  Per the project instructions, the script will only extract only the measurements on the mean and standard deviation for each measurement.

2)	Reads the content of the file activity_labels.txt.  This content will be merged with the train and test data sets in order to include the activity label in the resulting tidy files.

3)	Reads the content of the files subject_train.txt and subject_test.txt to get the subject IDs.  The content of these files will be merged with the x_train and x_test data sets respectively in order to include the subject ID in the resulting tidy files.

4)	Reads the content of the files y_train.txt and y_test.txt to get the activities performed.  The content of these files will be merged with the x_train and x_test data sets respectively in order to include the activity performed by the subjects in the resulting tidy files.

5)	Reads the data from both x_train.txt and and x_test.txt.  Only the columns corresponding to the measurements on the mean and standard deviation are extracted.  The rest are excluded.

6)	Since the order and number of records in the subject_train, y_train and x_train data sets match, the script adds a sequence number to each data set so that the data sets can be merged using the that sequence number.  It also does the same for the data sets subject_test, y_test  and x_test.

7)	Merges the subject_train and y_train data sets into x_train by sequence number.

8)	Merges the subject_test  and y_test into x_test by sequence number.

9)	Merges the activity_labels data set into x_train by activity_code.

10)	Merges the activity_labels data set into x_test by activity_code.

11)	Merges the x_train and x_test databases into a new data set (x_alldata).

12)	Creates a new dataset that only contains the average of each variable for each activity and each subject (x_alldata2).

13)	Writes the data from x_alldata and x_alldata2 to the text files tidy_all_data.txt and tidy_avg.data.txt respectively.
