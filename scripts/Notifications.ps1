<# Notifications
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability to notify the user based on certain events.
 #  The notifications provided may result in a basic tone, while other notifications
 #  may provide a audio alerts and\or visual notifications.  The purpose of this
 #  functionality is to grab the user's attention that /something/ had happened.
 #  Further, in order for the notification functionality to work, the user must
 #  had already configured their settings to allow such capabilities.
 #>



class Notifications
{
   <# Main Notification
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to provide a notification to the end-user,
    #   such that they are aware of an event that had occurred.  Such events may vary
    #   in such a way that they grab the user's attention, such as visual aid or audible
    #   sounds.
    # -------------------------------
    # Input:
    #  [UserPreferencesEventAlarm] Event Triggered
    #   Specifies what type of event that had been triggered.
    # -------------------------------
    #>
    static [void] Main([UserPreferencesEventAlarm] $eventTriggered)
    {
        # Declarations and Initializations
        # -----------------------------------------
        # Retrieve the User's Preferences
        [UserPreferences] $userPref = [UserPreferences]::GetInstance();
        # -----------------------------------------



    } # Notifications()





   <# Standard Bell
    # -------------------------------
    # Documentation:
    #  This function will provide a standard audible bell.  This is a very common
    #   notification bell, nothing too fancy here ;)
    # -------------------------------
    #>
    static hidden [void] StandardBell()
    {
        # Ordinary bell
        [System.Console]::Beep();
    } # StandardBell()
} # Notifications