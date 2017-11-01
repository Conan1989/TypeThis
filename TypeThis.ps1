<# a quick'n'dirty keyboard macro
$SecondsDelay = time between pressing Enter on the command and typing beings
$millisecKeyInterval = time between each key press events. Some things (Java) freak out if you go too fast

https://blogs.technet.microsoft.com/heyscriptingguy/2011/01/10/provide-input-to-applications-with-powershell/
#>

Function funTypeThis
    {
        Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][ValidateScript({($PSItem).Length -gt 0})][String]$StringToTypeOut,
        [Parameter(Mandatory=$false,ValueFromPipeline=$false)][ValidateRange(1,90)][Int]$SecondsDelay = 3,
        [Parameter(Mandatory=$false,ValueFromPipeline=$false)][ValidateRange(1,100)][Int]$millisecKeyInterval = 10)
    
        Process
            {
                [void][System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
                [void][System.Reflection.Assembly]::LoadWithPartialName("'System.Windows.Forms")
        
                # https://technet.microsoft.com/en-us/library/ff731008.aspx
                $EscapeThese = ('+', '^', '%', '~', '(', ')', '{', '}')
        
                Start-Sleep -Seconds $SecondsDelay
                foreach ($i_Char in ($StringToTypeOut.ToCharArray()))
                    {
                        Switch ($EscapeThese -contains $i_Char)
                            {
                                $true {$ThingToType = "{$i_Char}"}
                                $false {$ThingToType = $i_Char}
                            }        
        
                        Start-Sleep -Milliseconds $millisecKeyInterval
                        [System.Windows.Forms.SendKeys]::SendWait($ThingToType)
                    }

                Return $true
            }
    }
