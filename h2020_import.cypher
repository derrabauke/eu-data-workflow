// load organization nodes 
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_projects_out_formatted_latest.csv' AS row
WITH row WHERE row.id IS NOT NULL
MERGE (p:EuProject {id: row.id, acronym: row.acronym, title: row.title, objective: row.objective, topics: row.topics, startDate: row.startDate, endDate: row.endDate, frameworkProgramme: row.frameworkProgramme, legalBasis: row.legalBasis, totalCost: row.totalCost, ecMaxContribution: row.ecMaxContribution, masterCall: row.masterCall, subCall: row.subCall, contentUpdateDate: row.contentUpdateDate})
ON CREATE
	SET p._created = timestamp()
	SET p._updated = timestamp()
ON MATCH
	SET p._updated = timestamp()
RETURN count(p);

// load organization nodes
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_organizations_out_formatted_latest.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MERGE (o:Organization {projectID: row.projectID, name: row.name, projectAcronym: row.projectAcronym, organisationID: row.organisationID, vatNumber: row.vatNumber, shortName: row.shortName, SME: row.SME, activityType: row.activityType, street: row.street, postCode: row.postCode, city: row.city, country: row.country, nutsCode: row.nutsCode, geolocation: row.geolocation, organizationURL: row.organizationURL, contactForm: row.contactForm, contentUpdateDate: row.contentUpdateDate, rcn: row.rcn, order: row.order, role: row.role, ecContribution: row.ecContribution, netEcContribution: row.netEcContribution, totalCost: row.totalCost, endOfParticipation: row.endOfParticipation, active: row.active})
ON CREATE
	SET o._created = timestamp()
	SET o._updated = timestamp()
ON MATCH
	SET o._updated = timestamp()
RETURN count(o);

// create relationships
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_projects_out_formatted_latest.csv' AS row
WITH row WHERE row.id IS NOT NULL
MATCH (p:EuProject {id: row.id})
MATCH (o:Organization {projectID: row.id}) 
MERGE (o)-[r:PARTICIPATING]->(p)
RETURN count(r);

