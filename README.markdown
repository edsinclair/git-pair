# git-pair

A git porcelain for changing `user.name` and `user.email` so you can commit as
more than one author.

## Usage

Install the gem:

    gem install edgecase-git-pair

And here's how to use it!

    $ git pair

    General Syntax:
      git pair [reset | authors | options]

    Options:
        -a, --add AUTHOR                 Add an author. Format: "Author Name <author@example.com>"
        -r, --remove NAME                Remove an author. Use the full name.
        -d, --reset                      Reset current author to default (global) config
        -s, --show 'aa [bb]'             Show the string to be used for the commit author field
            --install-hook               Install a post-commit hook for the current repo. See git-pair/hooks/post-commit for more information.
            --email EMAIL                Add a default email address to be used for pairs

    Switching authors:
      git pair aa [bb]                   Where AA and BB are any abbreviation of an
                                         author's name. You can specify one or more authors.

    Current config:
         Author list: Adam McCrea
                      Jon Distad

      Current author: Jon Distad + Adam McCrea
       Current email: devs+jd+am@edgecase.com

## How does it work?

The list of authors is maintained in the global git configuration file.
The current author is set in the git configuration local to the project.
The email address for a pair will be generated using the first author's email
domain and the initials separated by a '+' will precede the '@'.
Alternatively you can specify an email address to be used for pair commits.
For example: if you specify pair@example.net the pair email address will be pair+aa+bb@example.net

## About this version

This was forked from http://github.com/chrisk/git-pair.  Many thanks to
Chris Kampmeier for the original version.  Our version added the --reset
option, modified how email addresses are handled, and refactored much of
the code.

## License

Copyright (c) 2009 Chris Kampmeier. See `LICENSE` for details.
