 <#
.SYNOPSIS
    Execute Get-FileHash on all selected files.

.DESCRIPTION
    Execute Get-FileHash on all selected files.

.PARAMETER Path
    Enter desired file path(s).
    Default allows selection from Windows Explorer.

.PARAMETER Algorithm
    Set hash algorithm(s). 
    Supports: MD5, SHA1, SHA256, SHA384, SHA512, MACTripleDES, RIPEMD160
    Default SHA256

.EXAMPLE
    .\Get-FileHash
    Generates SHA256 (default) file hashes for selected file(s).

.EXAMPLE
    .\Get-FileHash -Algorithm SHA1, RIPEMD160, MD5
    Generates SHA1, RIPEMD160, and MD5 file hashes for selected file(s).

.EXAMPLE
    .\Get-FileHash -Path '\\NetworkShare\Foo\Bar\file.txt', 'C:\SomeDir\file.docx'
    Generates SHA256 (default) file hashes for [\\NetworkShare\Foo\Bar\file.txt] and [C:\SomeDir\file.docx].

.NOTES
    Author: JBear
    Date: 11/1/2017
#>

param(

    [Parameter(ValueFromPipeline=$true,HelpMessage="Enter desired file path(s)")]
    [String[]]$Path = $null,

    [Parameter(ValueFromPipeline=$true,HelpMessage="Enter file hash algorithm(s) (MD5, SHA1,SHA256, SHA384, SHA512, MACTripleDES, RIPEMD160)")]
    [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512", "MACTripleDES", "RIPEMD160")]
    [String[]]$Algorithm = 'SHA256'
)

if($Path -eq $null) {

    Add-Type -AssemblyName System.Windows.Forms

    #Build object for Windows Explorer selection
    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.Title = "Select File(s) to Hash"
    $Dialog.Filter = "All Files (*.*)|*.*"        
    $Dialog.Multiselect=$true
    $Result = $Dialog.ShowDialog()

    #Select OK
    if($Result -eq 'OK') {

        Try {
        
            $Path = $Dialog.FileNames
        }

        Catch {

            $Path = $null
	        Break
        }
    }

    #Select Cancel
    else {

        #Shows upon cancellation of Save Menu
        Write-Host -ForegroundColor Yellow "`nNotice: No file(s) selected for hash."
        Break
    }
}

#Generate file hash
$Path | ForEach-Object {

    foreach($Hash in $Algorithm) {

        Get-FileHash -Path $_ -Algorithm $Hash
    }
} 
