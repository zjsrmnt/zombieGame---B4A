B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: false
#End Region

Sub Process_Globals
	Public difficulty As String
	Private gameTimer As Timer
	Private score As Int
	Private spawnInterval As Int
	Private lives As Int
	Private gameStartTime As Long
	Private gameActive As Boolean
End Sub

Sub Globals
	Private zombieImg As ImageView
	Private personImg As ImageView
	Private scoreLabel As Label
	Private difficultyLabel As Label
	Private imgLife1 As ImageView
	Private imgLife2 As ImageView
	Private imgLife3 As ImageView
	Private pnlSpawnArea As Panel

	Private zombieMissed As Boolean
	Private consecutiveHits As Int
	Private difficultyMultiplier As Float

	Private btnExit As ImageView
	Private btnChangeDifficulty As ImageView
	Private lblFinalScore As Label
	Private pnlGameOver As Panel
	
	Private ImageView1 As ImageView
	Private ImageView2 As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("Game")

	zombieImg.Bitmap = LoadBitmap(File.DirAssets, "zumbie.png")
	personImg.Bitmap = LoadBitmap(File.DirAssets, "human.png")
	imgLife1.Bitmap = LoadBitmap(File.DirAssets, "zomHeart.png")
	imgLife2.Bitmap = LoadBitmap(File.DirAssets, "zomHeart.png")
	imgLife3.Bitmap = LoadBitmap(File.DirAssets, "zomHeart.png")
	
	ImageView1.Bitmap = LoadBitmap(File.DirAssets, "bgScore.png")
	ImageView2.Bitmap = LoadBitmap(File.DirAssets, "bgScore.png")
	
	difficultyLabel.Typeface = Typeface.LoadFromAssets("ARCADECLASSIC.TTF")
	lblFinalScore.Typeface = Typeface.LoadFromAssets("ARCADECLASSIC.TTF")
	scoreLabel.Typeface = Typeface.LoadFromAssets("ARCADECLASSIC.TTF")
	
	pnlGameOver.SetBackgroundImage(LoadBitmap(File.DirAssets, "game_over.png"))
	btnChangeDifficulty.SetBackgroundImage(LoadBitmap(File.DirAssets, "retry.png"))
	btnExit.SetBackgroundImage(LoadBitmap(File.DirAssets, "return.png"))
	
	pnlSpawnArea.SetBackgroundImage(LoadBitmap(File.DirAssets, "cement.png"))
	
	Dim bg As Bitmap
	bg = LoadBitmap(File.DirAssets, "bgmain.jpg") ' or .png
	Activity.SetBackgroundImage(bg)
	
	If pnlGameOver.IsInitialized Then pnlGameOver.Visible = False ' <<< ADD THIS EARLY

	difficulty = Main.difficulty
	InitializeGame
End Sub


Sub InitializeGame
	lives = 3
	score = 0
	consecutiveHits = 0
	gameStartTime = DateTime.Now
	gameActive = True
	zombieMissed = False

	zombieImg.Visible = False
	personImg.Visible = False
	zombieImg.Enabled = True
	personImg.Enabled = True

	imgLife1.Visible = True
	imgLife2.Visible = True
	imgLife3.Visible = True
	scoreLabel.Text = "Score: 0"

	If pnlGameOver.IsInitialized Then pnlGameOver.Visible = False

	If gameTimer.IsInitialized Then gameTimer.Enabled = False

	Select difficulty
		Case "Easy"
			spawnInterval = 1500
			difficultyMultiplier = 1.0
		Case "Normal"
			spawnInterval = 1000
			difficultyMultiplier = 1.5
		Case "Hard"
			spawnInterval = 700
			difficultyMultiplier = 2.0
		Case Else
			spawnInterval = 2000
			difficultyMultiplier = 1.0
	End Select

	If difficultyLabel.IsInitialized Then difficultyLabel.Text = "Difficulty: " & difficulty

	gameTimer.Initialize("gameTimer", spawnInterval)
	gameTimer.Enabled = True

	ToastMessageShow("Starting " & difficulty & " mode", False)
End Sub

Sub gameTimer_Tick
	If Not(gameActive) Then Return

	Dim showZombie As Boolean = Rnd(0, 2) = 0
	Dim imageSize As Int = Min(pnlSpawnArea.Width / 5, pnlSpawnArea.Height / 5)
	zombieImg.Width = imageSize
	zombieImg.Height = imageSize
	personImg.Width = imageSize
	personImg.Height = imageSize

	Dim maxX As Int = Max(0, pnlSpawnArea.Width - zombieImg.Width)
	Dim maxY As Int = Max(0, pnlSpawnArea.Height - zombieImg.Height)

	If zombieImg.Visible And zombieMissed Then
		lives = lives - 1
		consecutiveHits = 0
		UpdateLives
		ToastMessageShow("Zombie escaped! Lives: " & lives, False)
	End If

	zombieMissed = True

	If showZombie Then
		zombieImg.Left = Rnd(0, maxX + 1)
		zombieImg.Top = Rnd(0, maxY + 1)
		zombieImg.Visible = True
		personImg.Visible = False
	Else
		personImg.Left = Rnd(0, maxX + 1)
		personImg.Top = Rnd(0, maxY + 1)
		personImg.Visible = True
		zombieImg.Visible = False
		zombieMissed = False
	End If
End Sub

Sub zombieImg_Click
	If Not(gameActive) Then Return

	consecutiveHits = consecutiveHits + 1
	Dim pointsEarned As Int = 1
	If consecutiveHits >= 3 Then
		pointsEarned = pointsEarned + 1
		ToastMessageShow("Combo x" & consecutiveHits & "! +" & pointsEarned & " points", False)
	End If
	pointsEarned = pointsEarned * difficultyMultiplier
	score = score + pointsEarned
	scoreLabel.Text = "Score: " & score

	zombieImg.Visible = False
	zombieMissed = False
End Sub

Sub personImg_Click
	If Not(gameActive) Then Return

	lives = lives - 1
	consecutiveHits = 0
	UpdateLives
	personImg.Visible = False
	ToastMessageShow("Don't hit humans! Lives: " & lives, True)
End Sub

Sub UpdateLives
	Select lives
		Case 2
			imgLife3.Visible = False
		Case 1
			imgLife2.Visible = False
		Case 0
			imgLife1.Visible = False
			GameOver
	End Select
End Sub

Sub GameOver
	gameActive = False
	gameTimer.Enabled = False

	Dim gameDuration As Long = (DateTime.Now - gameStartTime) / 1000

	pnlSpawnArea.Visible = False
	zombieImg.Visible = False
	personImg.Visible = False
	scoreLabel.Visible = False
	difficultyLabel.Visible = False
	ImageView1.Visible = False
	ImageView2.Visible = False

	' Show game over screen first
	ShowGameOverScreen(gameDuration)
	
	' Then update the score in the background
End Sub

Sub ShowGameOverScreen(gameDuration As Long)
	If lblFinalScore.IsInitialized Then
		lblFinalScore.Text = "GAME OVER" & CRLF & CRLF & _
							 "SCORE: " & score & CRLF & _
							 "TIME: " & gameDuration & " seconds" & CRLF & _
							 "DIFFICULTY: " & difficulty & CRLF
	End If

	

	If pnlGameOver.IsInitialized Then
		pnlGameOver.Visible = True
	End If
End Sub

Sub btnChangeDifficulty_Click
	If pnlGameOver.IsInitialized Then pnlGameOver.Visible = False
	
	pnlSpawnArea.Visible = True
	difficultyLabel.Visible = True
	scoreLabel.Visible = True
	ImageView1.Visible = True
	ImageView2.Visible = True
	
	InitializeGame
End Sub

Sub btnExit_Click
	gameActive = False
	gameTimer.Enabled = False

	If Main.username <> "" Then
		Dim finalScore As Int = score
		Log("Sending score to leaderboard from Exit button: " & finalScore)
		CallSubDelayed2(Main, "UpdateScoreInLeaderboard", finalScore)
	End If

	CallSub2(Main, "SetReturnPanel", "start")
	Main.returningFromGameOver = True
	StartActivity(Main)
	Activity.Finish
End Sub



Sub Activity_Pause(UserClosed As Boolean)
	If gameTimer.IsInitialized Then gameTimer.Enabled = False
	
End Sub

Sub Activity_Resume
	If gameActive And gameTimer.IsInitialized Then
		gameTimer.Enabled = True
	End If
End Sub

Sub Activity_KeyPress(KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		gameActive = False
		gameTimer.Enabled = False
		CallSub2(Main, "SetReturnPanel", "start")
		Main.returningFromGameOver = True 
		StartActivity(Main)
		Activity.Finish
		Return True
	End If
	Return False
End Sub