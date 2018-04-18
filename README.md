# Click Returner challenge. The goal was to create a project meeting the following criteria:
**Given an array of clicks, return the subset of clicks where:**
1. For each IP within each one hour time period, only the most expensive click is placed into the result set.
2. If more than one click from the same IP ties for the most expensive click in a one hour period, only place the earliest click into the result set.
3. If there are more than 10 clicks for an IP in the overall array of clicks, do not include any of those clicks in the result set.

The result set should be stored in an array of hashes. Each hash should represent a click. The expected result set should be a subset of the original array

Definitions
1. A *click* is the composite of an IP address, a timestamp, and a click amount.
2. Duplicate clicks are the clicks that have the same IP address, regardless of timestamp or click amount.
3. Click periods are defined as the one hour spans that start at the top of the hour. So, in one day there are 24 periods and they are broken down as follows (in HH:MM:SS format):

1. 00:00:00 - 00:59:59 (Period 1)

And so on.

In my spec file, I divided the requirements between three different spec blocks to test each requirement.