TODO
====

Fixes and ideas for the future

## Per user scotch

Different users have a different commit style & frequency.
We should be able to define a per-user scotch.


## Automatic scotch : Use median time between consecutive commits, per user

	def median(array)
  	  sorted = array.sort
  	  len = sorted.length
  	  return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
	end

