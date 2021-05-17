#.csv for import needs the following fields:
#lastname;firstname;firm;phone

#Path to csv and delimiter
$Import = Import-Csv -Delimiter ";" -LiteralPath "list.csv"

#Where should the users be added?
$OU = "OU=Jitsi,DC=loechel,DC=sul"

#Count the number of entries
$i = 0

Foreach ($user in $Import)
{	
	#Check if the user is a company
	if ( $user.firm )
	{
		#Check if the company has a contact person
		if ( $user.firstname ){
			$displayname = $user.firm + " - " + $user.firstname + " " + $user.lastname
			$firstname = $user.firstname
			$lastname = $user.lastname
		}
		#Company has no contact person
		else{
			$displayname = $user.firm
			$firstname = " "
			$lastname = " "
		}
	}
	#User is not a company
	else{
		$displayname = $user.firstname + " " + $user.lastname
		$firstname = $user.firstname
		$lastname = $user.lastname
	}
	
	#Add to ActiveDirectory
	New-ADObject -name $displayname -Type Contact -path $OU -OtherAttributes @{
		'telephoneNumber' = $user.phone;
		'givenName'= $firstname;
		'sn'= $lastname;
		'displayname'= $displayname
	}
	
	#Count iterations
	$i++
	
	#Write log
	Write-Output $i 
	Write-Output $displayname
}
 
