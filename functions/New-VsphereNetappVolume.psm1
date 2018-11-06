function New-VsphereNetappVolume {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$False, HelpMessage="Name of the New Volume")]
        [ValidateNotNullorEmpty()]
            [String]$VolName,
        [Parameter(Mandatory=$True, ValueFromPipeline=$False, HelpMessage="Size of the New Volume in GB")]
        [ValidateNotNullorEmpty()]
            [int]$VolSize
    )

    DynamicParam {
        # vSphere Cluster parameter
        $vSphereClusterName = 'vSphereCluster'
        $vSphereClusterAttributeProperty = @{
            Mandatory = $true;
            ValueFromPipeline = $False;
            HelpMessage = 'The vSphere Cluster Name'
        }
        $vSphereClusterAttribute = New-Object System.Management.Automation.ParameterAttribute -Property $vSphereClusterAttributeProperty

        $vSphereClusterValidateSet = Get-Cluster | Select-Object -ExpandProperty Name
        $vSphereClusterValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($vSphereClusterValidateSet)

        $vSphereClusterAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $vSphereClusterAttributeCollection.Add($vSphereClusterAttribute)
        $vSphereClusterAttributeCollection.Add($vSphereClusterValidateSetAttribute)

        $vSphereClusterRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($vSphereClusterName, [string], $vSphereClusterAttributeCollection)

        # NetApp vServer parameter
        $NetAppVserverName = 'NetAppVserver'
        $NetAppVserverAttributeProperty = @{
            Mandatory = $true;
            ValueFromPipeline = $False;
            HelpMessage = 'The NetApp Vserver Name'
        }
        $NetAppVserverAttribute = New-Object System.Management.Automation.ParameterAttribute -Property $NetAppVserverAttributeProperty

        $NetAppVserverValidateSet = (Get-NcVserver).where({$_.VserverType -eq "data"}) | Select-Object -ExpandProperty Vserver
        $NetAppVserverValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($NetAppVserverValidateSet)

        $NetAppVserverAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $NetAppVserverAttributeCollection.Add($NetAppVserverAttribute)
        $NetAppVserverAttributeCollection.Add($NetAppVserverValidateSetAttribute)

        $NetAppVserverRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($NetAppVserverName, [string], $NetAppVserverAttributeCollection)

        # NetApp Aggregate parameter
        $NetAppAggregateName = 'NetAppAggregate'
        $NetAppAggregateAttributeProperty = @{
            Mandatory = $true;
            ValueFromPipeline = $False;
            HelpMessage = 'The NetApp Aggregate Name'
        }
        $NetAppAggregateAttribute = New-Object System.Management.Automation.ParameterAttribute -Property $NetAppAggregateAttributeProperty

        $NetAppAggregateValidateSet = Get-NcAggr | Select-Object -ExpandProperty Name
        $NetAppAggregateValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($NetAppAggregateValidateSet)

        $NetAppAggregateAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $NetAppAggregateAttributeCollection.Add($NetAppAggregateAttribute)
        $NetAppAggregateAttributeCollection.Add($NetAppAggregateValidateSetAttribute)

        $NetAppAggregateRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($NetAppAggregateName, [string], $NetAppAggregateAttributeCollection)

        # NetApp Interface parameter
        $NetAppInterfaceName = 'NetAppInterface'
        $NetAppInterfaceAttributeProperty = @{
            Mandatory = $true;
            ValueFromPipeline = $False;
            HelpMessage = 'The NetApp Aggregate Name'
        }
        $NetAppInterfaceAttribute = New-Object System.Management.Automation.ParameterAttribute -Property $NetAppInterfaceAttributeProperty

        $NetAppInterfaceValidateSet = (Get-NcNetInterface).where({$_.FirewallPolicy -eq "data"}) | Select-Object -ExpandProperty InterfaceName
        $NetAppInterfaceValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($NetAppInterfaceValidateSet)

        $NetAppInterfaceAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $NetAppInterfaceAttributeCollection.Add($NetAppInterfaceAttribute)
        $NetAppInterfaceAttributeCollection.Add($NetAppInterfaceValidateSetAttribute)

        $NetAppInterfaceRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($NetAppInterfaceName, [string], $NetAppInterfaceAttributeCollection)

        # NetApp SnapShot Policy parameter
        $NetAppSnapshotPolicyName = 'NetAppSnapshotPolicy'
        $NetAppSnapshotPolicyAttributeProperty = @{
            Mandatory = $true;
            ValueFromPipeline = $False;
            HelpMessage = 'The NetApp Aggregate Name'
        }
        $NetAppSnapshotPolicyAttribute = New-Object System.Management.Automation.ParameterAttribute -Property $NetAppSnapshotPolicyAttributeProperty

        $NetAppSnapshotPolicyValidateSet = (Get-NcSnapshotPolicy).where({$_.Enabled -eq "True"}) | Select-Object -ExpandProperty Policy
        $NetAppSnapshotPolicyValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($NetAppSnapshotPolicyValidateSet)

        $NetAppSnapshotPolicyAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $NetAppSnapshotPolicyAttributeCollection.Add($NetAppSnapshotPolicyAttribute)
        $NetAppSnapshotPolicyAttributeCollection.Add($NetAppSnapshotPolicyValidateSetAttribute)

        $NetAppSnapshotPolicyRuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($NetAppSnapshotPolicyName, [string], $NetAppSnapshotPolicyAttributeCollection)

        # Create and return parameter dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParameterDictionary.Add($vSphereClusterName, $vSphereClusterRuntimeParameter)
        $RuntimeParameterDictionary.Add($NetAppAggregateName, $NetAppAggregateRuntimeParameter)
        $RuntimeParameterDictionary.Add($NetAppVserverName, $NetAppVserverRuntimeParameter)
        $RuntimeParameterDictionary.Add($NetAppInterfaceName, $NetAppInterfaceRuntimeParameter)
        $RuntimeParameterDictionary.Add($NetAppSnapshotPolicyName, $NetAppSnapshotPolicyRuntimeParameter)

        $RuntimeParameterDictionary
    }

    Begin {

        # Assign DynamicParams to actual variables
        $vSphereClusterName = $PsBoundParameters[$vSphereClusterName]
        $NetAppAggregateName = $PsBoundParameters[$NetAppAggregateName]
        $NetAppVserverName = $PsBoundParameters[$NetAppVserverName]
        $NetAppInterfaceName = $PsBoundParameters[$NetAppInterfaceName]

        # Get real objects from parameters
        try {
            $vSphereCluster = Get-Cluster -Name $vSphereClusterName -Debug:$False
        }catch{ Throw "Failed to get Cluster" }

        try {
            $NetAppAggr = Get-NcAggr -Name $NetAppAggregateName
        }catch{ Throw "Failed to get NetApp Aggr" }

        try {
            $NetAppVserver = Get-NcVserver -Name $NetAppVserverName
        }catch{ Throw "Failed to get NetApp vServer (SVM)" }

        try {
            $NetAppInterface = Get-NcNetInterface -Name $NetAppInterfaceName
        }catch{ Throw "Failed to get NetApp Interface)" }

        try {
            $NetAppSnapshotPolicy = Get-NcSnapshotPolicy -Name $NetAppSnapshotPolicyName
        }catch{ Throw "Failed to get NetApp Snapshot Policy)" }

        if ($DebugPreference -eq "Inquire") {
                "vSphere Cluster:"
                $vSphereCluster | Format-Table -Autosize
                "NetApp Aggregate:"
                $NetAppAggr | Format-Table -Autosize
                "NetApp Vserver (SVM):"
                $NetAppVserver | Format-Table -Autosize
                "NetApp Interface:"
                $NetAppInterface | Format-Table -Autosize
                "NetApp Snapshot Policy:"
                $NetAppSnapshotPolicy | Format-Table -Autosize

        }

        $VolSizeByte = $VolSize * 130023424

    }

    Process {

        $IPs = ($vSphereCluster | Get-VMHost | Get-VMHostNetworkAdapter -VMKernel).IP
        $ClientMatch = $IPs -join ","

        if(!(Get-NcExportPolicy -Name $vSphereCluster.Name -VserverContext $NetAppVserver )){
            "Create new NetApp Export Policy '$($vSphereCluster.Name)' on SVM '$($NetAppVserver.Name)' ..."
            $NetAppExportPolicy = New-NcExportPolicy -Name $vSphereCluster.Name -VserverContext $NetAppVserver
            $NetAppExportRule = New-NcExportRule -VserverContext $NetAppVserver  -Policy $NetAppExportPolicy.PolicyName -ClientMatch $ClientMatch `
            -Protocol NFS -Index 1 -SuperUserSecurityFlavor any -ReadOnlySecurityFlavor any -ReadWriteSecurityFlavor any
        }else{"NetApp Export Policy '$($vSphereCluster.Name)' on SVM '$($NetAppVserver.Name)' aleady exists"}

        "Create new NetApp Volume '$VolName' on Aggregate '$($NetAppAggr.AggregateName)' ..."
        $NetAppVolume = New-NcVol -VserverContext $NetAppVserver -Name $VolName -Aggregate $NetAppAggr.AggregateName -JunctionPath $("/" + $VolName) `
        -ExportPolicy $vSphereCluster.Name -Size $VolSizeByte -SnapshotReserve 20 -SnapshotPolicy $NetAppSnapshotPolicy.Policy

        "Set Advanced Options for NetApp Volume '$VolName' ..."
        $NetAppVolume | Set-NcVolOption -Key fractional_reserve -Value 0
        $NetAppVolume | Set-NcVolOption -Key guarantee -Value none
        $NetAppVolume | Set-NcVolOption -key no_atime_update -Value on

        $VMHosts = $vSphereCluster | Get-VMHost
        ForEach ($VMHost in $VMHosts) {
            "Add new NetApp Datastore '$($NetAppVolume.Name)' to ESXi Host '$($VMHost.Name)' ..."
            $NewDatastore = $VMHost | New-Datastore -Nfs -Name $NetAppVolume.Name  -Path $("/" + $NetAppVolume.Name) -NfsHost $NetAppInterface.Address
        }

    }

}
