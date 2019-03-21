<# Project Information
 # ------------------------------
 # ==============================
 # ==============================
 # This class holds all information regarding the desired project
 #  that we will be essentially compiling.  Such information is
 #  essentially basic, such as: project name, code name, output -
 #  filename, and project URLs.  This is going to be helpful for
 #  the program to be much more moduler and yet also helpful for
 #  the end-user that will be using this program tool.
 #>



class ProjectInformation
{
    # Member Variables :: Properties
    # =================================================
    # =================================================


    #region Private Variables (emulated)

    # Project's Name
    # ---------------
    # The formal name of the project.
    Hidden [string] $__projectName;


    # Project's Code Name (or Version Code Name)
    # ---------------
    # The code name of the project or of that version.
    Hidden [string] $__codeName;


    # Output Filename
    # ---------------
    # The filename of the archive data file in which this program
    # will create as requested by the end-user.
    Hidden [string] $__fileName;


    # Project's Website
    # ---------------
    # The project's official website; which can be accessed by the
    # end-user by request.  This can be helpful to the user, in-which
    # they may check out the project's latest public announcements
    # and insights regarding the project.
    Hidden [string] $__urlWebsite;


    # Project's Help Documentation
    # ---------------
    # The project's official Wikipedia; which can be accessed by the
    # end-user by request.  This can greatly be helpful to the user,
    # as they may view the project's help-documentation for abroad
    # reasons but not limited to using this very tool.
    #  NOTE: Wiki's are usually provided in some Developer\Repositories
    #  Web-Services, such as GitHub.
    Hidden [string] $__urlWiki;


    # Project's Repository
    # ---------------
    # The project's official repository; which can be accessed by the
    # end-user by request.  This can allow the user to view the project's
    # source code via their preferred web-browser.
    # Prime example of Repositories:
    #  GitHub, SourceForge, BitBucket, GitLab, and many more.
    Hidden [string] $__urlSource;
    
    #endregion



    # Member Functions :: Methods
    # =================================================
    # =================================================


    #region Constructor Functions
    
    # Default Constructor
    ProjectInformation()
    {
        # Project name
        $this.__projectName = "Alphecca";

        # Code name (Version name)
        $this.__codeName = "Apostasy";

        # File name (Archive datafile name)
        #  NOTE: Remember that /idgames has an 8char limit
        $this.__fileName = "alphecca";

        # Project's Website URL
        $this.__urlWebsite = "https://github.com/SibTiger/Alphecca";

        # Project's Wiki URL
        $this.__urlWiki = "https://github.com/SibTiger/Alphecca/wiki";

        # Project's Source (Repository) URL
        $this.__urlSource = "https://github.com/SibTiger/Alphecca";
    } # Default Constructor

    #endregion



    #region Getter Functions

   <# Get Project Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the Project Name variable.
    # -------------------------------
    # Output:
    #  [string] Project Name
    #   The name of the project.
    # -------------------------------
    #>
    [string] GetProjectName()
    {
        return $this.__projectName;
    } # GetProjectName()



   <# Get Project's Code Name
    # -------------------------------
    # Documentation:
    #  Returns the value of the Code Name variable.
    # -------------------------------
    # Output:
    #  [string] Project's Code Name
    #   The code name of the project or version.
    # -------------------------------
    #>
    [string] GetCodeName()
    {
        return $this.__codeName;
    } # GetCodeName()



   <# Get Filename
    # -------------------------------
    # Documentation:
    #  Returns the value of the filename variable.
    # -------------------------------
    # Output:
    #  [string] Archive datafile filename
    #   The filename to be used for the archive datafile.
    # -------------------------------
    #>
    [string] GetFilename()
    {
        return $this.__fileName;
    } # GetFilename()



   <# Get Project's Official Website
    # -------------------------------
    # Documentation:
    #  Returns the value of the Website variable.
    # -------------------------------
    # Output:
    #  [string] Project's Website
    #   The project's official website.
    # -------------------------------
    #>
    [string] GetProjectWebsite()
    {
        return $this.__urlWebsite;
    } # GetProjectWebsite()



   <# Get Project's Official Documentation
    # -------------------------------
    # Documentation:
    #  Returns the value of the Wiki\Documentation variable.
    # -------------------------------
    # Output:
    #  [string] Project's Wikipedia
    #   The project's official wikipedia\documentation webpage.
    # -------------------------------
    #>
    [string] GetProjectWiki()
    {
        return $this.__urlWiki;
    } # GetProjectWiki()



   <# Get Project's Official Repository
    # -------------------------------
    # Documentation:
    #  Returns the value of the Source variable.
    # -------------------------------
    # Output:
    #  [string] Project's Repository
    #   The project's official repository (web view) path.
    # -------------------------------
    #>
    [string] GetProjectSource()
    {
        return $this.__urlSource;
    } # GetProjectSource()

    #endregion
} # ProjectInformation