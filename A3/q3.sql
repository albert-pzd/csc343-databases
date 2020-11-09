SELECT s."Name" DiveSite, SUM(p."Fee")/COUNT(s."Name") AvgFeePerDive
    FROM "Site" s, "Provide" p
    WHERE s."Id" = p."SiteId"
    GROUP BY s."Name";