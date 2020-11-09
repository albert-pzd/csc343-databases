SELECT m."Name" MonitorName, p.AvgBookingFee, m."Email"  
  FROM "Monitor" m,
  (SELECT "MonitorId", SUM("Price")/COUNT("MonitorId") AvgBookingFee FROM "Privilege" GROUP BY "MonitorId") p
WHERE m."Id" = p."MonitorId"
AND m."Id" IN (
	SELECT p."MonitorId"
	  FROM "Privilege" p, 
	  (SELECT pi."MonitorId", SUM(mr."Rate")/COUNT(pi."MonitorId") MonitorAvgRate 
		FROM "MonitorRate" mr, "Book" b, "Privilege" pi
		WHERE mr."BookId" = b."Id"
		AND b."PrivilegeId" = pi."Id"  
		GROUP BY pi."MonitorId") mr,
	  (SELECT "SiteId", SUM("Rate")/COUNT("SiteId") SiteAvgRate 
		FROM "SiteRate" GROUP BY "SiteId") sr
	  WHERE p."MonitorId" = mr."MonitorId"
	  AND p."SiteId" = sr."SiteId"
	  AND mr.MonitorAvgRate > sr.SiteAvgRate
);