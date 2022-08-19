// load project nodes 
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_projects_out_formatted_latest.csv' AS row
WITH row WHERE row.id IS NOT NULL
MERGE (p:EuProject {id:row.id})
	ON CREATE SET p._created = timestamp()
	ON MATCH SET p._updated = timestamp()
SET p += {id: row.id, acronym: row.acronym, title: row.title, objective: row.objective, topics: row.topics, startDate: row.startDate, endDate: row.endDate, frameworkProgramme: row.frameworkProgramme, legalBasis: row.legalBasis, totalCost: row.totalCost, ecMaxContribution: row.ecMaxContribution, masterCall: row.masterCall, subCall: row.subCall, contentUpdateDate: row.contentUpdateDate}
RETURN count(p);

// load organization nodes
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_organizations_out_formatted_latest.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MERGE (o:Organization {organisationID: row.organisationID})
	ON CREATE SET o._created = timestamp()
	ON MATCH SET o._updated = timestamp()
SET o += {name: row.name, organisationID: row.organisationID, vatNumber: row.vatNumber, shortName: row.shortName, SME: row.SME,  street: row.street, postCode: row.postCode, city: row.city, country: row.country, nutsCode: row.nutsCode, geolocation: row.geolocation, organizationURL: row.organizationURL, contentUpdateDate: row.contentUpdateDate, rcn: row.rcn}
RETURN count(o);

// load topic nodes
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_topics_out.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MERGE (t:Topic {topic: row.topic})
	ON CREATE SET t._created = timestamp()
	ON MATCH SET t._updated = timestamp()
SET t += {projectID: row.projectID, title: row.title}
RETURN count(t);

// load tagline nodes
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_euroSciVoc_out.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MERGE (tl:Tagline {euroSciVocCode: row.euroSciVocCode})
	ON CREATE SET tl._created = timestamp()
	ON MATCH SET tl._updated = timestamp()
SET tl += {euroSciVocPath: row.euroSciVocPath, euroSciVocTitle: row.euroSciVocTitle, euroSciVocDescription: row.euroSciVocDescription}
RETURN count(tl);
