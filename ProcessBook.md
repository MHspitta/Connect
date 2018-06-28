
Process book Connect – Michael Hu

Day 1: 
Proposal + basic sketches. Swipe function, activity, search for activities and profile function.
Link the swipe-function  with activities?

Day 2:
Design document is finished. ViewControllers are named and the first prototypes of the structs are done. 
API research done, but difficult to get the correct request, because there are only like 100 available activities. So I decided with help of Emma to use the swipe function to swipe for interesting activities and remove the search function of activities, because there are not that many suggestions yet when you for example search for activiteiten sort “actief” you will only get 2 hits.  So it’s nicer to swipe trough all the activities and when you like an activity it will come into your “liked activities list” where you can confirm participating.

After participating you (can) ‘will automatically’ connect with other participants and become friends. 

Further I will begin with making the prototype in Xcode.

Day 3:
Today I started with the prototype and I almost finished the prototype of the front end. I decided not to make the app tiltable because the swipe function is not possible in horizontal mode. 
The swipefunction with animations are finished and the login and signup screen is also done. 
Also I changed the ActivitiesTableViewController to a normale UIViewcontroller with a TableView inside, for the looks and the create new activity button. 

Day 4 (11 – 06 – 2018):
I finished the front end of my app for now. I want to implement a scroll view but I haven’t done that yet, because I wanted to connect my app with firebase first. That’s done and Users can now create new accounts with their e-mail and log in. 
I made the design better after watching several videos about how to create a good design for an application. Without too much distraction but also not too boring.

Day 5 (12-06-2018): 
Today I realized I didn’t made the detailed view of the Activities yet, so I finished the front end of that view controller. Further I implemented error messages in the login en signup viewcontroller which are completely finished right now. Users will login if passwords matches with accounts. 
I also connected the CreateActivityViewController with firebase. When users are logged in they can create activities which are being send to Firebase. 
Users can choose from categories trough a PickerView and I had some problems with uploading the date input from users via UIDatePicker. I had to change the format from date to String.  So for now my CreateActivityViewcontroller is also finished. If I have time I want to also give the users the possibity to upload images and I want a scroll view to fit more things on the ViewController. 

Day 6 (13 juni 2018) :
I updated my CreateActivityViewcontroller to a scroll view because I needed to get more info from users. Further I managed to retrieve the activities from Firebase to my application and present the titles in the ActivityTabelViewcontroller and when you click on it you will be directed to the ActivityDetailViewcontroller with the full information of the activity.

Day 7 (14 juni 2018)
Today I managed to implement the imagepicker to let users pick a profile image for their profile. I also fixed some bugs with the keyboard and navigation bars. I added a navigation controller to the ActivitiesTableViewController.
Also there was a bug with the swipe function with resetting the animation that’s also fixed

Day 8 (18 juni 2018)
Problems with saving the image to Firebase, because the metadata option is updated in the new podfile… I almost finished the back end of the profile tab and the Edit profile page. Users can now complete their profile with names phonumbers etc, but I need to fix the imageuploading for total completion. 
I tried to finish the swipe viewcontroller, but I had the problem that I couldn’t save all the data from my snapshot from firebase into a variable. Everytime the variable is nil… I m not using a tableview so I don’t know how to fix it. 
Further I have problems with the firebase structure of my data, because users have to be able to swipe all acitivties. And the way I was uploading (creating) to my database before with every activity linked to the UID of the user , it was not possible to retrieve these activities to everybody because of the UID. So I have to think about a way to add all the activities to a place where all users have access to the activities, but also somehow link the acitivity to the creator …. 

Day 9 (19 juni 2018)
Today I made lots of progress, I managed to almost finish the ConnectViewController. The class now fetches all activities created by users and users can swipe for each activity. The only thing is missing is that when a user likes an activity that that data is being pushed to firebase. 
Also I changed my firebase datastructure because first I was using UID as childs but then it’s difficult to get all the data for all users available.
Further I decided after asking Marijn to make my friends tab controller easier by just showing all users of my app in stead of connect the users when they both participate on the same activity. 
The back end of the FriendsViewcontroller and firendsDetailedViewcontroller is done. I also managed to let users upload profilepics to firebase. Now I only need to find a way to retrieve the image back to my app. Recently there has been an update so it changed a bit. You can’t download the URL link anymore like before , but that s not a big problem I think because I use the UID as profile image name so I can easily make the path myself. ” (my personal bucket storage link) + \(uid) . jpg “. 
I also fixed some minor bugs like a good exit when you log out. And I added some more information to the ActivityDetailViewController. Users can now see the name of the organisor of the activity and his/her phonenumber. It was a little bit more difficult to get these information because this information was kept in another child (“Users”) instead of (“Acitivities”).

Day 10 (20 juni 2018)
Today I finished the imageviewpickr. Users can upload a profileimage and other users can see the picture as well in the friendsDetailViewController.
I also fixed some minor bugs, but my main issue was finishing the Swipe function and that’s still not done. I had some bugs in with when I was swiping the card, but that is fixed and I also can track save the data to firebase when a user likes an activity, but retrieving the data back to my application seems very difficult. 
I made a child at the parent “Users” and “Activities” So when a user likes an activity it will be tracked at 2 locations on firebase. I then save the uid at “Activities” and I save the activityID at “Users”. I managed to get to these ID’s, but I want to retrieve the whole data with these ID’s and Firebase or swift seems to have a lot of difficulties with this. Because it’s not correctly filling my list of activities and it just keeps on filling with a lot of duplicates as results. 
Also I wanted to fill 2 sections of my tableview in my ActivityViewController, so I think I have to make a multidimensional array. That doesn’t want to succeed yet also because I am not retrieving my participatingActivities correctly yet. 
Maybe I’m going to add another parent to my Firebase and also another viewcontroller if the multidimensional array wouldn’t succeed. 

All by all a lot of new struggles.

Day 11 (21 juni 2018) 
I fixed the problem from yesterday. I forgot to empty the variable so it was keep adding data to it and that was the problem of so many duplicates.
Further I finished the ConnectViewController, I added images which will change according to the category of each activity. And I made the random activity picker better, by removing the activity locally when it’s swiped, so you will not get that often the same actvitiy again. I still can improve the algorithm, but for now I want to focus first on the bug of my section headers. I use a multidimensional array for the 2 sections of my tableview, but somehow the sections keep adding up after every swipe (change in database) . I think I forget to clean the multidimensional array , but I can’t find where yet.  All the functions are done and I’m ready to fix all the bugs and improve my layout. I’m thinking of custom buttons, tableviews, views and more. I will also look into the design formats for the iPhone X because I have one my self. 

All by all Im very happy about my app.

(26 Juni 2018)
Today I m going to fix all my bugs. One bug that was really giving me headache was the fact that somehow in my ActivitiesTableViewController my multidimensional array kept getting bigger when I liked an activity and and reloaded my TableView. And this resulted in a section error. 
I used several print functions to fix this problem and I found out that the fetchActivitiyId function triggerd more often than the fetchActivities function which resulted in that the fetchPartActivities function was also called more often than fetchActivities, because I call fetchPartActivities everytime at the end of fetchActivityId. But because is only set my allActivities multi d array to [] in fetchActivities, my array kept growing everytime. So my solution was to directly after I append activities in FetchActivities to also append a empty array [], and set this allActivities[1] = [] everytime when I was going to set new values for partActivities. So in this way it wasn’t becoming bigger but just rewriting the information.

Also I fixed the friendsDetailviewcontroller from bugs. It was first not showing the friendsParticipating activities and when I thought I fixed it.. it was crashing because finding nil when unwrapping optional value. 
This is because I forgot to call ref= Databas… in viewDidLoad() 
I have had this problem earlier before. 

So I almost fixed all my bugs and I only need to fix the delete function IF I am going to do that… 
But I learned how to create my own buttons today with Sketch. I have seen several master tutorials and I am proud that I succeeded. As well I changed the profile images to a complete round format, which already makes my design much user friendly in my opinion. 
I did try to change my textfields as well, with a custom textfield from online that I downloaded via terminal with pod install, but my app doesn’t want to autocomplete after I use that class of the custom textfield. So eventually I just customized the textfields myself.
And also made an Icon Logo for the app, I had to make several formats, but its done.
At last I added some shadows to my swipe function which makes this even more sleek.

Tomorrow I want to have look at the proper design format for apps. And try to improve the quality even more.

27 juni 2018
Today I improved my layout even more and made tab bar icons in Sketch for my app. The icons have to be dark coloured or not blue, otherwise they will not be displayed correctly I found out.  Further I fixed some more bugs, like popping up error messages when users haven’t provided all the information that is needed. 
Tomorrow Im going to give my app the finishing touch and write the report.

28 juni 2018
Today I finished the layout of my ActivityDetailViewController by using some custom frames and lines which I made in Sketch. Also I cleaned up my code and decided to remove the delete function because I have to check to much in my database if I keep this function. 
After I thought I finished the app I again tried all functions and possible bugs. I found several new small bugs which I corrected all and erverything is working like it should. 
Tomorrow I will make a demo video of the app and prepare the presentation for the afternoon. Suddenly I have to present my project, even I didn't nominate myself... but Im happy to now
