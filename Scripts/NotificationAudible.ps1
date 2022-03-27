<# PowerShell Compact-Archive Tool
 # Copyright (C) 2022
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #>




<# Notification Audible
 # ------------------------------
 # ==============================
 # ==============================
 # This class will provide the ability to notify the user based on certain specialized events.
 #  The notifications within this class provide audible alerts, which can be either the classical
 #  bell tone or system based.  The purpose of this functionality is to grab the user's attention
 #  that /something/ had happened.  Further, in order for the notification functionality to work,
 #  the user must had already configured their settings to allow such capabilities.
 #
 # Useful Resources:
 #  Standard System Sounds: https://stackoverflow.com/a/31265651/11314373
 #  MS: https://docs.microsoft.com/en-us/dotnet/api/system.media.systemsounds
 #>



class NotificationAudible
{
   <# Notify [Main Function]
    # -------------------------------
    # Documentation:
    #  This function will allow the ability to provide a audible notifications to the end-user,
    #   such that they are aware that an event that had occurred.
    # -------------------------------
    # Input:
    #  [NotificationEventType] Event Triggered
    #   Specifies what type of event that had been triggered.
    # -------------------------------
    #>
    static [void] Notify([NotificationEventType] $eventTriggered)
    {
        # Determine the type of notification that had just occurred, and evaluate
        #  if user is to be notified regarding the event.
        switch ($eventTriggered)
        {
            # Successful operation
            {($_ -eq [NotificationEventType]::Success)}
            {
                # Play Asterisk sound
                [Notifications]::__PlaySoundAsterisk();
            } # Event: Successful


            # Error had been reached
            {($_ -eq [NotificationEventType]::Error)}
            {
                # Play Critical Error sound
                [Notifications]::__PlaySoundHand();
            } # Event: Errors


            # A specific warning had been reached
            {($_ -eq [NotificationEventType]::Warning)}
            {
                # Play Exclamation sound
                [Notifications]::__PlaySoundExclamation();
            } # Event: Warnings


            # User provided an incorrect option
            {($_ -eq [NotificationEventType]::IncorrectOption)}
            {
                # Play Critical Error sound
                [Notifications]::__PlaySoundBeep();
            } # Event: Errors


            # All other superfluous values
            default
            {
                return;
            } # Default
        } # switch: Event Triggered
    } # Notify()





   <# Standard Bell
    # -------------------------------
    # Documentation:
    #  This function will provide a standard audible bell.  This is a very common
    #   notification bell, nothing too fancy here ;)
    # -------------------------------
    #>
    static hidden [void] __StandardBell()
    {
        # Ordinary bell
        [System.Console]::Beep();
    } # __StandardBell()





   <# Standard Bell (Customizable)
    # -------------------------------
    # Documentation:
    #  This function is adjacent to StandardBell(), except that this function will
    #   allow you to customize the bell's tone and length.
    #
    # Useful resources:
    #  https://docs.microsoft.com/en-us/dotnet/api/system.console.beep?view=net-5.0#System_Console_Beep_System_Int32_System_Int32_
    # -------------------------------
    # Input:
    #  [int32] Frequency
    #   The frequency of the beep, that ranges from 37 to 32767 hertz.
    #  [int32] Duration
    #   The duration of the beep measured in milliseconds.
    # -------------------------------
    #>
    static hidden [void] __StandardBell([int32] $frequency,     # Frequency of the tone
                                        [int32] $duration)      # Length of the tone
    {
        # Make sure that Frequency provided is within the expected range.
        if (($frequency -lt 37) -or `
            ($frequency -gt 32767))
        {
            # The frequency is out of range.
            return;
        } # if : Frequency is out of range


        # Make sure that the duration is not in a negative range nor zero
        if ($duration -le 0)
        {
            # The duration cannot be a negative integer and cannot be zero.
            return;
        } # if : Duration is Zero or Negative



        # Customizable bell
        [System.Console]::Beep($frequency, $duration);
    } # __StandardBell()





   <# PLAY: Beep Sound
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Beep' notification provided by the
    #   Operating System, if supported.
    # -------------------------------
    #>
    static hidden [void] __PlaySoundBeep()
    {
        # Try to play or provide the sound as necessary
        [System.Media.SystemSounds]::Beep.Play();
    } # __PlaySoundBeep()





   <# PLAY: Asterisk Sound
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Asterisk' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when an event had been reached.
    # -------------------------------
    #>
    static hidden [void] __PlaySoundAsterisk()
    {
        # Try to play or provide the sound as necessary
        [System.Media.SystemSounds]::Asterisk.Play();
    } # __PlaySoundAsterisk()





   <# PLAY: Exclamation Sound
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Exclamation' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when something of a great importance had occurred.
    #  GUI: Used with the Exclamation Icon
    # -------------------------------
    #>
    static hidden [void] __PlaySoundExclamation()
    {
        # Try to play or provide the sound as necessary
        [System.Media.SystemSounds]::Exclamation.Play();
    } # __PlaySoundExclamation()





   <# PLAY: Hand Sound
    # -------------------------------
    # Documentation:
    #  This will function will play the 'Hand' notification provided by the
    #   Operating System, if supported.
    #
    # Ideally to be played when a 'Critical Stop' had been reached.
    # -------------------------------
    #>
    static hidden [void] __PlaySoundHand()
    {
        # Try to play or provide the sound as necessary
        [System.Media.SystemSounds]::Hand.Play()
    } # __PlaySoundHand()





   <# PLAY: Question Sound
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
    static hidden [void] __PlaySoundQuestion()
    {
        # Try to play or provide the sound as necessary
        [System.Media.SystemSounds]::Question.Play();
    } # __PlaySoundQuestion()
} # NotificationAudible




<# Notification Audible Event Type [ENUM]
 # -------------------------------
 # This provides specific notification event that could arise within the program.
 # -------------------------------
 #>
enum NotificationAudibleEventType
{
    Success         = 0; # Successful Event
    Warning         = 1; # Warning Event
    Error           = 2; # Error Event
    IncorrectOption = 3; # User provided incorrect option
} # NotificationAudibleEventType