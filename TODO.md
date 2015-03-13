TODO
====

Fixes and ideas for the future

## Use an in-memory database

The goal is to be able to keep associations & be able
to make request on them, without having to maintain 
various data structures.

I imagine i could just use ActiveRecords for Ranges & Commit
but i fear its the impact on the code. I would like to keep
the codebase as clean as possible.


## Merge users

Set-up a config file, either global or per repository
With id => names associations, so we can merge
users who commit with various names/emails/etc

    - name: "John Smith <john.smith@company.com>", 
      match:
        - "John S. <john@example.com>",
        - "John Smith <john.s@example.com>",
        - "J. Smith <smith@example.com>"
    - name: "Foo Bar <foobar@company.com>",
      match:
        - "Foo B. <foobar@example.com>"
        - "Foo Bar <foobar@company.com>"


## Per user scotch

Different users have a different commit style & frequency.
We should be able to define a per-user scotch.

## Automatic scotch : Use median delay between consecutive commits, per user

    def median(array)
      sorted = array.sort
      len = sorted.length
      return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end

