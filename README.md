Task Manager App

Environment Configuration:

Prerequisites:
●	Apple device
●	Xcode 15+
●	Apple ID (so that you can access Xcode)
1.	Import the project folder to Xcode or open the .xcodeproj file.
2.	Select target device and press the run button. (Device tested on: iPhone 15 Pro)
   
Credentials:
●	username: tasker
●	password: tasker123

Features:
●	Local push notifications
●	Add/Delete/Edit tasks
●	Filter/Sort tasks based on category,priority,name,dueDate and task status
●	Mark status as complete/incomplete
●	Search tasks based on task name, description or category

Tutorial:
1.	Add tasks:
Press the plus button, add a name and description, select category, priority and due date and press the save button (Note that in order to save the task you have to at least enter a name for it

2.	Edit tasks:
Press on a task, edit it and save it or delete it. In edit mode you can also set the task as complete / incomplete.

4.	Delete tasks:
You can delete tasks by entering edit mode or by long pressing the task and selecting delete

6.	Mark tasks as completed:
You can change task status by entering edit mode or by long pressing the task and selecting mark as (complete/incomplete)

8.	Filter:
Select the slider icon on top the right corner and filter or sort tasks based on your preferences

10.	Search:
Search in the search bar based on task name, description or category

12.	Notifications:
Allow notification permission at the beginning

Notes:
●	Notifications are set to be received every day at 07:00 AM, and only the notifications received are only for uncompleted tasks. Also if for some reason the app is killed and the user starts the app again after 07:00 AM meaning that it missed the daily 07:00 AM notifications you are going to receive the daily notifications 5 seconds after you login to the app

Future Improvements:
●	Changing from the native ui navigation to the Coordinator design pattern for more flexibility
●	Adding backend support for receiving notifications for tasks regardless of the state of the app
●	Changing the ui to a dashboard interface so that you can add more
functionality, i.e: tracking habits, scheduling tasks (current functionality)
●	Add export functionality
●	Add analytics regarding the frequency of task completion rate, most category used, whether the task was completed on time, habit tracking etc
![image](https://github.com/user-attachments/assets/10794491-3937-4d24-9826-f0cea91d3451)
