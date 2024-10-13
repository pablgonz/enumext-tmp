--[[
   Configuration script for l3build from the enumext package
   At the moment the possible options that can be passed on to
   l3build are:
   * tag        : Update the version and date
   * doc        : Generate the documentation [-q]
   * unpack     : Unpacks the source files [-q]
   * install    : Install the package locally, you can use
                  it in conjunction with [--full] [--dry-run]
   * uninstall  : Uninstall the package locally
   * clean      : Clean the directory tree and repo
   * ctan       : Generate the compressed package (.zip)
   * upload     : Upload the package to ctan, you must add
                  -F ctan.ann in conjunction with [--debug]
   * tagged     : Check version and date in files
   * testpkg    : Compile all example files included in /test-pkg
   * examples   : Compile all example files included in .dtx file
   * release    : It performs the checks before generating a public
                  release (on git and ctan).
--]]

-- General package identification
module     = "enumext"
pkgversion = "1.0"
pkgdate    = "2024-10-13"

-- Configuration of files for build and installation
maindir       = "."
sourcefiledir = "./sources"
textfiledir   = "./sources"
--textfiles     = {textfiledir.."/CTANREADME.md"}
sourcefiles   = {"**/*.dtx", "**/*.ins"}
installfiles  = {"**/*.sty"}
tdslocations  = {
  "tex/latex/enumext/enumext.sty",
  "doc/latex/enumext/enumext.pdf",
  "doc/latex/enumext/README.md",
  "source/latex/enumext/enumext.dtx",
  "source/latex/enumext/enumext.ins"
}

-- Unpacking files from .ins file
unpackfiles = { "enumext.ins" }
unpackopts  = "--interaction=batchmode"
unpackexe   = "luatex"

-- Generating documentation
--typesetexe  = "lualatex-dev"
typesetfiles  = {"enumext.dtx"}
-- typesetopts = "-interaction=batchmode -shell-escape"

-- Update package date and version
tagfiles = {"sources/enumext.dtx", "sources/CTANREADME.md", "ctan.ann"}
local mydate = os.date("!%Y-%m-%d")

function update_tag(file,content,tagname,tagdate)
  if not tagname and tagdate == mydate or "" then
    tagname = pkgversion
    tagdate = pkgdate
    print("** "..file.." have been tagged with the version and date of build.lua")
  else
    local v_maj, v_min = string.match(tagname, "^v?(%d+)(%S*)$")
    if v_maj == "" or not v_min then
      print("Error!!: Invalid tag '"..tagname.."', none of the files have been tagged")
      os.exit(0)
    else
      tagname = string.format("%i%s", v_maj, v_min)
      tagdate = mydate
    end
    print("** "..file.." have been tagged with the version "..tagname.." and date "..mydate)
  end

  if string.match(file, "enumext.dtx") then
    content = string.gsub(content,
                          "\\ProvidesExplPackage %{enumext%} %{[^}]+%} %{[^}]+%}",
                          "\\ProvidesExplPackage {enumext} {"..tagdate.."} {"..tagname.."}")
  end
  if string.match(file, "CTANREADME.md") then
    content = string.gsub(content,
                          "Release v%d+.%d+%a* \\%[%d%d%d%d%-%d%d%-%d%d\\%]",
                          "Release v"..tagname.." \\["..tagdate.."\\]")
  end
  if string.match(file,"ctan.ann") then
    content = string.gsub(content,
                          "v%d%.%d%w? %d%d%d%d%-%d%d%-%d%d",
                          "v"..tagname..' '..tagdate)
  end
  return content
end

-- Configuration for ctan
ctanreadme = "CTANREADME.md"
ctanpkg    = "enumext"
ctanzip    = ctanpkg.."-"..pkgversion
packtdszip = false

-- Clean files
cleanfiles = {module..".pdf", ctanzip..".curlopt", ctanzip..".zip"}

--  Configuration for package distribution in ctan
uploadconfig = {
  author       = "Pablo González L",
  uploader     = "Pablo González L",
  email        = "pablgonz@yahoo.com",
  pkg          = ctanpkg,
  version      = pkgversion,
  license      = "lppl1.3c",
  summary      = "Stores LaTeX contents in memory or files",
  description  =[[This package provides enumerated list environments compatible with LATEX tagging PDF for creating
                  “simple exercise sheets” along with “multiple choice questions”, storing the “answers” to these in memory using
                   multicol and scontents packages.]],
  topic        = { "File management", "Experimental LaTeX3" },
  ctanPath     = "/macros/latex/contrib/" .. ctanpkg,
  repository   = "https://github.com/pablgonz/" .. module,
  bugtracker   = "https://github.com/pablgonz/" .. module .. "/issues",
  support      = "https://github.com/pablgonz/" .. module .. "/issues",
  note         = [[Uploaded automatically by l3build...]],
  announcement_file="ctan.ann",
  update       = true
}

-- Line length in 80 characters
local function os_message(text)
  local mymax = 77 - string.len(text) - string.len("done")
  local msg = text.." "..string.rep(".", mymax).." done"
  return print(msg)
end

-- Typesetting enumext documentation step by step :)
function docinit_hook()
  local errorlevel = (cp("*.tex", unpackdir, typesetdir) + cp("*.sty", unpackdir, typesetdir))
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy .tex and .sty files from "..unpackdir.." to "..typesetdir)
    return errorlevel
  end
  return 0
end

function typeset(file)
  print("** Running: lualatex-dev "..file..".dtx")
  local file = jobname(sourcefiledir.."/enumext.dtx")
  local errorlevel = runcmd("lualatex-dev "..file..".dtx", typesetdir, {"TEXINPUTS","LUAINPUTS"})
  if errorlevel ~= 0 then
    error("Error!!: Typesetting "..file..".tex")
    return errorlevel
  end
  --return 0
end

