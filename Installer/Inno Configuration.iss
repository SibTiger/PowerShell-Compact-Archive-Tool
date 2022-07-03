#include ".\Scripts\Project Information.iss"
#include ".\Scripts\Debug\Testing.iss"



[Setup]
#include ".\Scripts\Application GUID.iss"
#include ".\Scripts\Metadata\Project Metadata.iss"
#include ".\Scripts\Metadata\Installer Metadata.iss"
#include ".\Scripts\Setup\Compression.iss"
#include ".\Scripts\Setup\File Management.iss"
#include ".\Scripts\Setup\Source Directory.iss"
#include ".\Scripts\Setup\Output.iss"
#include ".\Scripts\Setup\Wizard.iss"
#include ".\Scripts\Interface\Wizard Style.iss"
#include ".\Scripts\Interface\Wizard Interface.iss"
#include ".\Scripts\Interface\Wizard Graphics.iss"



[Languages]
#include ".\Scripts\Language\English.iss"



[Files]
#include ".\Scripts\Installation Files\Files.iss"



[Dirs]
#include ".\Scripts\Installation Files\Directories.iss"



[Icons]
#include ".\Scripts\Interface\Start Menu.iss"
