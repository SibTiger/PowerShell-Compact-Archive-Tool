;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                | |
;                                                                                                |_|
;                             _____                                                         _
;                            / ____|                                                       (_)
;                           | |        ___    _ __ ___    _ __    _ __    ___   ___   ___   _    ___    _ __
;                           | |       / _ \  | '_ ` _ \  | '_ \  | '__|  / _ \ / __| / __| | |  / _ \  | '_ \
;                           | |____  | (_) | | | | | | | | |_) | | |    |  __/ \__ \ \__ \ | | | (_) | | | | |
;                            \_____|  \___/  |_| |_| |_| | .__/  |_|     \___| |___/ |___/ |_|  \___/  |_| |_|
;                                                        | |
;                                                        |_|
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier





[Setup]


; Internal Compression Level
; - - - - - - - - - - - - - -
; This defines the compression level that will be used for Inno's internal structure.  Ideally, there's no
;   real need to configure this - other than to maybe save a few kilobytes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_internalcompresslevel
InternalCompressLevel = "Normal"



; Compression Algorithm and Compression Level
; - - - - - -
; This will define the compression type and compression level that will be using when compacting the
;   software's assets into the installation package.  We will use LZMA\2 with the best possible compression
;   possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compression
Compression = "LZMA2/Ultra64"



; Solid Compression
; - - - - - - - - -
; Compact the files in such a way that it benefits the overall compression ratio within the installer
;   package.  In doing so, data contents that are a like, will be combined instead of containing duplicated
;   data.  Decompressing, however, in Real-Time will be hindered.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_solidcompression
SolidCompression = "Yes"



; LZMA Algorithm
; - - - - - - - -
; This controls the algorithm that will be used for LZMA\2 Compressor.  Use the normal algorithm to benefit
;   overall compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmaalgorithm
LZMAAlgorithm = 1



; LZMA Use Separate Process
; - - - - - - - - - - - - -
; Allow the ability for the LZMA\2 Compressor to use its own system resources, instead of being tied down
;   to Inno's process.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmauseseparateprocess
LZMAUseSeparateProcess = "Yes"



; LZMA Match Finder
; - - - - - - - - -
; Determine the Match Finder method that will be used with the LZMA\2 Compressor.  Using Binary Tree will
;   give use additional increase in compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmamatchfinder
LZMAMatchFinder = "BT"



; Compression Threads
; - - - - - - - - - -
; Determines if the LZMA\2 Compressor will utilize the host's one or multiple CPU virtual threads, if
;   available.  Using 'auto' will allow the Compressor to automatically determine the threads it will need
;   in order successfully compact the data efficiently.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compressionthreads
CompressionThreads = "Auto"


[/Setup]