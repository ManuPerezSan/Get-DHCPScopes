# Get-DHCPScopes

## SYNOPSIS
    This script connect to local or remote windows DHCP service to obtain data about DHCP scopes. Output data could import on InfluxDB to make your own dashboard.

## PARAMETER dhcpservers
    List of one or more element to connect for.

## RETURN
    Return data in json format.
    
## REQUIREMENTS
    Windows OS DHCP Servers
    RSAT-DHCP installed (Install-WindowsFeature RSAT-DHCP)

## Idea
Add this information to your InfluxDB and create dashboard with Grafana.
