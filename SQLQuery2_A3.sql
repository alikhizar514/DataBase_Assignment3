Use A3_new;

Create Table seasons(
	s_name varchar(9) not null,
	s_season varchar(11)

	primary key(s_season)
);

Bulk insert A3_new.dbo.seasons
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Seasons.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

--Players Table
Create table players(
	p_id varchar(14) not null,
	p_fname varchar(25),
	p_lname varchar(25),
	p_nationalty varchar(25),
	p_dob Date,

	primary key(p_id)
);

Bulk insert A3_new.dbo.players
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Players.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

--Stadium Table
Create table stadium(
	stadium_id int not null,
	stadium_name varchar(50) not null,
	stadium_city varchar(50) not null,
	stadium_country varchar(50) not null,
	stadium_capacity int not null,

	primary key(stadium_id)
);
Bulk insert A3_new.dbo.stadium
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Stadiums.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

	
--Teams Table
Create table teams(
	team_id int not null,
	team_name varchar(50) not null,
	team_country varchar(50) not null,
	stadium_id int,

	foreign key (stadium_id) references stadium(stadium_id),

	primary key(team_id)
);
Bulk insert A3_new.dbo.teams
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Teams.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)
--Player's Description Table
CREATE TABLE players_desc (
    p_id VARCHAR(14) NOT NULL,
    p_team_id INT,
    jersey_no INT,
    position VARCHAR(50) NOT NULL,
    p_height INT,
    p_weight INT,
    foot CHAR(1) CHECK (foot IN ('R', 'L')),
    FOREIGN KEY (p_id) REFERENCES players (p_id),
    FOREIGN KEY (p_team_id) REFERENCES teams (team_id),
    PRIMARY KEY (p_id) 
);

Bulk insert A3_new.dbo.players_desc
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Players_Desc.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

--Managers Table
Create table managers(
	manager_id varchar(50) not null,
	manager_fname varchar(50) not null,
	manager_lname varchar(50) not null,
	manager_nationality varchar(50) not null,
	manager_dob Date not null,
	team_id int,

	foreign key (team_id) references A3_new.dbo.teams(team_id),
	primary key(manager_id)
);
Bulk insert A3_new.dbo.managers
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Managers.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

--Matches Table
Create table matches(
	match_id varchar(14) not null,
	season_year varchar(11) not null,
	m_date_time varchar(50) not null,
	home_team_id int not null,
	away_team_id int not null,
	stadium_id int not null,

	primary key(match_id),
	foreign key (season_year) references seasons(s_season),
	foreign key (home_team_id) references teams(team_id),
	foreign key (away_team_id) references teams(team_id),
	foreign key (stadium_id) references stadium(stadium_id)
);

ALTER TABLE matches
ADD datetime_column_new DATETIME;
UPDATE matches
SET datetime_column_new = TRY_CONVERT(DATETIME2, matches.m_date_time, 109)
WHERE matches.m_date_time IS NOT NULL;

Bulk insert A3_new.dbo.matches
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Matches.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

SELECT m_date_time
FROM matches
WHERE ISDATE(m_date_time) = 0


--Matches Description
Create table match_desc(		
	match_id varchar(14) not null,
	home_team_id int not null,
	away_team_id int not null,
	penalty_shootout int check (penalty_shootout in (0,1)) not null,
	attendance int not null
	
	foreign key (match_id) references matches(match_id),
--	foreign key (home_team_id) references teams(team_id),
--	foreign key (away_team_id) references teams(team_id),
	primary key(match_id)

);
Bulk insert A3_new.dbo.match_desc
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Matchs_Desc.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)

--Goals Table
Create table goals(
	goal_id varchar(14) not null,
	match_id varchar(14) not null,
	p_id varchar(14),
	duration int not null,
	assist varchar(14),
	goal_desc varchar(25) not null,

	foreign key (match_id) references matches(match_id),
	foreign key (p_id) references players(p_id),
	foreign key (assist) references players(p_id),
	primary key(goal_id)
);
Bulk insert A3_new.dbo.goals
	from 'C:\Users\Ali\Documents\DataBase_A3\csv\Goals.csv'
	with
	(
		Fieldterminator = ',',
		Rowterminator = '\n',
		firstrow = 2
	)
--Medium Part
--Q6
Select * from goals g
inner join matches m on (g.match_id = m.match_id) 
where (g.assist IS NULL) AND (
g.p_id in
(Select p.p_id from players_desc p
where (p.p_height > 180) And (p.p_id = g.p_id)))
And (m.season_year = '2020-2021');

--Q7
Select * from teams t
where (t.team_country = 'Russia')
And (t.team_id in 
(Select m.home_team_id from matches m
inner join match_desc md on m.match_id = md.match_id
where  (t.team_id = m.home_team_id) And ((md.home_team_id < md.away_team_id))
)
);

--Q8
Select * from stadium s
where (s.stadium_id in (
Select m.stadium_id  from matches m
where (	(m.match_id in (Select md.match_id from match_desc md where md.home_team_id < md.away_team_id)))
group by m.stadium_id
having count(*) > 6));

--check Q8
Select * from matches m where m.stadium_id = 1;
Select m.stadium_id from matches m where m.match_id in (Select md.match_id from match_desc md where md.home_team_id < md.away_team_id)
group by m.stadium_id
having count(*)>6;

--Q9

Select mo.season_year,count(*) As highest_number from matches mo
inner join goals glo on glo.match_id = mo.match_id 
where glo.goal_desc = 'left-footed shot'
and mo.season_year
in(
Select subq1.season_year from
(Select m.season_year,count(*) as maxcount from matches m
inner join goals g on g.match_id = m.match_id
where g.goal_desc in('left-footed shot')
group by m.season_year
)subq1 where subq1.maxcount = 
(Select  Max(maxcount)
from (
Select m.season_year,count(*) as maxcount from matches m
inner join goals g on g.match_id = m.match_id
where g.goal_desc in('left-footed shot')
group by m.season_year
) subquery1
)
)
group by mo.season_year;

--check Q9
Select * from matches m
inner join goals g on g.match_id = m.match_id
where g.goal_desc = 'left-footed shot'; --total such goals = 632
--now by season 
Select m.season_year,count(*) as maxcount from matches m
inner join goals g on g.match_id = m.match_id
where g.goal_desc = 'left-footed shot'
group by m.season_year;--102+101+115+106+95+113 = 632

--Q10
Select po.p_nationalty,count(*) mc from players po
inner join goals glo on glo.p_id = po.p_id
where po.p_nationalty
IN (
Select subq1.p_nationalty from(
Select p.p_nationalty,count(*) as maxcount from players p
inner join goals g on g.p_id = p.p_id
group by p.p_nationalty
)subq1
where subq1.maxcount =
(Select Max(maxcount)
from (
Select p.p_nationalty,count(*) as maxcount from players p
inner join goals g on g.p_id = p.p_id
group by p.p_nationalty
)subq2)
)
group by  po.p_nationalty;

--check Q10
Select p.p_nationalty,count(*) as maxcount from players p
inner join goals g on g.p_id = p.p_id
group by p.p_nationalty

Select p.p_id,count(*) from players p
inner join goals g on g.p_id = p.p_id
group by p.p_id;

--Hard Part
--Q11
Select * from stadium s
where (
Select subq1.left_footed_goals from(
Select m.stadium_id as mstd,count(*) as left_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='left-footed shot'and s.stadium_id = m.stadium_id
group by m.stadium_id
)subq1
) > 
(Select subq2.right_footed_goals from(
Select m.stadium_id as mstd,count(*) as right_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='right-footed shot' and s.stadium_id = m.stadium_id
group by m.stadium_id
)subq2);

--check Q11
Select m.stadium_id as mstd,count(*) as right_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='right-footed shot' and  m.stadium_id = 43
group by m.stadium_id

Select m.stadium_id as mstd,count(*) as left_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='left-footed shot' and  m.stadium_id = 43
group by m.stadium_id

Select m.stadium_id as mstd,count(*) as right_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='right-footed shot' and  m.stadium_id = 51
group by m.stadium_id

Select m.stadium_id as mstd,count(*) as left_footed_goals from goals g
inner join matches m on m.match_id = g.match_id
where g.goal_desc='left-footed shot' and  m.stadium_id = 51
group by m.stadium_id

--Q12
SELECT m.*
FROM matches m
INNER JOIN stadium s ON m.stadium_id = s.stadium_id
INNER JOIN (
    SELECT TOP 1 s.stadium_country, SUM(s.stadium_capacity) AS total_seating_capacity
    FROM stadium s
    GROUP BY s.stadium_country
    ORDER BY total_seating_capacity DESC
) AS maxcap ON s.stadium_country = maxcap.stadium_country
ORDER BY m.m_date_time ASc;


--Q13
--two duo pairs for this
Select distinct og.p_id ,og.assist from goals og where og.goal_id in  
(
	Select subq2.goal_id from 
	(Select g.goal_id,count(*) as maxcount from goals g 
		cross join goals gi 
		where (
		((gi.assist = g.assist) and (gi.p_id = g.p_id))
		or
		((gi.assist = g.p_id) and (gi.p_id = g.assist))
		or 
		((gi.p_id = g.assist) and (gi.assist = g.p_id))
		)group by g.goal_id
		)subq2
	where (subq2.maxcount = 
		(Select Max(maxcount) from 
		(Select g.goal_id,count(*) as maxcount from goals g 
		cross join goals gi 
		where (
		((gi.assist = g.assist) and (gi.p_id = g.p_id))
		or
		((gi.assist = g.p_id) and (gi.p_id = g.assist))
		or 
		((gi.p_id = g.assist) and (gi.assist = g.p_id))
		)group by g.goal_id
		)subq1))
);
--check Q13
SELECT top(1) p1.p_fname, p2.p_fname, subq1.maxcount 
FROM players p1 
CROSS JOIN players p2 
INNER JOIN (
    SELECT g.p_id, g.assist, COUNT(*) as maxcount 
    FROM goals g 
    GROUP BY g.p_id, g.assist 
) subq1 
ON subq1.p_id = p1.p_id AND subq1.assist = p2.p_id 
WHERE p1.p_id <> p2.p_id 
ORDER BY subq1.maxcount DESC;







--
Select * from goals g 
cross join goals gi 
where (
((gi.assist = g.assist) and (gi.p_id = g.p_id))
or
((gi.assist = g.p_id) and (gi.p_id = g.assist))
or 
((gi.p_id = g.assist) and (gi.assist = g.p_id))
)

--Q14
Select * from teams t
where t.team_id in
(
		Select subq1.team_id from
		(Select t.team_id,count(*) as maxcount from A3_new.dbo.goals g
		inner join players_desc pd on g.p_id = pd.p_id
		inner join teams t on pd.p_team_id = t.team_id  
		inner join matches m on m.match_id = g.match_id
		where g.goal_desc ='header' and m.m_date_time like '%-20%'
		group by t.team_id
		)subq1
		where subq1.maxcount =(
		Select Max(maxcount) from (
		Select t.team_id,count(*) as maxcount from A3_new.dbo.goals g
		inner join players_desc pd on g.p_id = pd.p_id
		inner join teams t on pd.p_team_id = t.team_id  
		inner join matches m on m.match_id = g.match_id
		where g.goal_desc ='header' and m.m_date_time like '%-20%'
		group by t.team_id
		)subq2
		)
);
--check Q14
Select * from matches m where m.m_date_time like '%-20%';
Select t.team_id,t.team_name ,count(*) as maxcount ,
		SUM( CASE when g.goal_desc = 'header' then 1 else 0 end) as Header_Goal
		from A3_new.dbo.goals g
		inner join players_desc pd on g.p_id = pd.p_id
		inner join teams t on pd.p_team_id = t.team_id  
		inner join matches m on t.team_id =m.home_team_id OR t.team_id = m.away_team_id
		where m.m_date_time like '_______20%'
		group by t.team_id, t.team_name
		order by maxcount desc

--Q15
Select * from managers mg
where mg.team_id in (
		Select t.team_id from teams t
		where t.team_id in 
		(
				Select  subq1.home_team_id from (
				Select m.home_team_id,count(*) as maxcount from matches m
				inner join match_desc md on md.match_id = m.match_id
				where md.home_team_id > md.away_team_id
				group by m.home_team_id
				)subq1
			where subq1.maxcount =
				(
				Select Max(maxcount)
				from
				(Select m.home_team_id,count(*) as maxcount from matches m
				inner join match_desc md on md.match_id = m.match_id
				where md.home_team_id > md.away_team_id 
				group by m.home_team_id)
				subq2
				)
		)
)
or mg.team_id in(
		Select t.team_id from teams t
		where t.team_id in 
		(
				Select  subq1.away_team_id from (
				Select m.away_team_id,count(*) as maxcount from matches m
				inner join match_desc md on md.match_id = m.match_id
				where  md.away_team_id > md.home_team_id  
				group by m.away_team_id
				)subq1
			where subq1.maxcount =
				(
				Select Max(maxcount)
				from
				(Select  m.away_team_id,count(*) as maxcount from matches m
				inner join match_desc md on md.match_id = m.match_id
				where  md.away_team_id > md.home_team_id  
				group by m.away_team_id)
				subq2
				) 
		)
);
--check Q15
Select m.home_team_id,count(*) from matches m
inner join match_desc md on md.match_id = m.match_id
where md.home_team_id > md.away_team_id 
group by m.home_team_id;
--
Select Max(maxcount)
from
(Select m.home_team_id,count(*) as maxcount from matches m
inner join match_desc md on md.match_id = m.match_id
where md.home_team_id > md.away_team_id
group by m.home_team_id)
subq2;

--Q bonus

--
Select Max(maxcount)
from
(Select m.home_team_id,count(*) as maxcount from matches m
inner join match_desc md on md.match_id = m.match_id
where md.home_team_id > md.away_team_id
group by m.home_team_id)subq

Select t.team_id,subq.season_year,count(*) as maxcount from teams t
inner join (
		SELECT 
			CASE 
				WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
				WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
			END AS team_id,
		m.season_year,m.match_id
		FROM match_desc md 
		INNER JOIN matches m ON m.match_id = md.match_id
		WHERE md.away_team_id IS NOT NULL 
			AND md.home_team_id IS NOT NULL
			AND CASE 
					WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
					WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
				END IS NOT NULL -- add this condition to exclude null team_ids
		) subq
		on t.team_id = subq.team_id 
		group by t.team_id,subq.season_year
		ORDER BY subq.season_year ASC


Select * from teams touter
where 
(SELECT  max(maxcount) as max_wins
		FROM (
			SELECT t.team_id, subq.season_year, count(*) as maxcount 
			FROM teams t
			INNER JOIN (
				SELECT 
					CASE 
						WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
						WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
					END AS team_id,
					m.season_year,m.match_id
				FROM match_desc md 
				INNER JOIN matches m ON m.match_id = md.match_id
				WHERE md.away_team_id IS NOT NULL 
					AND md.home_team_id IS NOT NULL
					AND CASE 
							WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
							WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
						END IS NOT NULL -- add this condition to exclude null team_ids
			) subq
			ON t.team_id = subq.team_id And touter.team_id = t.team_id
			GROUP BY t.team_id,subq.season_year

		) 
AS temp
GROUP BY temp.season_year
)
in 
(
			SELECT t.team_id, subq.season_year, count(*) as maxcount 
			FROM teams t
			INNER JOIN (
				SELECT 
					CASE 
						WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
						WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
					END AS team_id,
					m.season_year,m.match_id
				FROM match_desc md 
				INNER JOIN matches m ON m.match_id = md.match_id
				WHERE md.away_team_id IS NOT NULL 
					AND md.home_team_id IS NOT NULL
					AND CASE 
							WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
							WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
						END IS NOT NULL -- add this condition to exclude null team_ids
			) subq
			ON t.team_id = subq.team_id  And touter.team_id = t.team_id
			GROUP BY t.team_id,subq.season_year
		); 



SELECT t.team_id, subq.season_year, count(*) as maxcount 
FROM teams t
INNER JOIN (
    SELECT 
        CASE 
            WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
            WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
        END AS team_id,
        m.season_year, m.match_id
    FROM match_desc md 
    INNER JOIN matches m ON m.match_id = md.match_id
    WHERE md.away_team_id IS NOT NULL 
        AND md.home_team_id IS NOT NULL
        AND CASE 
                WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
                WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
            END IS NOT NULL
) subq ON t.team_id = subq.team_id
INNER JOIN (
    SELECT season_year, MAX(count(*)) AS maxcount
    FROM (
        SELECT t.team_id, subq.season_year, count(*) as maxcount 
        FROM teams t
        INNER JOIN (
            SELECT 
                CASE 
                    WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
                    WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
                END AS team_id,
                m.season_year, m.match_id
            FROM match_desc md 
            INNER JOIN matches m ON m.match_id = md.match_id
            WHERE md.away_team_id IS NOT NULL 
                AND md.home_team_id IS NOT NULL
                AND CASE 
                        WHEN md.away_team_id > md.home_team_id THEN m.away_team_id 
                        WHEN md.away_team_id < md.home_team_id THEN m.home_team_id
                    END IS NOT NULL
        ) subq ON t.team_id = subq.team_id
        GROUP BY t.team_id, subq.season_year
    ) AS temp
    GROUP BY season_year
) AS maxsubq ON subq.season_year = maxsubq.season_year AND count(*) = maxsubq.maxcount
GROUP BY t.team_id, subq.season_year
ORDER BY subq.season_year ASC;





Select * from A3_new.dbo.seasons;
Select * from A3_new.dbo.players;
Select * from A3_new.dbo.stadium;
Select * from A3_new.dbo.teams;
Select * from A3_new.dbo.players_desc;
Select * from A3_new.dbo.managers;
Select * from A3_new.dbo.matches;
Select * from A3_new.dbo.match_desc;
Select * from A3_new.dbo.goals;

Drop table if exists A3_new.dbo.goals;
Drop table if exists A3_new.dbo.match_desc;
Drop table if exists A3_new.dbo.matches; 
Drop table if exists A3_new.dbo.managers;
Drop table if exists A3_new.dbo.players_desc;
Drop table if exists A3_new.dbo.teams;
Drop table if exists A3_new.dbo.stadium;
Drop table if exists A3_new.dbo.players;
Drop table if exists A3_new.dbo.seasons;

--Easy Part
--Q1 
Select * from players p
inner join players_desc pd on p.p_id = pd.p_id
inner join managers on pd.p_team_id = managers.team_id
where managers.manager_fname = 'Stefano';

--Q2
Select * from matches m
inner join stadium s on m.stadium_id = s.stadium_id
where s.stadium_country = 'Italy';

--Q3

SELECT * FROM teams tm
WHERE EXISTS(
    SELECT *, COUNT(*) as Wins FROM matches m
    INNER JOIN teams t ON t.team_id = m.home_team_id
    INNER JOIN match_desc md ON m.match_id = md.match_id
    WHERE (md.home_team_id > md.away_team_id AND t.team_id = tm.team_id)
        OR (md.away_team_id > md.home_team_id AND t.team_id = tm.team_id)
    GROUP BY t.team_id
    HAVING COUNT(*) > 3
);

--Q4
Select * from teams t
inner join managers m on m.team_id = t.team_id
where m.manager_nationality != t.team_country;

--Q5
Select * from matches m
inner join stadium s on m.stadium_id = s.stadium_id
where s.stadium_capacity > 60000;




