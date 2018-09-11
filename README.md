[![CircleCI](https://circleci.com/gh/Showner/THP2api/tree/master.svg?style=svg)](https://circleci.com/gh/Showner/THP2api/tree/master)

# Priority Steps
-pagination tests

# README

In prod, you should change the mail_sender in config/initializer/devise.rb

# TODO

- Add in user model specs : [test](https://github.com/Showner/THP2api/pull/51/files/77293378f8615db6a7cadad143a9e6c33fe0a8fe#diff-12b107c16792b9ecba685e51b51826f1)
- Test in all controllers response Parse is as expected (ex: status Forbidden => value can't be blank)
- Routing Specs
- Create index lesson and session (course_session) only for admins
- Can Invite (invitation controller) when not authenticated

#### LOOK THIS

Course_session index method: scope of data return
Can't continue to use dependent destroy
Concerns


# Rubytools

https://github.com/awesome-print/awesome_print 
https://github.com/cldwalker/hirb

# Implement

# Ressources
### Sidekiq
- Sidekiq config [devise and activejob](https://github.com/plataformatec/devise#activejob-integration)
- for Docker: add `- REDIS_URL=redis://redis` in app env vars
