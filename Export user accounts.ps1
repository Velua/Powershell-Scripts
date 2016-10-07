$users = Get-ADUser -Properties DisplayName, Office, StreetAddress, City, State, PostalCode, Country, telephoneNumber, HomePhone, MobilePhone, Fax, ipPhone, wWWHomePage, Title, Department, Company, Manager -Filter {(Enabled -eq $True) -and (GivenName -ne $false) -and (DisplayName -notLike '*TestUser*')} | Where-Object {$_.DistinguishedName -notmatch 'Service|Restricted|Shared'}


# Get-ADUser Manager property returns DistinguishedName, this finds that user via DistinguishedName name and overwrites manager attributee with full name instead. 
$users | ForEach-Object{

        $manager = get-aduser -filter {DistinguishedName -eq $_.Manager}
        $manager = $manager | select Name | foreach{$_.Name}
        $_.Manager = $manager 
}



#$users | ForEach-Object{
#    echo "Getting AD groups for $($_.name)"
#    $groups = Get-ADPrincipalGroupMembership $_ | Select Name
#    $groupstring = $groups.name -join " "
#    $_.groups = $groupstring
#}


$users | select DisplayName, Office, StreetAddress, City, State, PostalCode, Country, telephoneNumber, HomePhone, MobilePhone, Fax, ipPhone, wWWHomePage, Title, Department, Company, Manager, groups | Export-csv userss.csv -NoTypeInformation
