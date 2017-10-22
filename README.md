# ProjectHub

## Project Proposal 

#### Name of Web App: 
> ProjectHub

#### How is this problem solved currently, if at all?

> Currently there are web applications such as Wiggio, Asana, and Trello that are used to help manage groups and group activities. However, these existing apps lack a separate teacher/supervisor account types. Also, these existing apps lack the functionality of allowing team members to assign points to their tasks depending on the difficulty of the task. Assigning points allows members and the teacher/supervisor to keep track of how much work each person has done.

#### How will this project make life easier?

> This app will make tracking group projects, assigning tasks and communicating within the group much easier. Also, the ability for a teacher or supervisor to see how a project is progressing allows them to make suggestions and evaluate each member’s contributions. 

#### Who is the target audience? Who will use your product?
	
> Our target audience is mainly students and colleagues (and their teachers or supervisors) who are working on group-based projects.

<br/> <br/>
### USER STORIES

### Login (2 different types of user accounts)
#### 2 types of users accounts:
* Instructor/Supervisor
  * Can sign in and view the groups and make comments under the tasks.
  * Can create a token for the class they are in charge of and get all the groups to add that token into their group so the instructor can have access to those groups
* Regular user
  * Regular user can sign in and they can :
create groups (they become group admin of the group they create)
  * Use all the features inside the Group Project View (see below)
  * Change their profile (display name, profile pic)
  * Change their settings (notification, password, email)


### Individual Features:

#### Regular user dashboard: 
* Can create groups
* Can go to groups that they are in

#### Instructor/supervisor dashboard:
* Can create course 
* Can view groups belonging to people they’re supervising, but the only thing they can do inside a group is comment (in different colour)
* Can set limit on number of people in a group 

#### Group project view: 
* Everyone can leave comments underneath each member’s tasks 
* Can create tasks
* Polling system for each task where members vote on the number of points the task is worth
* When a member’s task has been completed, other members in the group can make comments on their task and give it a thumbs up to show that the task has been reviewed and has been properly completed
* Project graph/timeline that shows each member’s task completion (i.e. points earned per day), and maybe ability to view graphs for individual members
* A group calendar that lists all the deadlines & events 
* Sidebar/news feed showing latest events/activities in that project
  * i.e. Gurjovan created a task <Task Name> 2 minutes ago 
  * i.e. Derek was assigned a task <Task Name> 10 minutes ago 
  * i.e. Sina joined the group 1 minute ago 
  * i.e. Raiya just commented on <Task Name> a few seconds ago 
  * i.e. Shuman just gave a thumbs up on completed task <Task Name> 1 day ago

#### Group admin(s) features: 
* Can add group members and remove group members 
* Can appoint other members as admins 

