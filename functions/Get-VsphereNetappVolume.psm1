function Get-VsphereNetappVolume {
    <#
    .DESCRIPTION
        Get vSphere Datastore to NetApp Volume mapping

    .NOTES
        File Name  : Get-VsphereNetappVolume.psm1
        Author     : Markus Kraus
        Version    : 1.0
        State      : Ready

    .LINK
        https://mycloudrevolution.com/

    .EXAMPLE
        Get-VsphereNetappVolume -vSphereDatastore $myDatastore

    .PARAMETER Datastore
        vSphere Datastore Object

    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, HelpMessage="vSphere Datastore Object")]
        [ValidateNotNullorEmpty()]
            [VMware.VimAutomation.ViCore.Impl.V1.DatastoreManagement.DatastoreImpl]$Datastore
    )
    Begin{
        [Array]$NetAppInterfaces = (Get-NcNetInterface).Where({$_.DataProtocols -eq "nfs"})
        [Array]$NetAppVolumes = Get-NcVol
        $MyView = @()
    }
    Process {

        $DatastoreReport = [PSCustomObject] @{
                                Datastore = $Datastore.Name
                                RemoteHost = $Datastore.RemoteHost
                                RemotePath = $Datastore.RemotePath
                                NetAppInterface = ($NetAppInterfaces.Where({$_.Address -eq $Datastore.RemoteHost})).InterfaceName
                                NetAppSVM = ($NetAppInterfaces.Where({$_.Address -eq $Datastore.RemoteHost})).Vserver
                                NetAppVolume = ($NetAppVolumes.Where({$_.JunctionPath -eq $Datastore.RemotePath})).name
                                NetAppVolumeSnapshotPolicy = ($NetAppVolumes.Where({$_.JunctionPath -eq $Datastore.RemotePath})).VolumeSnapshotAttributes.SnapshotPolicy
        }
        $MyView += $DatastoreReport


    }
    End{
        $MyView
    }

}
