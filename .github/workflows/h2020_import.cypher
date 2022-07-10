// clear data // TODO: delete WHEN data is modelled AND first batch is uploaded
MATCH (n) DETACH DELETE n; // load organization nodes LOAD CSV
WITH HEADERS FROM 'file:///h2020_projects_out_date_formatted_latest.csv' AS row MERGE (p:EuProject { id: row.id, acronym: row.acronym, title: row.title, objective: row.objective, topics: row.topics, startDate: row.startDate, endDate: row.endDate, frameworkProgramme: row.frameworkProgramme, legalBasis: row.legalBasis, totalCost: row.totalCost, ecMaxContribution: row.ecMaxContribution, masterCall: row.masterCall, subCall: row.subCall, contentUpdateDate: row.contentUpdateDate, })
RETURN count(p); // // load organization nodes // LOAD CSV
WITH HEADERS FROM 'file:///h2020_projects_out_date_formatted_latest.csv' AS row // MERGE (o:Organization {name: "String", abbreviation: "String", country: "String"}) //
RETURN count(e); // // load Company nodes // LOAD CSV
WITH HEADERS FROM 'file:///h2020_projects_out_date_formatted_latest.csv' AS row //
WITH row
WHERE row.Id IS NOT null //
WITH row, // ( CASE row.BusinessType // WHEN 'P' THEN 'Public' // WHEN 'R' THEN 'Private' // WHEN 'G' THEN 'Government' // ELSE 'Other' END) AS type // MERGE (c:Company {companyId: row.Id, hqLocation: coalesce(row.Location, "Unknown")}) // SET c.emailAddress = CASE trim(row.Email) WHEN "" THEN null ELSE row.Email END // SET c.businessType = type //
RETURN count(c); // create relationships LOAD CSV
WITH HEADERS FROM 'file:///h2020_projects_out_date_formatted_latest.csv' AS row
MATCH (e:Employee {employeeId: row.employeeId})
MATCH (c:Company {companyId: row.Company}) MERGE (e)-[:WORKS_FOR]->(c)
RETURN *;