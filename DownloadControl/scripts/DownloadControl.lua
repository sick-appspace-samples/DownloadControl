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

-------------------------------------------------------------
--LOCAL CONSTANTS / VARIABLES
-------------------------------------------------------------

local currPictureFilename = ''
local currTextFilename = ''

local ORIG_DIR_PICTURES = 'resources/Pictures/'
local ORIG_DIR_TEXTFILES = 'resources/Textfiles/'
local DIR_PICTURES = '/ram/Pictures/'
local DIR_TEXTFILES = '/ram/Textfiles/'


---------------------------
--RAM SETUP
---------------------------

if File.exists(DIR_PICTURES) then
  for _, f in pairs(File.list(DIR_PICTURES)) do
    File.del(DIR_PICTURES..f)
  end
else
  File.mkdir(DIR_PICTURES)
end

if File.exists(DIR_TEXTFILES) then
  for _, f in pairs(File.list(DIR_TEXTFILES)) do
    File.del(DIR_TEXTFILES..f)
  end
else
  File.mkdir(DIR_TEXTFILES)
end

---------------------------
--FUNCTIONS
---------------------------

-----------------------------------------
--binding: picture files
-----------------------------------------

local function setPictureFilename(filename)
  currPictureFilename = filename
  for _, f in pairs(File.list(DIR_PICTURES)) do
    File.del(DIR_PICTURES..f)
  end
  File.copy(ORIG_DIR_PICTURES..currPictureFilename, DIR_PICTURES..currPictureFilename)
  Script.notifyEvent("OnPictureFilename", currPictureFilename)
  Script.notifyEvent("OnPictureFullPath", DIR_PICTURES .. currPictureFilename)
end

------------------------------------------------------------------------------------------------------------------------


--@getPictureFilename():string
local function getPictureFilename()
  return currPictureFilename
end

------------------------------------------------------------------------------------------------------------------------


--@getPictureFullPath():
local function getPictureFullPath()
  return (currPictureFilename ~= '' and DIR_PICTURES .. currPictureFilename) or ''
end

------------------------------------------------------------------------------------------------------------------------

local function getPictureFileDropDownSelection()
  local list = File.list(ORIG_DIR_PICTURES)

  --Ensures that the first file, shown in the drop down menu, is preselected
  if (currPictureFilename == '' ) then
    setPictureFilename(list[1])
  end
  return list
end

-----------------------------------------
--binding: text files
-----------------------------------------

local function setTextFilename(filename)
  currTextFilename = filename
  for _, f in pairs(File.list(DIR_TEXTFILES)) do
    File.del(DIR_TEXTFILES..f)
  end
  File.copy(ORIG_DIR_TEXTFILES..currTextFilename, DIR_TEXTFILES..currTextFilename)
  Script.notifyEvent("OnTextFilename", currTextFilename)
  Script.notifyEvent("OnTextFullPath", DIR_TEXTFILES .. currTextFilename)
end

------------------------------------------------------------------------------------------------------------------------

--@getTextFilename():string
local function getTextFilename()
  return currTextFilename
end

------------------------------------------------------------------------------------------------------------------------

--@getTextFullPath():
local function getTextFullPath()
  return (currTextFilename ~= '' and DIR_TEXTFILES .. currTextFilename) or ''
end

------------------------------------------------------------------------------------------------------------------------

local function getTextFileDropDownSelection()
  local list = File.list(ORIG_DIR_TEXTFILES)

  --Ensures that the first file, shown in the drop down menu, is preselected
  if (currTextFilename == '' ) then
    setTextFilename(list[1])
  end
  return list
end



---------------------------
--SERVE FUNCTIONS / EVENTS
---------------------------

-- Serves for the Picture selection
Script.serveFunction( 'DownloadControl.getPictureFileDropDownSelection',getPictureFileDropDownSelection)
Script.serveFunction( 'DownloadControl.setPictureFilename', setPictureFilename)
Script.serveFunction("DownloadControl.getPictureFilename", getPictureFilename)
Script.serveFunction("DownloadControl.getPictureFullPath", getPictureFullPath)
Script.serveEvent( 'DownloadControl.OnPictureFilename', 'OnPictureFilename')
Script.serveEvent("DownloadControl.OnPictureFullPath", "OnPictureFullPath")


-- Serves for the Text File selection
Script.serveFunction( 'DownloadControl.getTextFileDropDownSelection', getTextFileDropDownSelection)
Script.serveFunction( 'DownloadControl.setTextFilename', setTextFilename)
Script.serveFunction("DownloadControl.getTextFilename", getTextFilename)
Script.serveFunction("DownloadControl.getTextFullPath", getTextFullPath)
Script.serveEvent('DownloadControl.OnTextFilename', 'OnTextFilename')
Script.serveEvent("DownloadControl.OnTextFullPath", "OnTextFullPath")

