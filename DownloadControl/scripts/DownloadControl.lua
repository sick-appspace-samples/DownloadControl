--[[----------------------------------------------------------------------------

  Application Name:
  DownloadControl

  Summary:
  Using the Download Control available as a UI-Builder Control Package.


  Description:
  The sample provides "Download"functionality for certain files
  (e.g. text- or image-files) via the HMI (webpage). The Download Control is a
  button upon which a specified file can be downloaded from within the UI.
  The msdd of this sample already contains the required package. If it should be
  used in another App, the Package must be imported with the import package dialog
  within the UI-Builder. The package itself can be found at the support portal or
  can be extracted from this Apps msdd.

  How to run:
  Starting the App and opening the device webpage. There it can be chosen which file
  (picture- or text file) should be downloaded (via Dropdown menu = standard control).
  After clicking on the "Download"-button, the chosen file will be downloaded.
  The available sample files for download are stored in the "resources" directory/component
  of this App.

  More Information:
  Information about importing control packages can be found in the ControlPackage
  tutorial
------------------------------------------------------------------------------]]

-- luacheck: globals gGetPictureFile gGetPictureFileDropDownSelection gSetPictureSelection gOnPictureFilename
-- luacheck: globals gGetTextFileDropDownSelection gSetTextSelection gGetTextFile

---------------------------
--SERVE FUNCTIONS / EVENTS
---------------------------

-- Serves for the Picture selection
Script.serveFunction( 'DownloadControl.getPictureFile', 'gGetPictureFile', '', 'binary' )
Script.serveFunction( 'DownloadControl.getPictureFileDropDownSelection',
                      'gGetPictureFileDropDownSelection', '', 'string' )
Script.serveFunction( 'DownloadControl.setPictureSelection', 'gSetPictureSelection', 'string' )

Script.serveEvent( 'DownloadControl.OnPictureFilename', 'gOnPictureFilename', 'string' )

-- Serves for the Text File selection
Script.serveFunction('DownloadControl.getTextFile', 'gGetTextFile', '', 'binary')
Script.serveFunction( 'DownloadControl.getTextFileDropDownSelection', 'gGetTextFileDropDownSelection', '', 'string' )
Script.serveFunction( 'DownloadControl.setTextSelection', 'gSetTextSelection', 'string' )
Script.serveEvent('DownloadControl.OnTextFilename', 'OnTextFilename', 'string')

-------------------------------------------------------------
--LOCAL CONSTANTS / VARIABLES
-------------------------------------------------------------

local currPictureFilename = ''
local currTextFilename = ''

local DIR_PICTURES = 'resources/Pictures/'
local DIR_TEXTFILES = 'resources/Textfiles/'

---------------------------
--FUNCTIONS
---------------------------

-----------------------------------------
--binding: picture files
-----------------------------------------

function gSetPictureSelection(filename)
  currPictureFilename = filename
end

------------------------------------------------------------------------------------------------------------------------

function gGetPictureFileDropDownSelection()
  local list = File.list(DIR_PICTURES)

  local jsonStr = '['

  for _, v in pairs(list) do
    jsonStr = jsonStr .. '{"label":"' .. v .. '","value":"' .. v .. '"},'
  end

  jsonStr = jsonStr:sub(1, -2) --delete last comma
  jsonStr = jsonStr .. ']'

  --Ensures that the first file, shown in the drop down menu, is preselected
  gSetPictureSelection(list[1])

  return jsonStr
end

------------------------------------------------------------------------------------------------------------------------

function gGetPictureFile()
  Script.notifyEvent('gOnPictureFilename', currPictureFilename) --file name as it downloaded

  local completeFileName = DIR_PICTURES .. currPictureFilename

  local filehandle = File.open(completeFileName, 'rb') -- we has to use "binary" mode for image files

  local data = File.read(filehandle)

  File.close(filehandle)

  return data
end

-----------------------------------------
--binding: text files
-----------------------------------------

function gSetTextSelection(filename)
  currTextFilename = filename
end

------------------------------------------------------------------------------------------------------------------------

function gGetTextFileDropDownSelection()
  local list = File.list(DIR_TEXTFILES)

  local jsonStr = '['

  for _, v in pairs(list) do
    jsonStr = jsonStr .. '{"label":"' .. v .. '","value":"' .. v .. '"},'
  end

  jsonStr = jsonStr:sub(1, -2) --delete last comma
  jsonStr = jsonStr .. ']'

  --Ensures that the first file, shown in the drop down menu, is preselected
  gSetTextSelection(list[1])

  return jsonStr
end

------------------------------------------------------------------------------------------------------------------------

function gGetTextFile()
  Script.notifyEvent('OnTextFilename', currTextFilename) --file name as downloaded
  local completeFileName = DIR_TEXTFILES .. currTextFilename

  local filehandle = File.open(completeFileName, 'r')
  local data = File.read(filehandle)

  File.close(filehandle)

  return data
end
