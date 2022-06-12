;                                    ___   _   _   _   _    ___      ____           _
;                                   |_ _| | \ | | | \ | |  / _ \    / ___|    ___  | |_   _   _   _ __
;                                    | |  |  \| | |  \| | | | | |   \___ \   / _ \ | __| | | | | | '_ \
;                                    | |  | |\  | | |\  | | |_| |    ___) | |  __/ | |_  | |_| | | |_) |
;                                   |___| |_| \_| |_| \_|  \___/    |____/   \___|  \__|  \__,_| | .__/
;                                                                                                |_|
;   _____                               _   _                    _____                    __   _                                  _     _
;  / ____|                             (_) | |                  / ____|                  / _| (_)                                | |   (_)
; | |        ___    _ __ ___    _ __    _  | |   ___   _ __    | |        ___    _ __   | |_   _    __ _   _   _   _ __    __ _  | |_   _    ___    _ __
; | |       / _ \  | '_ ` _ \  | '_ \  | | | |  / _ \ | '__|   | |       / _ \  | '_ \  |  _| | |  / _` | | | | | | '__|  / _` | | __| | |  / _ \  | '_ \
; | |____  | (_) | | | | | | | | |_) | | | | | |  __/ | |      | |____  | (_) | | | | | | |   | | | (_| | | |_| | | |    | (_| | | |_  | | | (_) | | | | |
;  \_____|  \___/  |_| |_| |_| | .__/  |_| |_|  \___| |_|       \_____|  \___/  |_| |_| |_|   |_|  \__, |  \__,_| |_|     \__,_|  \__| |_|  \___/  |_| |_|
;                              | |                                                                  __/ |
;                              |_|                                                                 |___/
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;                                                                              Designed for the PowerShell Compact-Archive Tool project
;                                                                                                       Maintained by: Nicholas Gautier




; Internal Compression Level
; - - - - - - - - - - - - - -
; This defines the compression level that will be used for Inno's internal structure.  Ideally, there's no
;   real need to configure this - other than to maybe save a few kilobytes.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_internalcompresslevel
InternalCompressLevel = normal


; Compression Algorithm and Compression Level
; - - - - - -
; This will define the compression type and compression level that will be using when compacting the
;   software's assets into the installation package.  We will use LZMA\2 with the best possible compression
;   possible.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compression
Compression = lzma2/ultra64


; Solid Compression
; - - - - - - - - -
; Compact the files in such a way that it benefits the overall compression ratio within the installer
;   package.  In doing so, data contents that are a like, will be combined instead of containing duplicated
;   data.  Decompressing, however, in Real-Time will be hindered.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_solidcompression
SolidCompression = yes


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
LZMAUseSeparateProcess = yes


; LZMA Match Finder
; - - - - - - - - -
; Determine the Match Finder method that will be used with the LZMA\2 Compressor.  Using Binary Tree will
;   give use additional increase in compression.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_lzmamatchfinder
LZMAMatchFinder = BT


; Compression Threads
; - - - - - - - - - -
; Determines if the LZMA\2 Compressor will utilize the host's one or multiple CPU virtual threads, if
;   available.  Using 'auto' will allow the Compressor to automatically determine the threads it will need
;   in order successfully compact the data efficiently.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_compressionthreads
CompressionThreads = auto


; Merge Duplicate Files
; - - - - - - - - - - -
; If incase there exists multiple duplicate files, then we can be able to ignore all other duplicate sources
;   but only use the first instance instance.  By doing this, we minimize the need to store every duplicate
;   file - thus reducing the overall package size.  Moreover, the output that requires the duplicated data
;   to exist, will still be provided as intended.
;
; Resource:
;   - https://jrsoftware.org/ishelp/index.php?topic=setup_mergeduplicatefiles
MergeDuplicateFiles = yes