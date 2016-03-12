# Sledsheet 4

![](https://codeship.com/projects/ec1426e0-e942-0132-a3a1-26b28b7b5489/status?branch=master)

Sledsheet is an app for fans, coaches, and athletes of the sliding sports (mostly skeleton). Its main features are:

- A database of race results dating back to 1998. (working towards a full recreation of the [IBSF database](http://www.ibsf.org))
- Analysis tools for athletes (splits, intermediates, differences, graphs)
- Email notifications for users, set by track, athlete, or circuit.
- In-season point calculation for race circuits.
- Athlete profile tools.

## Sites
- Production: [www.sledsheet.com](http://www.sledsheet.com).
- Staging: [sledsheet-staging.herokuapp.com](http://sledsheet-staging.herokuapp.com)
- Review: [sledsheet-pr-n.herokuapp.com](http://sledsheet-pr-n.herokuapp.com), where n is the Pull Request #

## Local installation
The app is running on rails 4.2.3 and ruby 2.2.2.

1. Install Postgres `brew install postgres`
2. Install RVM
3. Clone the repo
4. `cd path/to/sledsheet`
5. Set environment variables and config in `application.yml` (Figaro gem)
6. `rake db:setup`
7. `rails s`

## Environments and Deployment

### Development
Sledsheet uses the [Github Flow](http://scottchacon.com/2011/08/31/github-flow.html) workflow. Create a local branch for a new feature or hotfix (eg. feature/point-calculator or hotfix/update-readme). Push the named branch to the remote repo. When your feature or hotfix is done and tested, open a pull request. The pull request will be reviewed and merged into master, and the remote branch will be deleted. You can delete your local branch or continue working it.

Please use semantic versioning for tags. Sledsheet is currently at `v0.5.0`.

There is a staging site at [sledsheet-staging.herokuapp.com](http://sledsheet-staging.herokuapp.com). It's using the hobby free version of Postgres, so you shouldn't copy the production database directly to it. You can push changes to staging, but it's better to open a Pull Request to take advantage of Heroku Pipelines (see deployment below). Remember to run `heroku run rake db:migrate --app sledsheet` if you made changes to the database.

### Deployment
Sledsheet takes advantage of [Heroku Pipelines](https://devcenter.heroku.com/articles/pipelines). When a new Pull Request is opened on GitHub, Heroku will automatically create a [review app](https://devcenter.heroku.com/articles/pipelines#review-apps), with a corresponding URL of format https://sledsheet-pr-n.herokuapp.com (where n is the PR #). Post deploy, Pipelines will run `rake db:setup` and add a small but comprehensive amount of seed data to the review app database. When the PR is merged to the master branch, GitHub integration will push the new code base to staging automatically. When the PR is closed, the review app is deleted.

You can promote staging to production from the Heroku command line tool, or from the web interface.

`$ heroku pipelines:promote -r staging`

Important: You can't automate scripts when promoting apps. For instance, you will have to run `rake db:migrate` manually if you made database changes.

Continuous integration is handled by [Codeship](https://www.codeship.com).  

### Test
Sledsheet uses the testing suite included with rails (fixtures, minitest). Please do not use Rspec, FactoryGirl, etc. Run tests with:

`rake test`

### Production
Anything pushed to `master` or merged in will automatically deploy to staging. Promote staging apps to production after they pass tests.

## Services
- Papertrail for error monitoring
- Skylight.io for performance monitoring
- Segment for analytics (forthcoming)
- ~~Mandrill for sending emails~~ (alternatives?)
- MailChimp for mailing lists
- AWS S3 for image upload

API Keys and Secrets are needed for most of these services, and should *only* be stored in `application.yml`. **Do not store API keys in the repo!**

## Issues
All upcoming features, bug tracking, etc are handled through GitHub Issues. Please add proper labels to your issue.
