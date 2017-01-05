# Get events in the past minute of user logins
$event = Get-WinEvent -Filterhashtable @{LogName="Security"; ID=4624; StartTime=(Get-Date).AddSeconds(-7)} | 
    Where { (2,7,8,9,10,11,12,13 -contains $_.Properties[8].Value) -and -not ($_.Properties[5].Value -match '^DWM|^SYSTEM|^ANONYMOUS|SERVICE$') -and -not ($_.Properties[12].Value -match '00000000-0000-0000-0000-000000000000') -and ($_.Properties[17].Value -like '*winlogon.exe*')}
$event = $event[0]
if(!$event){exit}

$user = $event.Properties[5].Value
$logontype = $event.Properties[8].Value
$ip = $event.Properties[18].Value
$email = "ALERTS@yourdomain.com"
$priority = "Normal"
$time = $event.TimeCreated


#Determine what SMTP server to use based on first number in server name this script is run on
$serverid = $env:computername -replace '\D+(\d)','$1'
$serverlocation = $serverid[0]

switch($serverlocation){
    "0" {$smtpaddress = "0.0.0.0"}
    "6" {$smtpaddress = "0.0.0.0"}
    "2" {$smtpaddress = "0.0.0.0"}
    default{$smtpaddress = "0.0.0.0"}
}


#Tell user which method of logon was used based on logontype
switch ($logontype){
    "10" {$phrase = "remoted into"}
    "7" {$phrase = "unlocked"}
    "2" {$phrase = "physically logged into"
        $priority = "High"}
    default{$priority = "Normal"}
}

$timenow = Get-Date

$body = '<html> <head> <style type="text/css"> body{ font-family: "Arial", sans-serif; } </style> </head> <body> <center> <h2>' + $user + '</h2><br> ' + $phrase + '<br> <h3> ' + $env:computername + '</h3> <br><br> Logon Type: ' + $logontype + '<br> Source IP Address: ' + $ip + '<br> Event created: ' + $time + '<br> Email triggered to send: ' + $timenow + '</center> </body> </html>'

Send-MailMessage -To $email -From "$env:computername@ezidebit.com.au" -Priority "$priority" -Subject "$user $phrase $env:computername from $ip" -Body $body -bodyashtml -SMTPServer $smtpaddress 
