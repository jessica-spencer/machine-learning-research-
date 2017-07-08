
# Scene Classification
### Research done by Jessica Spencer, advised by Professor Ozgur Izmirli at Connecticut ### College, Fall 2016 - Spring 2017

## Why?
Scene classification in images is an important machine learning problem in many fields, including archiving, museum work, and social media tagging.  Scene classification can be used to target advertisements in social media, to pre-tag images, and to learn more about a company’s audience. This research was an attempt to create a scene classifier without relying on object detection (as many do). I used a single data set for all me research which I acquired from [Image and Visual Representation Lab](http://ivrl.epfl.ch/supplementary_material/cvpr11/). 

## How does it do??
This classifier performs with 78.6% accuracy, with 10-fold cross validation. Woo!

## Required Ingredients
In order to properly run this code you need the **Matlab Machine Learning Toolbox**, which costs some money (or you can do a 30 day free trial). It also requires you upload the database from [here](http://ivrl.epfl.ch/supplementary_material/cvpr11/) to a folder called **allPhotos**.  Pro-tip: the categories of ‘old building’ and ‘field’ are fuzzy, so results will be different if they are included.

## How do I run this?
After you *run framework.m*, go to Apps in the toolbar of matlab, and *open Classification Learner*. Click the yellow + that says 'New Session' and select 'T' as your variable.  Train on All SVMs.  You can then select your method of looking at the results, I find the confusion matrix to be the best visualization.