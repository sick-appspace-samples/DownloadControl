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


---@return string currPictureFilename
local function getPictureFilename()
  return currPictureFilename
end

------------------------------------------------------------------------------------------------------------------------


---@return string
local function getPictureFullPath()
  return (currPictureFilename ~= '' and DIR_PICTURES .. currPictureFilename) or ''
end

------------------------------------------------------------------------------------------------------------------------

---@return string[] list
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

---@return string currTextFilename
local function getTextFilename()
  return currTextFilename
end

------------------------------------------------------------------------------------------------------------------------

---@return string
local function getTextFullPath()
  return (currTextFilename ~= '' and DIR_TEXTFILES .. currTextFilename) or ''
end

------------------------------------------------------------------------------------------------------------------------

---@return string[] list
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

