# Viget Hookshot

**This is a work-in-progress**

## What is Viget Hookshot?

Viget Hookshot is a simple Sinatra app that serves as a Github Post-Receive
Hook to handle whatever you want.

At Viget, we have been experiencing problems with Jenkins building when devs
push to feature branches.  Viget Hookshot was created as a middle-man to stop
the madness.

Viget Hookshot can be extended to your heart's desire.  Maybe you want to
notify Campfire when the production branch has been updated.  Maybe you want to
deploy to a staging environment when the staging branch has been updated.  Let
your imagination run wild!

## Configuration to Only Build Specified Branches

* Add the Github WebHook URL ( https://github.com/vigetlabs/[project name]/settings/hooks )
    * Base URL: http://viget-hookshot.herokuapp.com/hooks/jenkins
    * Params:
        * project (required): the name of the Jenkins project
        * branches (optional): a comma-delimited list of branches to trigger builds from.  Default is `master`.
    * Example:
        * http://viget-hookshot.herokuapp.com/hooks/jenkins?project=Puma&branches=master

* Configure the Jenkins project
    * Under the “Build Triggers” section, there is an option for “Trigger builds remotely”.  Check the box.
    * Enter `YOUR_AUTH_TOKEN_HERE` as the Authentication Token

* Celebrate for a job well done and for great Jenkins justice!

## Contributing

Please create a feature branch and issue a Pull Request for all new features
and bug fixes.  Ensure the test suite passes before issuing a Pull Request.

Thanks in advance for your contribution!

## License

Protected under the MIT License. Read more [here](./LICENSE)
