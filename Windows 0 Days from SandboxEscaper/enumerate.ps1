
$aapsid = 'NT AUTHORITY\SYSTEM'

ForEach($file in (Get-ChildItem -recurse -Path 'C:\windows')) {
 
   $acl = Get-Acl -path $file.PSPath
   ForEach($ace in $acl.Access) {
      If(($ace.FileSystemRights -eq
           [Security.AccessControl.FileSystemRights]::FullControl) -and 
            $ace.IdentityReference.Value -in $aapsid) {
               Write-Output $file.PSPath
              
      }
        
   }
}
