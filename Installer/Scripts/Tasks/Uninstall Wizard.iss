;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;               _    _           _                 _             _   _    __          __  _                            _
;              | |  | |         (_)               | |           | | | |   \ \        / / (_)                          | |
;              | |  | |  _ __    _   _ __    ___  | |_    __ _  | | | |    \ \  /\  / /   _   ____   __ _   _ __    __| |
;              | |  | | | '_ \  | | | '_ \  / __| | __|  / _` | | | | |     \ \/  \/ /   | | |_  /  / _` | | '__|  / _` |
;              | |__| | | | | | | | | | | | \__ \ | |_  | (_| | | | | |      \  /\  /    | |  / /  | (_| | | |    | (_| |
;               \____/  |_| |_| |_| |_| |_| |___/  \__|  \__,_| |_| |_|       \/  \/     |_| /___|  \__,_| |_|     \__,_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Descrition
; ------------------------
; This script is designed to allow the user with the ability to remove certain files and directories that may
;   not be possible during the standard uninstall operation.  Thus, the user can be able to easily delete all
;   associated files and directories or only a base uninstall operation.
;
; NOTE:
;   These resources were extremely helpful - without I would never had gotten this to work.
;   - Inno Setup - How to create a OuterNotebook/welcome page in the uninstaller?
;       https://stackoverflow.com/a/42626292/11314373
;   - Inno Setup: Custom page to select Update or Remove/Uninstall
;       https://stackoverflow.com/q/45055316/11314373




[CustomMessages]
UNINSTALL_CAPTION_PAGENAME_FIRSTPAGE            =ASDF
UNINSTALL_CAPTION_PAGEDESCRIPTION_FIRSTPAGE     =ASDF
UNINSTALL_CAPTION_PAGENAME_SECONDPAGE           =ASDF
UNINSTALL_CAPTION_PAGEDESCRIPTION_SECONDPAGE    =ASDF




[Code]
// Global Variables
// ------------------------------------------------------------
var
    // Definitions for UI pages that we will use for the Uninstallation process.
    // - - - -
    // Welcome Page
    UninstallWelcomePage    : TNewNotebookPage;

    // Uninstall Options Page
    UninstallFirstPage      : TNewNotebookPage;

    // Uninstall Confirmation Page
    UninstallSecondPage     : TNewNotebookPage;


    // Definitions for the buttons that will be used for the Uninstallation Pages.
    // - - - -
    // Button: Back
    UninstallBackButton     : TNewButton;

    // Button: Next
    UninstallNextButton     : TNewButton;





// Function Prototypes
// ------------------------------------------------------------
procedure   UpdateUninstallWizard               ();     forward;
procedure   UpdateUninstallWizardCaptions       ();     forward;
procedure   UpdateUninstallWizardButtons        ();     forward;




// ------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------





// Update Uninstall Wizard
// --------------------------------------
// This function will provide a way to update the Uninstall Page's UI elements.
//  Such that we can provide the appropriate information.
// --------------------------------------
procedure UpdateUninstallWizard;
begin
    // Provide captions
    UpdateUninstallWizardCaptions;

    // Update the buttons
    UpdateUninstallWizardButtons;
end; // UpdateUninstallWizard()





// Update Uninstall Wizard - Captions
// --------------------------------------
// This function will update the captions that will be displayed at the top of the UI Page.
//  With the appropriate page shown to the user, this will let the user know what part of the
//  Uninstall page they are presently viewing.
// --------------------------------------
procedure UpdateUninstallWizardCaptions;
begin
    // Uninstall Page: Options
    if (UninstallProgressForm.InnerNotebook.ActivePage = UninstallFirstPage) then
    begin
        UninstallProgressForm.PageNameLabel.Caption         := 'Uninstall Options';
        UninstallProgressForm.PageDescriptionLabel.Caption  := 'How do you want to ';
    end

    // Uninstall Page: Confirmation
    else if (UninstallProgressForm.InnerNotebook.ActivePage = UninstallSecondPage) then
    begin
        UninstallProgressForm.PageNameLabel.Caption         := 'Uninstall Confirmation';
        UninstallProgressForm.PageDescriptionLabel.Caption  := 'Even more stuff';
    end;
end; // UpdateUninstallWizardCaptions()




procedure UpdateUninstallWizardButtons
begin
    // Determine how the buttons will be used for navigation purposes.
    UninstallBackButton.Visible := (UninstallProgressForm.OuterNotebook.ActivePage <> UninstallWelcomePage);

    if (UninstallProgressForm.InnerNotebook.ActivePage <> UninstallSecondPage) then
    begin
        UninstallNextButton.Caption         := SetupMessage(msgButtonNext);
        UninstallNextButton.ModalResult     := mrNone;
    end

    else
    begin
        UninstallNextButton.Caption         := 'Uninstall';

        // Make the 'Uninstall' button break the ShowModal Loop.
        UninstallNextButton.ModalResult     := mrOk;
    end;
end; // UpdateUninstallWizardButtons()




// Handler: Next Button on Click
// --------------------------------------
// --------------------------------------
procedure UninstallNextButtonClick(Sender: TObject);
begin
    if (UninstallProgressForm.OuterNotebook.ActivePage = UninstallWelcomePage) then
    begin
        UninstallProgressForm.OuterNotebook.ActivePage  := UninstallProgressForm.InnerPage;
        UninstallProgressForm.InnerNotebook.ActivePage  := UninstallFirstPage;
        UpdateUninstallWizard;
    end

    else
    begin
        if (UninstallProgressForm.InnerNotebook.ActivePage <> UninstallSecondPage) then
        begin
            if (UninstallProgressForm.InnerNotebook.ActivePage = UninstallFirstPage) then
                UninstallProgressForm.InnerNotebook.ActivePage  := UninstallSecondPage;


            UpdateUninstallWizard;
        end

        else
        begin
            UninstallNextButton.Visible := False;
            UninstallBackButton.Visible := False;
        end;
    end;
end; // UninstallNextButtonClick()





// Handler: Back Button on Click
// --------------------------------------
// --------------------------------------
procedure UninstallBackButtonClick(Sender: TObject);
begin
    if (UninstallProgressForm.InnerNotebook.ActivePage = UninstallFirstPage) then
    begin
        UninstallProgressForm.OuterNotebook.ActivePage := UninstallWelcomePage;
    end

    else if (UninstallProgressForm.InnerNotebook.ActivePage = UninstallSecondPage) then
        UninstallProgressForm.InnerNotebook.ActivePage  := UninstallFirstPage;


    UpdateUninstallWizard;
end; // UninstallBackButtonClick()





// Initialize Uninstall Progress Form
// --------------------------------------
// --------------------------------------
procedure InitializeUninstallProgressForm;
var
    PageText                    : TNewStaticText;
    UninstallWizardBitmapImage  : TBitmapImage;
    PageNameLabel               : string;
    PageDescriptionLabel        : string;
    CancelButtonEnabled         : Boolean;
    CancelButtonModalResult     : Integer;


begin
    if (not UninstallSilent) then
    begin
        PageNameLabel                       := UninstallProgressForm.PageNameLabel.Caption;
        PageDescriptionLabel                := UninstallProgressForm.PageDescriptionLabel.Caption;


        // Create the Welcome Page and make it active.
        UninstallWelcomePage                := TNewNotebookPage.Create(UninstallProgressForm);
        UninstallWelcomePage.Notebook       := UninstallProgressForm.OuterNotebook;
        UninstallWelcomePage.Parent         := UninstallProgressForm.OuterNotebook;
        UninstallWelcomePage.Align          := alClient;
        UninstallWelcomePage.Color          := clWindow;

        UninstallWizardBitmapImage          := TBitmapImage.Create(UninstallProgressForm);
        UninstallWizardBitmapImage.Parent   := UninstallWelcomePage;
        UninstallWizardBitmapImage.Width    := ScaleX(164);
        UninstallWizardBitmapImage.Height   := ScaleX(314);
        UninstallWizardBitmapImage.Bitmap.LoadFromFile(ExpandConstant('{app}\WizModernImage-IS.bmp'));
        UninstallWizardBitmapImage.Center   := True;
        UninstallWizardBitmapImage.Stretch  := True;

        PageText                            := TNewStaticText.Create(UninstallProgressForm);
        PageText.Parent                     := UninstallWelcomePage;
        PageText.Left                       := ScaleX(176);
        PageText.Top                        := ScaleX(16);
        PageText.Width                      := ScaleX(301);
        PageText.Height                     := ScaleX(54);
        PageText.AutoSize                   := False;
        PageText.Caption                    := 'Uhhh.. something?';
        PageText.ShowAccelChar              := False;
        PageText.WordWrap                   := True;
        PageText.Font.Name                  := 'Verdana';
        PageText.Font.Size                  := 12;
        PageText.Font.Style                 := [fsBold];

        PageText                            := TNewStaticText.Create(UninstallProgressForm);
        PageText.Parent                     := UninstallWelcomePage;
        PageText.Left                       := ScaleX(176);
        PageText.Top                        := ScaleX(76);
        PageText.Width                      := ScaleX(301);
        PageText.Height                     := ScaleX(234);
        PageText.AutoSize                   := False;
        PageText.Caption                    := 'Text here about something of uninstalling stuff...  I dont know';
        PageText.ShowAccelChar              := False;
        PageText.WordWrap                   := True;


        UninstallProgressForm.OuterNotebook.ActivePage  := UninstallWelcomePage;



        // Create the first page
        UninstallFirstPage                  := TNewNotebookPage.Create (UninstallProgressForm);
        UninstallFirstPage.Notebook         := UninstallProgressForm.InnerNotebook;
        UninstallFirstPage.Parent           := UninstallProgressForm.InnerNotebook;
        UninstallFirstPage.Align            := alClient;

        PageText                            := TNewStaticText.Create(UninstallProgressForm);
        PageText.Parent                     := UninstallFirstPage;
        PageText.Top                        := UninstallProgressForm.StatusLabel.Top;
        PageText.Left                       := UninstallProgressForm.StatusLabel.Left;
        PageText.Width                      := UninstallProgressForm.StatusLabel.Width;
        PageText.Height                     := UninstallProgressForm.StatusLabel.Height;
        PageText.AutoSize                   := False;
        PageText.ShowAccelChar              := False;
        PageText.Caption                    := 'Uhh  First Page stuff?';



        // Create the Second Page
        UninstallSecondPage                 := TNewNotebookPage.Create(UninstallProgressForm);
        UninstallSecondPage.Notebook        := UninstallProgressForm.InnerNotebook;
        UninstallSecondPage.Parent          := UninstallProgressForm.InnerNotebook;
        UninstallSecondPage.Align           := alClient;

        PageText                            := TNewStaticText.Create(UninstallProgressForm);
        PageText.Parent                     := UninstallSecondPage;
        PageText.Top                        := UninstallProgressForm.StatusLabel.Top;
        PageText.Left                       := UninstallProgressForm.StatusLabel.Left;
        PageText.Width                      := UninstallProgressForm.StatusLabel.Width;
        PageText.Height                     := UninstallProgressForm.StatusLabel.Height;
        PageText.AutoSize                   := False;
        PageText.ShowAccelChar              := False;
        PageText.Caption                    := 'Second Page here, I guess?';




        UninstallNextButton                         := TNewButton.Create(UninstallProgressForm);
        UninstallNextButton.Parent                  := UninstallProgressForm;
        UninstallNextButton.Left                    :=
            UninstallProgressForm.CancelButton.Left -
            UninstallProgressForm.CancelButton.Width -
            ScaleX(10);
        UninstallNextButton.Top                     := UninstallProgressForm.CancelButton.Top;
        UninstallNextButton.Width                   := UninstallProgressForm.CancelButton.Width;
        UninstallNextButton.Height                  := UninstallProgressForm.CancelButton.Height;
        UninstallNextButton.OnClick                 := @UninstallNextButtonClick;

        UninstallBackButton                         := TNewButton.Create(UninstallProgressForm);
        UninstallBackButton.Parent                  := UninstallProgressForm;
        UninstallBackButton.Left                    :=
            UninstallNextButton.Left - UninstallNextButton.Width - ScaleX(10);
        UninstallBackButton.Top                     := UninstallProgressForm.CancelButton.Top;
        UninstallBackButton.Width                   := UninstallProgressForm.CancelButton.Width;
        UninstallBackButton.Height                  := UninstallProgressForm.CancelButton.Height;
        UninstallBackButton.Caption                 := SetupMessage(msgButtonBack);
        UninstallBackButton.OnClick                 := @UninstallBackButtonClick;
        UninstallBackButton.TabOrder                := UninstallProgressForm.CancelButton.TabOrder;
        UninstallNextButton.TabOrder                := UninstallBackButton.TabOrder + 1;
        UninstallProgressForm.CancelButton.TabOrder := UninstallNextButton.TabOrder + 1;



        // Execute the Uninstall Wizard Pages
        UpdateUninstallWizard;
        CancelButtonEnabled                             := UninstallProgressForm.CancelButton.Enabled
        UninstallProgressForm.CancelButton.Enabled      := True;
        CancelButtonModalResult                         := UninstallProgressForm.CancelButton.ModalResult;
        UninstallProgressForm.CancelButton.ModalResult  := mrCancel;

        if (UninstallProgressForm.ShowModal = mrCancel) then
            Abort;



        // Restore the standard page payout
        UninstallProgressForm.CancelButton.Enabled          := CancelButtonEnabled;
        UninstallProgressForm.CancelButton.ModalResult      := CancelButtonModalResult;
        UninstallProgressForm.PageNameLabel.Caption         := PageNameLabel;
        UninstallProgressForm.PageDescriptionLabel.Caption  := PageDescriptionLabel;
        UninstallProgressForm.InnerNotebook.ActivePage      := UninstallProgressForm.InstallingPage;
    end;
end; // InitializeUninstallProgressForm()
[/code]