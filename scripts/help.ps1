<#
.SYNOPSIS
    Compiles the Alphecca project in ZDoom's PK[3|7] standards.

.DESCRIPTION
    This program is a compiler for the Alphecca project.  Because the project from the development source is incompatible with ZDoom's ZIP Standards, this program is designed to transform the project hierarchy to the specific standards set from ZDoom.  In addition, this program will allow the user flexibility with how the project is to be compacted.  As ZDoom allows some flexibility in terms of compression levels and algorithms, this program will also provide the same adjustability.  After a build has been successfully compiled, the user can then merely play the newly generated build with the desired Doom Engine, such as GZDoom.
    NOTE: This program will require .NET 5.0 minimum, 7Zip for PK7 support, and GIT for dev. builds.  Please see the project's wiki for more information.

.NOTES
    Author: Nicholas Gautier
    Email: Nicholas.Gautier.Tiger@GMail.com
    Project Website: https://github.com/SibTiger/Alphecca

.INPUTS
    Nothing is to be given or to be provided from a command\pipe.

.OUTPUTS
    Nothing is to be returned or to be sent to the pipe.

.EXAMPLE
    .\Compile.ps1

.LINK
    https://github.com/SibTiger/Alphecca
    https://zdoom.org/wiki/Using_ZIPs_as_WAD_replacement
#>