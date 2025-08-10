B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: false
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
Private xui As XUI
	Private loadingTimer As Timer
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private ImageView1 As ImageView
	Private ImageView2 As ImageView
	Private ImageView3 As ImageView
	Private ImageView4 As ImageView
	Private loadingStep As Int = 0
	Private ImageView5 As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("loadingscreen")
	
	ImageView1.Bitmap = LoadBitmap(File.DirAssets, "zumbie.png")
	ImageView2.Bitmap = LoadBitmap(File.DirAssets, "human.png")
	ImageView3.Bitmap = LoadBitmap(File.DirAssets, "zumbie.png")
	ImageView4.Bitmap = LoadBitmap(File.DirAssets, "human.png")
	ImageView5.Bitmap = LoadBitmap(File.DirAssets, "title.png")
	
	
	Dim bg As Bitmap
	bg = LoadBitmap(File.DirAssets, "bgmain.jpg") ' or .png
	Activity.SetBackgroundImage(bg)
	
	
	ImageView1.Visible = False
	ImageView2.Visible = False
	ImageView3.Visible = False
	ImageView4.Visible = False

loadingTimer.initialize("loadingTimer", 1300)
loadingTimer.Enabled = True
End Sub

Sub Activity_Resume

End Sub

Sub loadingTimer_Tick
	loadingStep = loadingStep + 1
	
	Select loadingStep
		Case 1
			ImageView1.Visible = True
		Case 2
			ImageView2.Visible = True
			ImageView1.Visible = False
		Case 3 
			ImageView3.Visible = True
			ImageView2.Visible = False
		Case 4 
			ImageView4.Visible = True
			ImageView3.Visible = False
		Case 5
			loadingTimer.Enabled = False
			StartActivity(Main)
			Activity.Finish
	End Select
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
