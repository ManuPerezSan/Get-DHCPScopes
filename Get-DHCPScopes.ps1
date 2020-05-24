<#
.SYNOPSIS
    Connect to local or remote windows DHCP service to obtain data about DHCP scopes.

.PARAMETER dhcpservers
    List of one or more element to connect for.

.RETURN
    Return data in json format.
    
.AUTHOR
    Manuel Pérez

.PROJECTURI
    https://github.com/ManuPerezSan

.REQUIREMENTS
    Windows OS
    RSAT-DHCP installed (Install-WindowsFeature RSAT-DHCP)

#>
[CmdletBinding()]
Param(
[Parameter(Mandatory=$true, Position=0)][string[]]$DhcpServers,
[Parameter(Mandatory=$true, Position=1)][pscredential]$Credential
)

$result = @()

Foreach($dhcpserver in $DhcpServers){

    $cim = New-CimSession -ComputerName $dhcpserver -Credential $credential

    If ((Get-DhcpServerv4failover -CimSession $cim ).name){

        $dhcpcluster = Get-DhcpServerv4Failover -CimSession $cim
        $server=($dhcpcluster).name
    
    }else{

        $server=$env:computername

    }
    
    Foreach ($scope in (Get-DhcpServerv4Scope -CimSession $cim)){

        $hash = @{}

        $scopeId = $scope.ScopeId.IPAddressToString
        $inUse = (Get-DhcpServerv4ScopeStatistics -CimSession $cim -ScopeId $scopeId).InUse
        $free = (Get-DhcpServerv4ScopeStatistics -CimSession $cim -ScopeId $scopeId).Free
        $reserved = (Get-DhcpServerv4ScopeStatistics -CimSession $cim -ScopeId $scopeId).Reserved
        $percentageInUse = [math]::Round((Get-DhcpServerv4ScopeStatistics -CimSession $cim -ScopeId $scopeId).PercentageInUse,1)
        $total = $free + $inUse + $reserved

        $hash.Add('InUse', $inUse)
        $hash.Add('Free', $Free)
        $hash.Add('Reserved', $reserved)
        $hash.Add('PercentageInUse', $percentageInUse)
        $hash.Add('Total', $total)

        $result += @{
            "Scope" = $scope.Name
            "Statistics" = $hash
        }
        
    }

    Remove-CimSession $cim -Confirm:$false

}

ConvertTo-Json $result -Depth 2 #-Compress