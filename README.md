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

## Contributing

Please create a feature branch and issue a Pull Request for all new features
and bug fixes.  Ensure the test suite passes before issuing a Pull Request.

Thanks in advance for your contribution!

## License

Protected under the MIT License. Read more [here](./LICENSE)
