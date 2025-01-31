# Does the call to Home Assistant's API
function InvokeHA {
    param ([string]$state, [string]$friendlyName, [string]$icon, [string]$entityId)

    $headers = @{"Authorization"="Bearer $HAToken"}
    # Use default credentials in the case of a proxy server, not sure if this is doing anything as $Wcl is not used anywhere
    $Wcl = new-object System.Net.WebClient
    $Wcl.Headers.Add("user-agent", "PowerShell Script")
    $Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials 

    Write-Host ("Setting <"+$friendlyName+"> to <"+$state+">:")
    $params = @{
        "state"="$state";
        "attributes"= @{
            "friendly_name"="$friendlyName"; # Redundant as it is already in HA but without it HA resets it to the sensor id
            "icon"="$icon";
        }
    }
     
    $params = $params | ConvertTo-Json
    Invoke-RestMethod -Uri "$HAUrl/api/states/$entityId" -Method POST -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($params)) -ContentType "application/json"    
}

# In this design the environment var takes precedence over the local variable
function GetSysVar{
    param([string]$envVar, [string]$localVar)

    $result = if ([string]::IsNullOrEmpty($envVar)) {$localVar} else {$envVar}
    return $result
}
