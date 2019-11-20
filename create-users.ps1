Import-Module ActiveDirectory

$OUforUsers = "OU=Test Users,DC=test,DC=local"
$GenericPassword = "Password1"

$GenericParams = @{
    Enabled = $true 
    CannotChangePassword = $true 
    ChangePasswordAtLogon = $false
    PasswordNeverExpires = $true
}

#https://social.technet.microsoft.com/wiki/contents/articles/5312.active-directory-characters-to-escape.aspx
$UserParams = @{
    comma = @{
        SamAccountName = "commauser"
        Name = "User, Comma"
    }
    backslash = @{
        SamAccountName = "backslashuser"
        Name = "\Backslash User"
    }
    forwardslash = @{
        SamAccountName = "forwardslashuser"
        Name = "Forward/Slash User"
    }
    chevrons = @{
        SamAccountName = "chevronuser"
        Name = "<br>chevronuser<br>"
    }
    semicolon = @{
        SamAccountName = "semicolonuser"
        Name = "Semi;Colon User"
    }
    whitespace = @{
        SamAccountName = "spaceuser"
        Name = "  Space  User  "
    }
    equals = @{
        SamAccountName = "equalsuser"
        Name = "Equals=User"
    }
    hash = @{
        SamAccountName = "hashuser"
        Name = "#hash#user#"
    }
    quotes1 = @{
        SamAccountName = "quotesuser1"
        Name = "Quote""User"
    }
    quotes2 = @{
        SamAccountName = "quotesuser2"
        Name = "Quote ""User"""
    }
    quotes3 = @{
        SamAccountName = "quotesuser3"
        Name = "Quote 'User'"
    }
    tildedn = @{
        SamAccountName = "nwithatilde"
        Name = "My ñame has a tilde"
    }
    tilde = @{
        SamAccountName = "tildewithaname"
        Name = "My name has a ~tilde"
    }
    brackets = @{
        SamAccountName = "brackets"
        Name = "Brackets (here)"
    }
    asterisk = @{
        SamAccountName = "asterisk"
        Name = "Asterisk*"
    }
}

foreach($key in $UserParams.keys){
    
    $User = $UserParams["$key"]
    $User.Add('Path', $OUforUsers)

    $UserUpdate = $GenericParams.Clone() # Because references.
    $UserUpdate.Add('Identity', $User["SamAccountName"])
    
    try{
        $u = New-ADUser @User -PassThru
        Write-Host Created $u.SamAccountName

        # Using ADSI instead of PowerShell for the password, working around https://windowsserver.uservoice.com/forums/304621-active-directory/suggestions/15344391-set-adaccountpassword-raises-error-if-dn-of-accoun
        $dn = $u.DistinguishedName
        $dn = $dn.replace("/","\/")
        $u = [ADSI]"LDAP://$dn"
        $u.SetPassword($GenericPassword)
        Write-Host Set password for $u.SamAccountName
        
        Set-ADUser @UserUpdate
        Write-Host Updated $u.SamAccountName
    }
    catch [Exception]{
        Write-Output $_.Exception|format-list -force # Descriptive output
    }
    Write-Host Finished with $u.SamAccountName
    
}
