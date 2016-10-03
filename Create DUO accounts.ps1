#Script used to take a CSV file full of AD usernames then generate another CSV compatible with DUO CSV import https://duo.com/docs/importing_users

$users = @()
$rawusers = Import-Csv .\rawusers.csv

$rawusers | ForEach-Object{
    $user = Get-ADUser $_.username -Properties Mobile
    $users += $user
    }


$users | select -property @{name="username";expression={$($_.samaccountname)}}, @{name="realname";expression={$($_.name)}}, @{name="email";expression={$($_.userprincipalname)}},@{name="phone";expression={$($_.mobile)}},@{name="platform";expression={""}} | export-csv duousers.csv -NoTypeInformation
