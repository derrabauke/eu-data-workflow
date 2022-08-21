# eu-data-workflow

Here you witness my data analysis project which consists of this repo, which scrapes data from public sources and models them into the database, and a [visualization tool in the front](https://github.com/derrabauke/eu-data-frontend).

First of all this follows the great idea of [Simon Willison](https://github.com/simonw), who published [a great blog entry](https://simonwillison.net/2020/Oct/9/git-scraping/) about his experience of utilizing GitHub Actions as a scraping pipeline.

## Approach

This repository does the following:

* scrape data regulary from known source via cron timed GH Actions
* push the data through a minimal ETL pipeline
* upload the latest records to the Neo4j AuraDB
* keep track of data changes via Git history

## Get running yourself

You would need to setup a (free) Neo4j AuraDB and put the credentials into your repository secrets (`NEO4J_USER`, `NEO4j_PASSWORD`, `NEO4j_URL`). Further you have to adapt the actions under `.github/workflows/...` to your needs.
