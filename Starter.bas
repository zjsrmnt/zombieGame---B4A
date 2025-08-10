B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.9
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	Public SQL As SQL
End Sub

Sub Service_Create
	If SQL.IsInitialized = False Then
		SQL.Initialize(File.DirInternal, "leaderboard.db", True)
		CreateLeaderboardTable
		CreateGameHistoryTable
	End If
End Sub

Sub CreateLeaderboardTable
	Try

		Dim query As String = "CREATE TABLE IF NOT EXISTS leaderboard (" & _
							  "username TEXT PRIMARY KEY, " & _
							  "total_score INTEGER DEFAULT 0, " & _
							  "highest_score INTEGER DEFAULT 0, " & _
							  "last_played TEXT)"
		SQL.ExecNonQuery(query)
		Log("Leaderboard table created/verified")
	Catch
		Log("Error creating leaderboard table: " & LastException.Message)
	End Try
End Sub


Sub CreateGameHistoryTable
	Dim createHistoryQuery As String = _
        "CREATE TABLE IF NOT EXISTS game_history (" & _
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " & _
        "username TEXT, " & _
        "score INTEGER, " & _
        "points_earned INTEGER, " & _
        "difficulty TEXT, " & _
        "played_date TEXT)"
	SQL.ExecNonQuery(createHistoryQuery)
	Log("Game history table created/verified in service")
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground
End Sub

Sub Service_TaskRemoved
End Sub

Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy
End Sub