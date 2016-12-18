#Times is a array of AD User objects with properties PasswordExpired, PasswordLastset & name

$times | Where-Object {$_.PasswordExpired -eq $False} | foreach-object{

$week = Get-Date
$week = $week.AddDays(14)

$expiretime = $_.PasswordLastSet
$expiretime = $expiretime.AddDays(90)

if ($expiretime -lt $week){
Write-Host $_.name password will expire at $expiretime }
}

}
