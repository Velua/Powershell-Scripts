$comps = Get-ADComputer -Filter * -Properties Lastlogondate | where {$_.lastlogondate -lt $sixty} | select name, lastlogondate | where {$_.name -like '*WS-*' -or $_.name -like '*LT-*'}
