# tricky-ad-users
Powershell script to create users in Active Directory that have CNs that should be escaped when used a Distinguished Name

## Usage
Run in Powershell ISE, or in any Powershell terminal (with relevant ExecutionPolicy). 

Runs as the current user, so you'll need permissions to create AD objects.

## Roadmap

Future work ideas are all niceties and housekeeping:
* Test for the presence of the OU
* If the OU doesn't exist, create it
* If the sAMAccountName already exists, do something
* Option to delete users first
* etc