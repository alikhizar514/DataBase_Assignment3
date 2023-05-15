#Group Assignment
#Overview

This is a group assignment with two students in a group based on the UEFA Champions League (UCL) case study. UCL is one of the biggest football competitions conducted by the Union of European Football Association. The dataset provided for this assignment contains information about UCL matches from 2016-2022. The goal of this assignment is to design SQL schema for the given dataset, identify the functional dependencies, apply normalization, load the data into the created tables, and write SQL queries to retrieve information from the tables.

Case Study
UEFA Champions League (UCL) is one of the most viewed and anticipated football tournaments in the world. The assignment requires you to complete the following parts:

Part #1 - Design (50 Marks)
Design SQL Schema for the given dataset. Identify the Entities/Tables and corresponding columns, constraints, and primary keys. Also, identify the relationships between different Entities and map them through foreign keys correctly.
Identify the functional dependencies in each table and classify them as a full functional or partial functional dependency.
Identify the current normal form of each table using conditions studied in class and apply normalization to remove bad relations (if required). If you think, normalization is not required, justify it.
Part #2 - Insertion (20 Marks)
Download the provided dataset and load it into the created tables. You can use any utility for this purpose. Using individual insert queries for each row is not allowed (and possible) for the given dataset. Learn Data Loading from Excel sheet into SQL server by yourself. It is very easy to learn and use. You have to understand the type of data in a column while designing the schema. You can assume empty cells as NULL.

Part #3 - Queries (150 Marks)
Write SQL Queries to retrieve the following information:

EASY [5*5=25]
All the players that have played under a specific manager.
All the matches that have been played in a specific country.
All the teams that have won more than 3 matches in their home stadium. (Assume a team wins only if they scored more goals then other team)
All the teams with foreign managers.
All the matches that were played in stadiums with seating capacity greater than 60,000.
MEDIUM [5*10=50]
All Goals made without an assist in 2020 by players having height greater than 180 cm.
All Russian teams with win percentage less than 50% in home matches.
All Stadiums that have hosted more than 6 matches with host team having a win percentage less than 50%.
The season with the greatest number of left-foot goals.
The country with maximum number of players with at least one goal.
HARD [5*15=75]
All the stadiums with greater number of left-footed shots than right-footed shots.
All matches that were played in country with maximum cumulative stadium seating capacity order by recent first.
The player duo with the greatest number of goal-assist combination (i.e. pair of players that have assisted each other in more goals than any other duo).
The team having players with more header goal percentage than any other team in 2020.
The most successful manager of UCL (2016-2022).
BONUS [10]
The winner teams for each season of UCL (2016-2022).
Note: You have to retrieve complete information for each query. For example, when retrieving players that satisfy a specific criterion, you need to retrieve their first name, last name, DOB, and nationality. Only ID won’t be sufficient. The Same work for different values than those specified in the above queries. This will be
strictly evaluated during demos. The bonus will only be adjusted in this
assignment and won’t be carried forward to any other assessment item.
