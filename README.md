Auto-Build Server for FI's Website
=============

Pushing to the website's [source repo](https://github.com/func-i/fi-site-source) will send a webhook to this server hosted on Heroku, which will build the site and deploy it to either the staging (`fi-website-staging`) or the production (`functionalimperative.com`) bucket on Amazon S3.

## Development

* `bundle install`
* `heroku login`
* `git remote add heroku https://git.heroku.com/fi-website-autobuild.git`
* `git push heroku master`


## Configuration

### S3

* **S3 bucket**: Open `/s3_config_staging/s3_website.yml` for staging, `/s3_config_production/s3_website.yml` for production. Set the `s3_bucket` field
* **AWS access keys**: Open the app from the [Heroku Dashboard](https://dashboard.heroku.com/apps). Click on **Settings**. In the **Config Variables** section, set the fields: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`


## Notes

* **IMPORTANT**: the Gemfile of this repo must contain all the gems in the website source repo's Gemfile. *If you update the source repo's Gemfile on `staging` or `master`, apply the same changes to the Gemfile of this repo, and push to Heroku here before you push the source repo changes.* This is because you can't run `bundle install` from an app inside a Heroku dyno - install the gems needed for `jekyll build` locally so that Heroku makes them available in the dyno

* pom.xml is required to add the Java buildpack on Heroku. Java is required by the s3_website gem
