# Simple script which gets the security groups of one Active Directory user and grants another user the same groups. 
# This is handy in cases where a staff member requests a new user account with the same priveleges of another user.

$groups = Get-ADPrincipalMembership -Identify jsmith
Add-ADPrincipalMembership -Identity EMusk -MemberOf $groups
