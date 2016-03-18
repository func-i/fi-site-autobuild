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

* **Important**: the Gemfile of this repo must contain all the gems in the website source repo's Gemfile.
    - *If you update the source repo's Gemfile on `staging` or `master`, apply the same changes to the Gemfile of this repo, and push to Heroku here before you push the source repo changes.*
    - This is because you can't run `bundle install` from an app inside a Heroku dyno. When you `git push heroku` locally, Heroku installs the gems available to the dyno based on the Gemfile in this repo

* The /POST request sent by the GitHub webhook to the Heroku server often times out, as Heroku has a fixed 30-second limit for request timeout, and it takes a while to download + build + deploy. *The auto-build server works fine despite this issue.* Ignore the following error displays:
    - `heroku logs --tail` often shows `heroku[router]: at=error code=H12 desc="Request timeout" ...`
    - In the fi-site-source repo, `Settings` -> `Webhooks & Services`, the webhook `http://fi-website-autobuild.herokuapp.com/github_webhooks` often shows an error status

* pom.xml is required to add the Java buildpack on Heroku. Java is required by the s3_website gem
