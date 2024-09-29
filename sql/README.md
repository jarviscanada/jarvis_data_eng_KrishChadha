# Introduction

This project involves setting up and managing a PostgreSQL database as part of the Jarvis Linux Cluster Administration team.


# SQL Queries

###### Table Setup (DDL)

```sql
CREATE TABLE cd.members (
    memid SERIAL PRIMARY KEY,
    surname VARCHAR(200),
    firstname VARCHAR(200),
    address VARCHAR(300),
    zipcode INTEGER,
    telephone VARCHAR(20),
    recommendedby INTEGER,
    joindate TIMESTAMP
);

CREATE TABLE cd.facilities (
    facid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    membercost NUMERIC,
    guestcost NUMERIC,
    initialoutlay NUMERIC,
    monthlymaintenance NUMERIC
);

CREATE TABLE cd.bookings (
    bookid SERIAL PRIMARY KEY,
    facid INTEGER REFERENCES cd.facilities(facid),
    memid INTEGER REFERENCES cd.members(memid),
    starttime TIMESTAMP,
    slots INTEGER
);

