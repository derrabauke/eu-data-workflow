// create relationships
LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_organizations_out_formatted_latest.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MATCH (p:EuProject {id: row.projectID})
MATCH (o:Organization {organisationID: row.organisationID})
MERGE (o)-[r:PARTICIPATE]->(p)
	ON CREATE CALL {
		WITH o,p
		OPTIONAL MATCH (o2)-[:PARTICIPATE]->(p)
		WHERE o2.organisationID IS NOT o.organisationID
		MERGE (o)-[c:COOPERATE]-(o2)
		WITH CASE c.weight WHEN null THEN 1 ELSE c.weight+1 END AS cw
		SET c += { weight: cw}
	}
SET r += {active: row.active, activityType: row.activityType, contactForm: row.contactForm, contentUpdateDate: row.contentUpdateDate, endOfParticipation: row.endOfParticipation, ecContribution: row.ecContribution, netEcContribution: row.netEcContribution, order: row.order, role: row.role, totalCost: row.totalCost }
RETURN count(r)

LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_topics_out.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MATCH (t:Topic {topic: row.topic})
MATCH (p:EuProject {id: row.projectID})
MERGE (t)<-[ht:HAS_TOPIC]-(p)
	ON CREATE SET t._created = timestamp()
	ON MATCH SET t._updated = timestamp()
RETURN count(ht);

LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_euroSciVoc_out.csv' AS row
WITH row WHERE row.projectID IS NOT NULL
MATCH (tl:Tagline {euroSciVocCode: row.euroSciVocCode})
MATCH (p:EuProject {id: row.projectID})
MERGE (tl)<-[tw:TAGGED_WITH]-(p)
	ON CREATE SET tl._created = timestamp()
	ON MATCH SET tl._updated = timestamp()
RETURN count(tw);

// The call structure is to ambigious
/* LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_projects_out_formatted_latest.csv' AS row */
/* WITH row WHERE row.id IS NOT NULL */
/* MATCH (p:EuProject {id: row.id}) */
/* WITH p WHERE p.masterCall IS NOT NULL */
/* MERGE (mc:MasterCall {title: p.masterCall}) */ 
/* MERGE (p)-[:CALLED_BY]->(mc) */
/* RETURN count(mc) */

/* LOAD CSV WITH HEADERS FROM 'https://github.com/derrabauke/eu-data-workflow/raw/main/h2020_projects_out_formatted_latest.csv' AS row */
/* WITH row WHERE row.id IS NOT NULL */
/* MATCH (p:EuProject {id: row.id}) */
/* WITH p WHERE p.subCall IS NOT NULL */
/* MERGE (sc:SubCall {title: p.subCall}) */ 
/* MERGE (p)-[:CALLED_BY]->(sc) */
/* RETURN count(sc); */

