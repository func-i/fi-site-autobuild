* `bundle install`
* `heroku login`
* `git remote add heroku https://git.heroku.com/fi-website-autobuild.git`
* `git push heroku master`

## Configuration

### S3

* **S3 bucket**: Open `/s3_config_staging/s3_website.yml` for staging, `/s3_config_production/s3_website.yml` for production. Set the `s3_bucket` field
* **AWS access keys**: Open the app from the [Heroku Dashboard](https://dashboard.heroku.com/apps). Click on **Settings**. In the **Config Variables** section, set the fields: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

## Notes

* **IMPORTANT**: the Gemfile of this repo must contain all the gems in the website source repo's Gemfile. *Every time you update the source repo's Gemfile, you must apply the same changes to the Gemfile of this repo.* This is because you can't run `bundle install` from an app inside a Heroku dyno - install the gems needed for `jekyll build` locally so that Heroku makes them available in the dyno

* pom.xml is required to add the Java buildpack on Heroku. Java is required by the s3_website gem
