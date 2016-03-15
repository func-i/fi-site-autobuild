* bundle install
* heroku login
* git remote add heroku https://git.heroku.com/fi-website-autobuild.git
* git push heroku master

## Configuration

### S3

* Open the app from the [Heroku Dashboard](https://dashboard.heroku.com/apps). Click on **Settings**. In the **Config Variables** section, configure AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_S3_BUCKET

## Notes

* **IMPORTANT**: the Gemfile of this repo must contain all the gems in the website source repo's Gemfile. Every time you update the source repo's Gemfile, you must apply the same changes to the Gemfile of this repo. This is because you can't run `bundle install` from an app inside a Heroku dyno - you must

* pom.xml is required to add the Java buildpack on Heroku. Java is required by the s3_website gem
