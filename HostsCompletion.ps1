# complete host names

function TabExpansion2 {
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    Param(
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
        [string] $inputScript,

        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
        [int] $cursorColumn,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
        [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
        [HashTable] $options = $null
    )

    End
    {
        $result = $null
        if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet') {
            $result = [Management.Automation.CommandCompletion]::CompleteInput(
                <#inputScript#>  $inputScript,
                <#cursorColumn#> $cursorColumn,
                <#options#>      $options
            )
        } else {
            $result = [Management.Automation.CommandCompletion]::CompleteInput(
                <#ast#>              $ast,
                <#tokens#>           $tokens,
                <#positionOfCursor#> $positionOfCursor,
                <#options#>          $options
            )
        }

        if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet') {
            $ast = [System.Management.Automation.Language.Parser]::ParseInput(
                $inputScript, [ref] $tokens, [ref] $null
            )
        }

        $text = $ast.Extent.Text;
        $inputWords = $text.Split(' ');
        $inputFirstWord = $inputWords[0];
        $inputLastWord = $inputWords[$inputWords.Length - 1];
            
        $hostsFile = [System.io.File]::Open('C:\Windows\System32\drivers\etc\hosts', 'Open', 'Read');
        $hostsFileReader = New-Object System.IO.StreamReader($hostsFile);
                
        while (($line = $hostsFileReader.ReadLine()) -ne $null) {
            if ($line.StartsWith('#')) {
                # do nothing
            } else {
                $items = $line.Split(' ');
                $hostName = $items[1].Trim();

                $completionItem = New-Object Management.Automation.CompletionResult $hostName, $hostName, "Text", $hostName;

                if ($hostName.StartsWith($inputLastWord)) {
                    if ($inputFirstWord.StartsWith('ping')  -or
                        $inputFirstWord.StartsWith('route') -or
                        $inputFirstWord.StartsWith('ssh')   -or
                        $inputFirstWord.StartsWith('scp')   -or
                        $inputFirstWord.StartsWith('ftp')) {

                        $result.CompletionMatches.Insert(0, $completionItem);
                    } else {
                        # $result.CompletionMatches.Add($completionItem);
                    }
                }
            }
        }

        $hostsFileReader.Close();
        $hostsFile.Close();

        return $result
    }
}