'
' VBScript example
' Example of page object structure
'

Dim Driver, Assert, Waiter, Keys
Dim PageHome, PageLogin, PageResult

Sub Main
  ' Open login page
  PageHome.Go _
          .ClickLogin
  
  ' Type credentials
  Assert.Equals "Log in", PageLogin.Header
  PageLogin.LoginAs "name", "password"
  Assert.Matches "^Login error", PageLogin.ErrorMessage
  
  ' Search content
  PageHome.Go _
          .Search "Eiffel tower"
  Assert.Equals "Eiffel Tower", PageResult.Header
  
  Set PageHome = Nothing
End Sub

'##### Pages ##################################################################

Const PH_URL = "https://en.wikipedia.org/wiki/Main_Page"
Const PH_ID_FIELD_SEARCH = "searchInput"
Const PH_CSS_LINK_LOGIN = "#pt-login a"

Class PageHomeClass
  Sub Class_Initialize()
    'Driver.SetPreference "key", "value"
  End Sub

  Sub Class_Terminate()
    'Stop the browser when this class is set to nothing
    Driver.Quit
  End Sub

  Public Function Go()
    Driver.Get PH_URL
    Set Go = Me
  End Function

  Public Function Search(text)
    Driver.FindElementById(PH_ID_FIELD_SEARCH) _
          .SendKeys(text) _
          .Submit
    Set Search = Me
  End Function

  Public Function ClickLogin()
    Driver.FindElementByCss(PH_CSS_LINK_LOGIN) _
          .Click
    Set ClickLogin = Me
  End Function
End Class


Const PL_URL = "https://en.wikipedia.org/w/index.php?title=Special:UserLogin"
Const PL_ID_TEXT_HEADER = "firstHeading"
Const PL_ID_FIELD_USERNAME = "wpName1"
Const PL_ID_FIELD_PASSWORD = "wpPassword1"
Const PL_ID_BUTTON_SUBMIT = "wpLoginAttempt"
Const PL_CSS_TEXT_ERROR = ".errorbox"

Class PageLoginClass
  Public Function Go()
    Driver.Get PL_url
    Set Go = Me
  End Function

  Public Property Get Header()
    Header = Driver.FindElementById(PL_ID_TEXT_HEADER).text
  End Property

  Public Function LoginAs(username, password)
    Driver.FindElementById(PL_ID_FIELD_USERNAME).SendKeys username
    Driver.FindElementById(PL_ID_FIELD_PASSWORD).Click password
    Driver.FindElementById(PL_ID_BUTTON_SUBMIT).Click
    Set LoginAs = Me
  End Function

  Public Property Get ErrorMessage()
    Set ele = Driver.FindElementByCss(PL_CSS_TEXT_ERROR)
    ErrorMessage = ele.text
  End Property
End Class


Const PR_ID_TEXT_HEADER = "firstHeading"

Class PageResultClass
  Public Property Get Header()
    Header = Driver.FindElementById(PR_ID_TEXT_HEADER).text
  End Property
End Class


'##### Global objects  ########################################################

Set Driver = CreateObject("Selenium.FirefoxDriver")
Set Assert = CreateObject("Selenium.Assert")
Set Waiter = CreateObject("Selenium.Waiter")
Set Keys = CreateObject("Selenium.Keys")

Set PageHome = New PageHomeClass
Set PageLogin = New PageLoginClass
Set PageResult = New PageResultClass

Call Main
