You'll need a mysql database to run the tests.  You can create it like
so:

    mysql -u root -pYOURPASS -e <<CMDS
      create database ar_inception;
      grant all privileges on ar_inception.* to gemtests@localhost identified by 'rsanders';
CMDS

After you do that, just:

    bundle exec rake spec
