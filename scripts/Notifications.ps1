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
 #
 # Useful Resources:
 #  Standard System Sounds: https://stackoverflow.com/a/31265651/11314373
 #  MS: https://docs.microsoft.com/en-us/dotnet/api/system.media.systemsounds
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





   <# PLAY: Beep Bell
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Beep' notification provided by the
    #   Operating System, if supported.
    # -------------------------------
    #>
    static hidden [void] PlaySoundBeep()
    {
        # Play the Beep sound
        [System.Media.SystemSounds]::Beep.Play();
    } # PlaySoundBeep()





   <# PLAY: Asterisk Bell
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Asterisk' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when an event had been reached.
    # -------------------------------
    #>
    static hidden [void] PlaySoundAsterisk()
    {
        # Play the Asterisk sound
        [System.Media.SystemSounds]::Asterisk.Play();
    } # PlaySoundAsterisk()





   <# PLAY: Exclamation Bell
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Exclamation' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when something of a great importance had occurred.
    #  GUI: Used with the Exclamation Icon
    # -------------------------------
    #>
    static hidden [void] PlaySoundExclamation()
    {
        # Play the Exclamation sound
        [System.Media.SystemSounds]::Exclamation.Play();
    } # PlaySoundExclamation()





   <# PLAY: Hand Bell
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Hand' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when a 'Critical Stop' had been reached.
    # -------------------------------
    #>
    static hidden [void] PlaySoundHand()
    {
        # Play the Critical Stop sound
        [System.Media.SystemSounds]::Hand.Play();
    } # PlaySoundHand()





   <# PLAY: Question Bell
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Question' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when a 'Question' had arisen to the user.
    # Developer Note:
    #  I do not think this is being used presently?  As of writing this function,
    #   it really does virtually nothing useful.  Think of this as a Pointless Button
    #   from the ASDF Movie on YouTube, it is exactly that.  Hmm
    #   https://youtu.be/4aK3P-n1aWk
    # -------------------------------
    #>
    static hidden [void] PlaySoundQuestion()
    {
        # Play the Questionable sound
        [System.Media.SystemSounds]::Question.Play();
    } # PlaySoundQuestion()
} # Notifications