/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities 
WHERE membercost > 0;

Rows: 5

name	
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court




/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT (name)
FROM Facilities 
WHERE membercost = 0 OR membercost IS NULL;

4



/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities 
WHERE membercost < monthlymaintenance * .2

Rows: 9

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT * 
FROM Facilities 
WHERE facid in (1, 5);

Rows: 2

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
5	Massage Room 2	9.9	80.0	4000	3000
1	Tennis Court 2	5.0	25.0	8000	200


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
	 ELSE 'cheap'END AS cost	
FROM Facilities;

Rows: 9


name	monthlymaintenance	cost	
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) 
                  FROM Members);

Rows: 1
firstname	surname	
Darren	Smith


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT facid, name 
FROM Facilities

facid	name	
0	Tennis Court 1
1	Tennis Court 2
2	Badminton Court
3	Table Tennis
4	Massage Room 1
5	Massage Room 2
6	Squash Court
7	Snooker Table
8	Pool Table


SELECT DISTINCT concat (m.firstname,' ', m.surname) as member, f.name 
FROM Bookings as b
INNER JOIN Facilities as f 
on b.facid = f.facid
INNER JOIN Members as m 
ON m.memid = b.memid 
WHERE f.facid IN ( 0, 1 ) 
GROUP BY member;

Rows: 27

member	name	
Anne Baker	Tennis Court 1
Burton Tracy	Tennis Court 2
Charles Owen	Tennis Court 1
Darren Smith	Tennis Court 2
David Farrell	Tennis Court 1
David Jones	Tennis Court 2
David Pinker	Tennis Court 1
Douglas Jones	Tennis Court 1
Erica Crumpet	Tennis Court 1
Florence Bader	Tennis Court 2
Gerald Butters	Tennis Court 1
GUEST GUEST	Tennis Court 2
Henrietta Rumney	Tennis Court 2
Jack Smith	Tennis Court 1
Janice Joplette	Tennis Court 1
Jemima Farrell	Tennis Court 2
Joan Coplin	Tennis Court 1
John Hunt	Tennis Court 1
Matthew Genting	Tennis Court 1
Millicent Purview	Tennis Court 2
Nancy Dare	Tennis Court 2
Ponder Stibbons	Tennis Court 2
Ramnaresh Sarwin	Tennis Court 2
Tim Boothe	Tennis Court 2
Tim Rownam	Tennis Court 2
Timothy Baker	Tennis Court 2
Tracy Smith	Tennis Court 1


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */ 



SELECT concat(m.firstname,' ', m.surname) 		
     		AS member, f.name as facility,
CASE WHEN m.memid = 0 then f.guestcost*b.slots
	ELSE f.membercost*b.slots
	END AS cost
FROM Members m                
INNER JOIN Bookings b
ON m.memid = b.memid
INNER JOIN Facilities f
ON b.facid = f.facid
WHERE b.starttime >= '2012-09-14' and b.starttime < '2012-09-15' 
	and ((m.memid = 0 and b.slots*f.guestcost > 30) 
	or (m.memid != 0 and b.slots*f.membercost > 30))
ORDER BY cost DESC;


member	facility	cost	
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Tennis Court 2	150.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 2	75.0
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	39.6
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT member, facility, cost 
FROM
( SELECT concat (m.firstname,' ', m.surname) AS member, f.name as facility,
	CASE WHEN m.memid = 0 THEN f.guestcost*b.slots
     	     ELSE f.membercost*b.slots END AS cost
	FROM Members m
	INNER JOIN Bookings b
	ON m.memid = b.memid
	INNER JOIN Facilities f
	WHERE b.starttime >= '2012-09-14' and b.starttime < '2012-09-15' ) AS bookings
	where cost > 30
ORDER BY cost DESC;

member	facility	cost	
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Tennis Court 2	150.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 2	75.0
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	39.6
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


SELECT name, revenue 
FROM( SELECT f.name, sum(CASE
      WHEN memid = 0 then slots * f.guestcost
      ELSE slots * membercost END) AS revenue
      FROM Facilities f
      INNER JOIN Bookings b
      ON f.facid= b.facid
      GROUP BY f.name) AS agg WHERE revenue < 1000
ORDER BY revenue;      

Rows: 3

('Table Tennis', 180)
('Snooker Table', 240)
('Pool Table', 270)


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT m.surname as membersur, m.firstname as memberfirst, 
	r.firstname as recfirst, r.surname as recsur
FROM Members m
LEFT OUTER JOIN Members r
ON r.memid = m.recommendedby
ORDER BY memsname, memfname;  
	
('Bader', 'Florence', 'Ponder', 'Stibbons')
('Baker', 'Anne', 'Ponder', 'Stibbons')
('Baker', 'Timothy', 'Jemima', 'Farrell')
('Boothe', 'Tim', 'Tim', 'Rownam')
('Butters', 'Gerald', 'Darren', 'Smith')
('Coplin', 'Joan', 'Timothy', 'Baker')
('Crumpet', 'Erica', 'Tracy', 'Smith')
('Dare', 'Nancy', 'Janice', 'Joplette')
('Farrell', 'David', None, None)
('Farrell', 'Jemima', None, None)
('GUEST', 'GUEST', None, None)
('Genting', 'Matthew', 'Gerald', 'Butters')
('Hunt', 'John', 'Millicent', 'Purview')
('Jones', 'David', 'Janice', 'Joplette')
('Jones', 'Douglas', 'David', 'Jones')
('Joplette', 'Janice', 'Darren', 'Smith')
('Mackenzie', 'Anna', 'Darren', 'Smith')
('Owen', 'Charles', 'Darren', 'Smith')
('Pinker', 'David', 'Jemima', 'Farrell')
('Purview', 'Millicent', 'Tracy', 'Smith')
('Rownam', 'Tim', None, None)
('Rumney', 'Henrietta', 'Matthew', 'Genting')
('Sarwin', 'Ramnaresh', 'Florence', 'Bader')
('Smith', 'Darren', None, None)
('Smith', 'Darren', None, None)
('Smith', 'Jack', 'Darren', 'Smith')
('Smith', 'Tracy', None, None)
('Stibbons', 'Ponder', 'Burton', 'Tracy')
('Tracy', 'Burton', None, None)
('Tupperware', 'Hyacinth', None, None)
('Worthington-Smyth', 'Henry', 'Tracy', 'Smith')

/* Q12: Find the facilities with their usage by member, but not guests */


SELECT b.facid, COUNT( b.memid ) AS mem_usage, f.name
FROM ( SELECT facid, memid
       FROM Bookings
       WHERE memid !=0) AS b
LEFT JOIN Facilities AS f 
ON b.facid = f.facid
GROUP BY b.facid;

Rows: 9

facid	mem_usage	name	
0	308	Tennis Court 1
1	276	Tennis Court 2
2	344	Badminton Court
3	385	Table Tennis
4	421	Massage Room 1
5	27	Massage Room 2
6	195	Squash Court
7	421	Snooker Table
8	783	Pool Table

/* Q13: Find the facilities usage by month, but not guests */

SELECT b.months, COUNT( b.memid ) AS mem_usage
FROM (SELECT MONTH( starttime ) AS months, memid
FROM Bookings
WHERE memid !=0) AS b
GROUP BY b.months;


months	mem_usage	
7	480
8	1168
9	1512
