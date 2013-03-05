# git-pair

<img src="https://travis-ci.org/edsinclair/git-pair.png?branch=master" height="14" alt="Retina-ready Shields example" />

A git porcelain for changing `user.name` and `user.email` so you can commit as
more than one author.

## Usage

Install the gem:

    gem install edsinclair-git-pair

Usage:

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
         Author list: Adam McCrea <amccrea@example.org>
                      Jon Distad <jdistad@example.net>

         Pair email: devs@edgecase.com

      Current author: Jon Distad + Adam McCrea
       Current email: devs+jd+am@example.com

## How does it work?

The list of authors is maintained in the global git configuration file.
The current author is set in the git configuration local to the project.
The email address for a pair will be generated using the first author's email
domain part and the address local parts separated by a '+' will precede the '@'.

You can specify a 'pair' email address to be used in which case the local part
will be followed by each author's initials separated by a '+' will be used to
form the local part of the pair email address. Alternatively if you leave off
the local part and specify the pair email address as '@domain.tld' the
local part for the pair email will be composed of the local part for each 
author's email address.

Examples with the git pair email set:

If the git pair email is: devs@example.com Then pair email address will be devs+am+jd@example.com
If the git pair email is: @example.com Then pair email address will be amccrea+jdistad@example.com

Examples without the git pair email set:

First author is Adam McCrea. Then pair email address will be amccrea+jdistad@example.org
First author is Jon Disatd. Then pair email address will be jdistad@+amccrea@example.net

## About this version

This was forked from http://github.com/edgecase/git-pair which in turn was
forked from http://github.com/chrisk/git-pair.  Many thanks to Chris Kampmeier
for the original version and Adam McCrea, John Distad and Ehren Murdick for the
features they added to the edgecase release.  This version adds a --show, --email
and --install-hook options and converts the gem to use Bundler for dependency management.

## License

Copyright (c) 2009 Chris Kampmeier.
Copyright (c) 2013 Eirik Dentz Sinclair. See `LICENSE` for details.
