SELECT s."Name",
       (SELECT Max(DiveTotalPrice)
	    FROM (
	    SELECT b."Id",
	           p."SiteId",
	           p."Price" * (SELECT COUNT(*) FROM "BookGroup" WHERE "BookId" = b."Id") DiveTotalPrice      
	        FROM "Book" b, "Privilege" p	
	        WHERE b."PrivilegeId" = p."Id") bp WHERE bp."SiteId" = s."Id" GROUP BY "SiteId") HighestFee,
	(SELECT Min(DiveTotalPrice)
	    FROM (
	    SELECT b."Id",
	           p."SiteId",
	           p."Price" * (SELECT COUNT(*) FROM "BookGroup" WHERE "BookId" = b."Id") DiveTotalPrice      
	        FROM "Book" b, "Privilege" p	
	        WHERE b."PrivilegeId" = p."Id") bp WHERE bp."SiteId" = s."Id" GROUP BY "SiteId") LowestFee,
	 (SELECT Avg(DiveTotalPrice)
	    FROM (
	    SELECT b."Id",
	           p."SiteId",
	           p."Price" * (SELECT COUNT(*) FROM "BookGroup" WHERE "BookId" = b."Id") DiveTotalPrice      
	        FROM "Book" b, "Privilege" p	
	        WHERE b."PrivilegeId" = p."Id") bp WHERE bp."SiteId" = s."Id" GROUP BY "SiteId") AverageFee 
FROM "Site" s;