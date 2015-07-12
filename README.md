# Sledsheet 4

Sledsheet is an app for fans, coaches, and athletes of the sliding sports (mostly skeleton). Its main features are:

- A database of race results dating back to 1998. (Full copy of the [IBSF database](http://www.ibsf.org))
- Analysis tools for athletes (splits, intermediates, differences, graphs)
- Email notifications for users, set by track, athlete, or circuit.
- In-season points calculation for race circuits.
- Athlete profile tools.

## Sites
- Production: [www.sledsheet.com](http://www.sledsheet.com).
- Staging: [sledsheet-staging.herokuapp.com](http://sledsheet-staging.herokuapp.com)

## Local installation
The app is running on rails 4.2.3 and ruby 2.2.2.

1. Install Postgres `brew install postgres`
2. Install RVM
3. Clone the repo
4. `cd path/to/sledsheet`
5. Set environment variables and config in `application.yml` (Figaro gem)
6. `rake db:create`
7. `rake db:schema:load`
8. `rake db:seed`
9. `rails s`

## Environments

### Development
Sledsheet uses the [Github Flow](http://scottchacon.com/2011/08/31/github-flow.html) workflow. Create a local branch for a new feature or hotfix (eg. feature/point-calculator or hotfix/update-readme). Push the named branch to the remote repo. When your feature or hotfix is done and tested, create a pull request. The pull request will be reviewed and merged into master, and the remote branch will be deleted. You can delete your local branch or continue working it.

Please use semantic versioning for tags. Sledsheet is currently at `v0.5.0`.

There is a staging site at [sledsheet-staging.herokuapp.com](http://sledsheet-staging.herokuapp.com). It's using the hobby free version of Postgres, so you can't copy the production database directly to it. It does however have several thousand records already saved. Please push major changes to staging before pushing to production. Remember to run `heroku run rake db:migrate --app sledsheet` if you made changes to the database.

### Test
Sledsheet uses the testing suite included with rails (fixtures, minitest). Please do not use Rspec, FactoryGirl, etc. Run tests with:

`rake test`

### Production
Anything pushed to `master` or merged in will automatically deploy to Heroku. Please push your local feature and hotfix branches to the repo and issue a pull request, which can be merged for automatic deployment.

## Services
- Papertrail for error monitoring
- Skylight.io for performance monitoring
- Segment for analytics (forthcoming)
- Mandrill for sending emails
- MailChimp for mailing lists
- AWS S3 for image upload

API Keys and Secrets are needed for most of these services, and should *only* be stored in `application.yml`. **Do not store API keys in the repo!**

## Issues
All upcoming features, bug tracking, etc are handled through GitHub Issues. Please add the proper label to your issue.
