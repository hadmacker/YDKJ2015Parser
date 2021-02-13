# https://stackoverflow.com/a/24795477
# https://devblogs.microsoft.com/scripting/use-powershell-to-parse-an-xml-file-and-sort-the-data/
# https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.1
# https://adamtheautomator.com/powershell-parse-xml/
# https://devblogs.microsoft.com/scripting/playing-with-json-and-powershell/
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-json?view=powershell-7.1
# https://www.sqlshack.com/powershell-split-a-string-into-an-array/

$episodes = Select-Xml -path .\episodelist.jet -XPath '/resources/string-array/item'
$objEpisodes = @()
foreach($episode in $episodes) {
     $ep = Read-Episode -EpisodeId $episode.Node.id -EpisodeName $episode.Node.mystring
     $objEpisodes += $ep
}
ConvertTo-Json $objEpisodes -Depth 5 | Out-File .\episodeConversion.json

function Read-Episode {

    param (
        $EpisodeId,
        $EpisodeName
    )

    $objEpisode = New-Object -TypeName PSObject
    $objEpisode | Add-Member -MemberType NoteProperty -Name EpisodeId -Value $EpisodeId
    $objEpisode | Add-Member -MemberType NoteProperty -Name EpisodeName -Value $EpisodeName

    Write-Host ("{0}: {1}" -f $EpisodeId, $EpisodeName)

    $episodeFolder = ".\episodes\{0}" -f $EpisodeId
    $episodeDataPath = "{0}\data.jet" -f $episodeFolder

    $data = Get-Content $episodeDataPath | ConvertFrom-Json | select -expand fields | select v, t, n

    $questionValue = ""
    foreach($d in $data) {
        if ( $d.n -eq "tQuestions" ) {
            $questionValue = $d.v
            $objEpisode | Add-Member -MemberType NoteProperty -Name QuestionList -Value $questionValue -Force
        }

        if ( $d.n -eq "tTypes" ) {
           $typesValue = $d.v
           $objEpisode | Add-Member -MemberType NoteProperty -Name QuestionTypes -Value $typesValue -Force
        }

        if ( $d.n -eq "aIntro" ) {
           $objEpisode | Add-Member -MemberType NoteProperty -Name Intro -Value $d.v -Force
        }

        if ( $d.n -eq "aSponsor" ) {
           $objEpisode | Add-Member -MemberType NoteProperty -Name Sponsor -Value $d.v -Force
        }
    }

    $questions = $questionValue.Split(",")
    $questionTypes = $typesValue.Split(",") 
    $i = 0

    $objQuestionsArr = @()

    foreach($question in $questions) {
        $i = $i + 1
        $questionFolder = ".\questions\{0}" -f $question
        $questionDataPath = "{0}\data.jet" -f $questionFolder

        $questionData = Get-Content $questionDataPath | ConvertFrom-Json | select -expand fields | select v, t, n

        $objQuestion = New-Object -TypeName PSObject
        $objQuestion | Add-Member -MemberType NoteProperty -Name Ordinal -Value $i
        $objQuestion | Add-Member -MemberType NoteProperty -Name Id -Value $question

        $answers = @()

        if ( $questionTypes[$i-1] -eq 1 ) {
            $objQuestion | Add-Member -MemberType NoteProperty -Name QuestionType -Value "Multiple Choice" -Force
        } elseif ( $questionTypes[$i-1] -eq 2 ) {
            $objQuestion | Add-Member -MemberType NoteProperty -Name QuestionType -Value "Dis or Dat" -Force
        } elseif ( $questionTypes[$i-1] -eq 3 ) {
            $objQuestion | Add-Member -MemberType NoteProperty -Name QuestionType -Value "Match" -Force
        }

        foreach($qd in $questionData) {
            if ( $qd.n -eq "tSubject" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Subject -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ1" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q1 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ2" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q2 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ3" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q3 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ4" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q4 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ5" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q5 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ6" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q6 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ7" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q7 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ8" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q8 -Value $qd.v -Force
            } elseif ( $qd.n -eq "tQ9" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Q9 -Value $qd.v -Force
            } elseif ($qd.n -eq "tCat" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Category -Value $qd.v -Force
            } elseif ($qd.n -eq "tDat" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Dat -Value $qd.v -Force
            } elseif ($qd.n -eq "tDatButton" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name DatButton -Value $qd.v -Force
            } elseif ($qd.n -eq "tDis" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Dis -Value $qd.v -Force
            } elseif ($qd.n -eq "tDisButton" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name DisButton -Value $qd.v -Force
            } elseif ($qd.n -eq "tMatches" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Matches -Value $qd.v -Force
            } elseif ($qd.n -eq "tQuestions" ) {
                $objQuestion | Add-Member -MemberType NoteProperty -Name Questions -Value $qd.v -Force
            } elseif ($qd.n -eq "tMCOrder" ) {
            } elseif ($qd.n.StartsWith("a")) {
            } elseif ($qd.n.StartsWith("$")) {
            } elseif ($qd.n.StartsWith("n")) {
            } elseif ($qd.n.StartsWith("b")) {
            } elseif ($qd.n.StartsWith("g")) {
            } else {
                $answers += $qd.v
            }
        }

        $answers = $answers | Sort-Object | Get-Unique

        $objQuestion | Add-Member -MemberType NoteProperty -Name Answers -Value $answers

        $objQuestionsArr += $objQuestion
    }
    $objEpisode | Add-Member -MemberType NoteProperty -Name Questions -Value $objQuestionsArr

    return $objEpisode
}