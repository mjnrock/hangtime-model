CREATE TABLE Employee
(
    EmpId INT PRIMARY KEY IDENTITY,
    EmpName VARCHAR(100) NOT NULL,
    Position HierarchyID NOT NULL
)

INSERT INTO Employee (EmpName, Position)
VALUES ('CEO', '/'),
    ('COO', '/1/'),
    ('CIO', '/2/'),
    ('CFO', '/3/'),
    ('VP Financing', '/3/1/'),
    ('Accounts Receivable', '/3/1/1/'),
    ('Accountant 1', '/3/1/1/1/'),
    ('Accountant 2', '/3/1/1/2/'),
    ('Accountant 3', '/3/1/1/3/'),
    ('Accounts Payable', '/3/1/2/'),
    ('Accountant 4', '/3/1/2/1/'),
    ('Accountant 5', '/3/1/2/2/'),
    ('DBA', '/2/1/'),
    ('VP of Operations', '/1/1/')

--	To get "all parent nodes of a given node":

select *, position.GetAncestor(1), position.GetAncestor(1).ToString()
from employee
where position=hierarchyid::Parse('/3/1/')

--	EmpId  EmpName       Position  (No column name)  (No column name)
--	5      VP Financing  0x7AC0    0x78              /3/
--	but there will only ever be one due to the nature of hierarchies.

--	If you really want to get all immediate children nodes of a given node:

select * 
from employee 
where position.IsDescendantOf(hierarchyid::Parse('/3/1/'))=1
      and position.GetLevel()=hierarchyid::Parse('/3/1/').GetLevel()+1

--	EmpId  EmpName              Position
--	6      Accounts Receivable  0x7AD6
--	10     Accounts Payable     0x7ADA
-- EDIT

--	I see that you want all ancestor nodes. Perhaps try an approach like this:

select * 
from employee
where hierarchyid::Parse('/3/1/2/1/').IsDescendantOf(Position) = 1
--	or

select * from employee
where ( select position 
        from employee 
        where empname='Accountant 4' ).IsDescendantOf(Position) = 1
--	here is a CTE method for comparison:

with w as ( select * from employee where empname='Accountant 4'
            union all
            select e.*
            from employee e join w on(w.position.GetAncestor(1)=e.Position) )
select * from w;