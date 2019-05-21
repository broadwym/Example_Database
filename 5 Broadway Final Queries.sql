
-- 1. List the name of charities accepting hat donations. List pattern names, pattern sources, yarn weight, and yardage required for each hat pattern. --
SELECT CHARITY.Name AS CharityName, PATTERN.Name AS PatternName, PATTERN.Source, FiberWeight, Yardage
	FROM CHARITY
	JOIN PATTERN ON (ProductType = Type)
	WHERE PATTERN.Type = 'hat'
	Order by CharityName;


-- 2. List name of members who live in Illinois and have made more than one product. --
SELECT FName AS MemberFirstName, LName AS MemberLastName, State, COUNT(ProductID) AS NumberOfProducts
	FROM MEMBER
	JOIN MEMBER_PRODUCT USING (MemberID) 
	WHERE State = 'IL'  
	GROUP BY MemberID 
	HAVING NumberOfProducts > 1;
 
-- 3. Retrieve name of member(s) with enough yardage of Homespun yarn to knit the Prayer Shawl pattern. --

SELECT Fname as MemberFirstName, Lname as MemberLastName, MEMBER_YARN.Yardage, YARN.Name AS YarnName
	FROM MEMBER
	JOIN MEMBER_YARN USING (MemberID)
	JOIN YARN USING (YarnID)
	WHERE YARN.Name = 'Homespun' and MEMBER_YARN.Yardage >= (SELECT PATTERN.Yardage
	FROM PATTERN
	WHERE Name = 'Prayer Shawl')
	ORDER by Lname;

-- 4. List yarn names that can be used to make the pattern Stretch Knit Hat based on fiber weight. -- 
    
SELECT YARN.Name AS YarnName
	FROM YARN
    WHERE YARN.FiberWeight = (SELECT PATTERN.FiberWeight
    FROM PATTERN
    WHERE PATTERN.Name = 'Stretch Knit Hat')
    GROUP BY YARN.Name;
    
-- 5. List all clubs that also have a charity in their same state, and the members who live in those states.--

SELECT CLUB.State, CLUB.Name AS ClubName, CHARITY.Name AS CharityName, MEMBER.FName AS MemberFirstName, MEMBER.LName AS MemberLastName
	FROM CLUB
	JOIN MEMBER USING (ClubID)
	JOIN CHARITY ON (CLUB.State = CHARITY.State)
	GROUP BY MEMBER.FName, MEMBER.LName
	ORDER BY CLUB.State;   

-- 6. List total cost of products gifted between 01/01/2015 and 12/31/15. --
SELECT SUM(TotalCost)
	FROM PRODUCT
    JOIN PRODUCT_CHARITY USING (ProductID)
    WHERE DateGifted BETWEEN '2015-01-01' and '2015-12-31';
    
-- 7. One more just for fun. List all patterns and product types donated to charities located in WI, CA, and TX. --
SELECT PATTERN.Name AS PatternName, PRODUCT.Type AS ProductType, CHARITY.Name AS CharityName
	FROM PRODUCT
    JOIN PRODUCT_CHARITY USING (ProductID)
    JOIN PATTERN USING (PatternID)
    JOIN CHARITY USING (CharityID)
    WHERE CHARITY.State IN ('WI','CA','TX')
    GROUP BY PATTERN.Name;

