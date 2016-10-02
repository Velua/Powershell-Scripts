#Remove disabled Active Directory users from all security groups except 'Domain users' 

$disabledusers = Search-ADAccount -AccountDisabled 
foreach ($user in $disabledusers){

$ADgroups = Get-ADPrincipalGroupMembership -Identity $user | where {$_.Name -ne "Domain Users"}

Remove-ADPrincipalGroupMembership -Identity "$user" -MemberOf $ADgroups -Confirm:$false
}
