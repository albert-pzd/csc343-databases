SELECT c."Name" DiveCategory, 
       (SELECT COUNT(distinct "SiteId") FROM "Privilege" p WHERE p."CategoryId" = c."Id") NumberOfSites
  FROM "Category" c;