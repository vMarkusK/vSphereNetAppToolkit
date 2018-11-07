---
external help file: Get-VsphereNetappVolume-help.xml
Module Name: vSphereNetAppToolkit
online version: https://mycloudrevolution.com/
schema: 2.0.0
---

# Get-VsphereNetappVolume

## SYNOPSIS

## SYNTAX

```
Get-VsphereNetappVolume [-Datastore] <DatastoreImpl> [<CommonParameters>]
```

## DESCRIPTION
Get vSphere Datastore to NetApp Volume mapping

## EXAMPLES

### EXAMPLE 1
```
Get-VsphereNetappVolume -vSphereDatastore $myDatastore
```

## PARAMETERS

### -Datastore
vSphere Datastore Object

```yaml
Type: DatastoreImpl
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
File Name  : Get-VsphereNetappVolume.psm1
Author     : Markus Kraus
Version    : 1.0
State      : Ready

## RELATED LINKS

[https://mycloudrevolution.com/](https://mycloudrevolution.com/)

