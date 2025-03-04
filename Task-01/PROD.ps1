param (
    [Parameter(Mandatory = $false)]
    [object] $WebhookData
)

Write-Output "Starting Runbook Execution on Hybrid Worker..."

##############################################################
#       Initialize Variable Values Received from Params      #
##############################################################

if ($null -eq $WebhookData) {
    Write-Error "ERROR: WebhookData is null."
    return
}
$requestBody = $WebhookData.RequestBody
# Extract the RequestBody part from the string
$pattern = "u'RequestBody': u'([^']*)'"
if ($WebhookData -match $pattern) {
    $requestBody = $matches[1]
} else {
    Write-Error "RequestBody not found in the webhook data."
    return
}
Write-Output ("requestBody: " + $requestBody)

$userNames = @('jill.archbold', 'chandra.kolapalli', 'matt.ramos', 'shreyas.srivastava', 'shomen.roy', 'mayur.kumar', 'pranav.mishra', 'saurabh.vyas', 'chris.wang', 'adam.dagdelen', 'vishnu.narayanan', 'andrei.mihalache', 'bipin.alex', 'kedar.dahale', 'krystian.horoszkiewicz', 'mark.flores', 'patric.chiasson', 'pranay.agrawal', 'sandeep.burdagunta', 'sneha.tulluri', 'varun.reddy')

if ($null -ne $requestBody) {
    $user = $requestBody.Split("&")[6]
    $user_name = $user.Split("=")[1]
    $channel = $requestBody.Split("&")[3]
    $channel_id = $channel.Split("=")[1]
    $checkName = "$user_name"
    Write-Output "Received valid request body. User: $user_name, Channel: $channel_id"
} else {
    Write-Error "ERROR: No request body found in the webhook data."
    return
}

$validRequest = ($userNames -contains $checkName) -and ($channel_id -eq "G01C2PGF3K4")

if ($validRequest) {
    Write-Output "The User '$checkName' is authorized to run the slack command in channel_id '$channel_id'"
} else {
    Write-Error "ERROR: Unauthorized user or incorrect channel."
    return
}

$text = $requestBody.Split("&")[8]
$param = $text.Split("=")[1]
$Region = $param.Split("+")[0].ToLower()
$duration = $param.Split("+")[1]
$maintainance_mode = $param.Split("+")[2]
$regionName = $Region


$currentUTC = (Get-Date).ToUniversalTime()
$endTimeUTC = $currentUTC.AddMinutes($duration)

##############################################################
#                Set details based on region                 #
##############################################################

switch ($regionName) {
    "au" { 
        $SubscriptionId = "1ca39ea3-6fbc-47ee-816d-75babccf1afb" 
        $ResourceGroup = "RG-AKS-blue-au-prod"
        $AksClusterName = "aks-blue-au-prod"
        $StorageAccount = "clientresauprodyol0stntm"
        $SASTokenName = "AU-SA-SAS-Token"
        $NsName = "au-prod"
        $pagerDutyServiceId = "P68FE3B" 
        $workflowUp = "PL0U07L"
        $workflowDown = "P247MKE" 
        $deployments = @('responsible-gambling-au-prod', 'betty-placement-app-api-au-prod', 'auth-server')
    }
    "au-uat" { 
        $Region = "au"
        $SubscriptionId = "c466a919-2943-412b-b293-6aa1e8eccc54" 
        $ResourceGroup = "RG-AKS-blue-au-uat"
        $AksClusterName = "aks-blue-au-uat"
        $StorageAccount = "clientresauuatcbf7sj05yi"
        $SASTokenName = "AU-SA-SAS-Token"
        $NsName = "au-uat"
        $pagerDutyServiceId = "P68FE3B" 
        $workflowUp = "P7RPUYT"
        $workflowDown = "P0H8Z8F" 
        $deployments = @('responsible-gambling-au-uat', 'betty-placement-app-api-au-uat', 'auth-server')
    }
    "on" { 
        $SubscriptionId = "ffd90575-4b1e-4cb0-b110-44acd094d80e" 
        $ResourceGroup = "RG-AKS-blue-on-prod"
        $AksClusterName = "aks-blue-on-prod"
        $StorageAccount = "clientrescaprodphag0tuai"
        $SASTokenName = "CA-SA-SAS-Token" 
        $NsName = "on-prod"  
        $pagerDutyServiceId = "P68FE3B" 
        $workflowUp = "PWW8KRV"
        $workflowDown = "PA5WL3I"
        $deployments = @('global-account-engine-on-prod', 'responsible-gambling-on-prod')
    }
    "on-uat" { 
        $Region = "on"
        $SubscriptionId = "206afe36-a082-4610-bc5d-77fda827d411" 
        $ResourceGroup = "RG-AKS-blue-on-uat"
        $AksClusterName = "aks-blue-on-uat"
        $StorageAccount = "clientrescauatrimimq2ktx"
        $SASTokenName = "CA-SA-SAS-Token" 
        $NsName = "on-uat"  
        $pagerDutyServiceId = "PFAZQLM"
        $workflowUp = "P7RPUYT"
        $workflowDown = "P0H8Z8F" 
        $deployments = @('global-account-engine-on-uat', 'responsible-gambling-on-uat')
    }
    default { Write-Error "ERROR: Invalid region specified: $Region"; return }
}

#------------------------------------------------------------------------------------#
#############################################################
#           Connect To Azure Via Managed Identity
#############################################################

$url = $env:IDENTITY_ENDPOINT  
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]" 
$headers.Add("X-IDENTITY-HEADER", $env:IDENTITY_HEADER) 
$headers.Add("Metadata", "True") 
$body = @{resource='https://management.azure.com/' } 
$accessToken = Invoke-RestMethod $url -Method 'POST' -Headers $headers -ContentType 'application/x-www-form-urlencoded' -Body $body 

Write-Output "Connecting to azure via  Connect-AzAccount -Identity" 
Connect-AzAccount -Identity
Write-Output "Successfully connected with Automation account's Managed Identity" 

#Set the subscription to Global Prod to Fetch Secrets from Key-Vault
Set-AzContext 'pointsbet-global-prod'

##############################################################
#               Fetch Secrets from Key Vault
##############################################################

Write-Output "Establishing Connection with Key Vault to access Secrets"

# Fetch Secret for Azure Service Principal
$SAsecret = Get-AzKeyVaultSecret -VaultName 'kv-sre-global' -Name 'SA'
$SA_ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SAsecret.SecretValue) 
try { 
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($SA_ssPtr) 
    $securePasswordSA = $secretValueText
} finally { 
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SA_ssPtr) 
}

# Fetch Secret for Azure Service Principal Username
$SA_username = Get-AzKeyVaultSecret -VaultName 'kv-sre-global' -Name 'SA-username'
$SA_username_ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SA_username.SecretValue) 
try { 
  $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($SA_username_ssPtr) 
    $secureSAUsername = $secretValueText
} finally { 
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SA_username_ssPtr) 
}

Write-Output "Establishing connection with Key Vault to access Slack URL..."

try {
    $slacksecret = Get-AzKeyVaultSecret -VaultName 'kv-sre-global' -Name 'SlackWebHook'
    $slack_ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($slacksecret.SecretValue)
    $SlackUrl = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($slack_ssPtr)
    Write-Output "Successfully retrieved Slack Webhook URL from Key Vault"
} catch {
    Write-Error "ERROR: Failed to retrieve Slack URL from Key Vault: $_"
    return
}

Write-Output "Fetching SAS token from Key Vault for Blob Storage access..."

    try {
        $secret = Get-AzKeyVaultSecret -VaultName 'kv-sre-global' -Name $SASTokenName
        $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
        $SASToken = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
        Write-Output "Successfully retrieved SAS Token from Key Vault"
    } catch {
        Write-Error "ERROR: Failed to retrieve SAS Token from Key Vault: $_"
        return $false
    }

    Write-Output "Establishing Connection with Key Vault to access Secrets"

    # Fetch Secret for vstsPAT
    $PD_SASsecret = Get-AzKeyVaultSecret -VaultName 'kv-sre-global' -Name 'PD-API-Key'
    $PD_SAS_ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PD_SASsecret.SecretValue) 
    try { 
        $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($PD_SAS_ssPtr) 
          $PDToken = $secretValueText
    } finally { 
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PD_SAS_ssPtr) 
    }
# Connect to Azure via Service Principal
try 
{ 
    Write-Output ("Logging in to Azure via Service Principal...") 
    $userName = $secureSAUsername
    $securePassword = ConvertTo-SecureString $securePasswordSA -AsPlainText -Force
    $mySACred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $securePassword

    $tenantId = '42a9d7bd-d428-4c10-a19e-0e98f01e815d'
    

    Connect-AzAccount -ServicePrincipal -Credential $mySACred -Tenant $tenantId
} 
catch { 
    Write-Error -Message $_.Exception 
}

# Write-Output "Listing all the subscriptions available"
# Get-AzSubscription | Select-Object SubscriptionId, Name
# Write-Output "------------------------------------"

#------------------------------------------------------------------------------------#
try {
    Select-AzSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop
    Write-Output "Switched to Subscription: $SubscriptionId"
} catch {
    Write-Error "ERROR: Failed to set subscription: $_"
    return
}   

###########################################################
#          FUNCTION: Upload File to Blob Storage          #
###########################################################

function UploadToBlobStorage {
    param (
        [string]$StorageAccount,
        [string]$Region,
        [string]$FileName,
        [string]$Path,
        [string]$FileBody
    )

    $StorageURL = "https://$($StorageAccount).blob.core.windows.net/$($Path)"
    $blobUploadParams = @{
        URI     = "{0}/{1}?{2}" -f $StorageURL, $FileName, $SASToken
        Method  = "PUT"
        Headers = @{
            'x-ms-blob-type'                = "BlockBlob"
            'x-ms-blob-content-disposition' = "attachment; filename=`"{0}`"" -f $FileName
            'x-ms-meta-m1'                  = 'v1'
            'x-ms-meta-m2'                  = 'v2'
        }
        Body    = $FileBody
    }

    try {
        $response = Invoke-RestMethod @blobUploadParams -ErrorAction Stop
        if ($response -eq "") {
            Write-Output "Successfully uploaded file to Blob Storage"
            return $true
        } else {
            Write-Error "ERROR: Blob Storage upload failed"
            return $false
        }
    } catch {
        Write-Error "ERROR: Error occurred during Blob upload: $_"
        return $false
    }
}

###########################################################
#                    FUNCTION: Slack Integration          #
###########################################################

function SendSlack {
    param (
        [string]$url,
        [string]$channel,
        [string]$endTime
    )

    $deploymentsList = $deployments -join ", "
    if ($duration -eq 0) {
        $message = "$($regionName.ToUpper())- Maintenance activity finished on site successfully by $checkName`nScaling up deployments- $deploymentsList"
    } elseif ($duration -gt 0) {
        $message = "$($regionName.ToUpper())- Maintenance activity started on site successfully by $checkName till $endTime`nScaling down deployments- $deploymentsList"
    } else {
        Write-Error "ERROR: Invalid duration specified: $duration"
        return
    }

    $data = [PSCustomObject]@{
        channel = $channel
        text    = $message
    }
    $body = $data | ConvertTo-Json
    try {
        $result = Invoke-RestMethod -Method Post -Uri $url -Body $body
        Write-Output "Successfully sent message to Slack: $message"
    } catch {
        Write-Error "ERROR: Failed to send message to Slack: $_"
    }
}

$SlackUrl = "https://hooks.slack.com/services/" + $SlackUrl

##############################################################
#                          Main Function                     #
##############################################################


Write-Output "Region: $regionName, Maintenance Mode: $maintainance_mode, Duration: $duration minutes, StartTime: $currentUTC, EndTime: $endTimeUTC"

$message = switch ($maintainance_mode) {
    "unplanned" { "PointsBet is currently unavailable due to an unexpected issue in $($regionName.ToUpper()). We are working on it." }
    "planned" { "PointsBet is undergoing planned maintenance in $($regionName.ToUpper()). Thank you for your patience." }
    default { "Maintenance mode not recognized." }
}

$Path = "content/$($Region)/maintenance"
$FileName = "kill.json"
$kill_json = @([PSCustomObject]@{
    endTime   = $endTimeUTC.ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ")
    message   = $message
    startTime = $currentUTC.ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ")
}) | ConvertTo-Json

# Convert the JSON string to a PowerShell object
$kill_json = $kill_json | ConvertFrom-Json

# Convert the object back to a compressed JSON string without escape characters
$kill_json = $kill_json | ConvertTo-Json -Compress

$jsonArray = "[$kill_json]"


$uploadResult = UploadToBlobStorage -StorageAccount $StorageAccount -Region $Region -FileName $FileName -Path $Path -FileBody $jsonArray
if ($uploadResult) {
   # Write-Output "SLack message: $message, Slack url: $SlackUrl, channel: $channel_id "

   SendSlack -url $SlackUrl -channel $channel_id -endTime $endTimeUTC.ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ") 
}


#############################################################
#        Fetch AKS Cluster Credentials & Set KubeConfig     #
#############################################################

Write-Output "Fetching AKS cluster credentials using Import-AzAksCredential..."
try {
    # Ensure the .kube directory exists
    $kubeDir = "$HOME/.kube"
    if (!(Test-Path $kubeDir)) {
        New-Item -ItemType Directory -Path $kubeDir -Force | Out-Null
        Write-Output "Created .kube directory at: $kubeDir"
    }

    # Fetch credentials and save to default kubeconfig location
    Import-AzAksCredential -ResourceGroupName $ResourceGroup -Name $AksClusterName -Admin -Force

    # Set the kubeconfig path for Linux
    $kubeconfigPath = "$HOME/.kube/config"
    $env:KUBECONFIG = $kubeconfigPath
    Write-Output "Kubeconfig imported successfully. Path: $kubeconfigPath"
} catch {
    Write-Error "ERROR: Failed to import AKS credentials: $_"
    return
}

# Validate kubeconfig
if (!(Test-Path $env:KUBECONFIG)) {
    Write-Error "ERROR: Kubeconfig file not found at $env:KUBECONFIG"
    return
}

#############################################################
#                 Get Namespaces from AKS                   #
#############################################################

# Check if kubectl is installed
$kubectlPath = Get-Command kubectl -ErrorAction SilentlyContinue
if (-not $kubectlPath) {
    Write-Error "ERROR: kubectl not found. Install it on the Hybrid Worker."
    return
}
Write-Output "kubectl found at: $($kubectlPath.Path)"


#############################################################
#                Check Duration and Take Action             #
#############################################################

if ($duration -eq 0) {
    Write-Output "Duration is 0. Scaling up!."
    foreach ($deployment in $deployments) {
        try { 
            $deploymentsResp = & kubectl scale deployment $deployment --replicas=2 -n $NsName
            Write-Output "Scaled up deployment: $deployment"
        } catch {
            Write-Error "ERROR: Failed to scale up deployment: $deploymentsResp"
            return
        }
        
    }
} elseif ($duration -gt 0) {
    Write-Output "Duration is greater than 0. Scaling down!."
    foreach ($deployment in $deployments) {
        try { 
            $deploymentsResp = & kubectl scale deployment $deployment --replicas=0 -n $NsName
            Write-Output "Scaled down deployment: $deployment"
        } catch {
            Write-Error "ERROR: Failed to scale down deployment: $deploymentsResp"
            return
        }
    
    }
} else {
    Write-Error "ERROR: Invalid duration specified: $duration"
    return
}


#############################################################
# Clean up Kubeconfig environment variable
#############################################################
Write-Output "Cleaning up Kubeconfig environment variable..."
Remove-Item -Path Env:KUBECONFIG


#############################################################
# Function: Create PagerDuty Incident
#############################################################
function CreatePagerDutyIncident {
    param (
        [string]$ServiceId,
        [string]$Title,
        [string]$Severity,
        [string]$PDToken
    )

    $IncidentPayload = @{
        incident = @{
            type       = "incident"
            title      = $Title
            service    = @{ id = $ServiceId; type = "service_reference" }
            urgency    = "high"
            severity   = $Severity
        }
    } | ConvertTo-Json -Depth 3

    $Headers = @{
        "Authorization" = "Token token=$PDToken"
        "Content-Type"  = "application/json"
        "Accept"        = "application/json"
    }

    try {
        $Response = Invoke-RestMethod -Uri "https://api.pagerduty.com/incidents" -Method Post -Headers $Headers -Body $IncidentPayload
        return $Response.incident.id
    } catch {
        Write-Error "ERROR: Failed to create PagerDuty incident: $_"
        return $null
    }
}

#############################################################
# Function: Trigger PagerDuty Workflow
#############################################################
function TriggerPagerDutyWorkflow {
    param (
        [string]$WorkflowName,
        [string]$IncidentId,
        [string]$PDToken
    )
    
    $WorkflowPayload = @{
        incident_workflow_instance = @{
            id = $WorkflowName
            type = "incident_workflow_instance"
            incident = @{
                id = $IncidentId
                type = "incident_reference"
            }
        }
    } | ConvertTo-Json -Depth 3

    $Headers = @{
        "Authorization" = "Token token=$PDToken"
        "Content-Type"  = "application/json"
        "Accept"        = "application/vnd.pagerduty+json;version=2"
    }

    try {
        Write-Output "Triggering PagerDuty Workflow: $WorkflowName with incident: $IncidentId"
        $WorkflowUrl = "https://api.pagerduty.com/incident_workflows/$WorkflowName/instances"
        $Response = Invoke-RestMethod -Uri $WorkflowUrl -Method Post -Headers $Headers -Body $WorkflowPayload
        Write-Output "PagerDuty Workflow Triggered: $WorkflowName, Response : $Response"
    } catch {
        Write-Error "ERROR: Failed to trigger PagerDuty workflow: $_"
    }
}


#############################################################
# Create and Handle PagerDuty Incident
#############################################################

if($maintainance_mode -eq "unplanned") {
switch ($Region) {
    "au" { 
        if ($duration -eq 0) {
            Write-Output "Duration is 0. Creating UP Incident in PagerDuty for region $($regionName.ToUpper())."
            $IncidentId = CreatePagerDutyIncident -ServiceId $pagerDutyServiceId -Title "Website UP - $($regionName.ToUpper())" -Severity "info" -PDToken $PDToken
            if ($IncidentId) {
                TriggerPagerDutyWorkflow -WorkflowName $workflowUp -IncidentId $IncidentId -PDToken $PDToken
            }
        } elseif ($duration -gt 0) {
            Write-Output "Duration is greater than 0. Creating DOWN Incident in PagerDuty for region $($regionName.ToUpper())"
            $IncidentId = CreatePagerDutyIncident -ServiceId $pagerDutyServiceId -Title "Website DOWN - $($regionName.ToUpper())" -Severity "critical" -PDToken $PDToken
            if ($IncidentId) {
                TriggerPagerDutyWorkflow -WorkflowName $workflowDown -IncidentId $IncidentId -PDToken $PDToken
            }
        }
    }
    "on" { 
        if ($duration -eq 0) {
            Write-Output "Duration is 0. Creating UP Incident in PagerDuty for region $($regionName.ToUpper())"
            $IncidentId = CreatePagerDutyIncident -ServiceId $pagerDutyServiceId -Title "Website UP - $($regionName.ToUpper())" -Severity "info" -PDToken $PDToken
            if ($IncidentId) {
                TriggerPagerDutyWorkflow -WorkflowName $workflowUp -IncidentId $IncidentId -PDToken $PDToken
            }
        } elseif ($duration -gt 0) {
            Write-Output "Duration is greater than 0. Creating DOWN Incident in PagerDuty for region $($regionName.ToUpper())"
            $IncidentId = CreatePagerDutyIncident -ServiceId $pagerDutyServiceId -Title "Website DOWN - $($regionName.ToUpper())" -Severity "critical" -PDToken $PDToken
            if ($IncidentId) {
                TriggerPagerDutyWorkflow -WorkflowName $workflowDown -IncidentId $IncidentId -PDToken $PDToken
            }
        }
    }
    default { Write-Error "ERROR: Invalid region specified: $Region"; return }
}
}


Write-Output "Runbook execution completed."

