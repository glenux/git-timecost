TimeCost for Git
================

Use git logs to give an estimation of spent time & costs of your projects.

Installation
------------

* Clone the project somewhere
* Copy the ''bin/git-timecost'' file in ''/usr/local/bin''

Usage
-----

To get the total time spent on your git project

```
$ git timecost

[...]

(1.36) 2012-12-31T11:15:31+01:00 - 2012-12-31T12:36:55+01:00
        * Glenn Y. Rolland <glenux@glenux.net>
          Fix filtering.
        * Glenn Y. Rolland <glenux@glenux.net>
          Time range extractor for git.

TOTAL: 3.36 hours
```

To get the time spent on your project since a given date

```
$ git timecost -d 2013-03-01
set date filter to 2013-03-01
(1.0) 2013-09-23T13:02:39+02:00 - 2013-09-23T14:02:39+02:00
        * Glenn Y. Rolland <glenux@glenux.net>
          Add support for import / export / merge of ranges.

TOTAL: 1.00 hours
```

For other possibilities
```
$ git timecost -h
```

