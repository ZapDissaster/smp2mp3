# smp2mp3
### Description:
Windows based program to Encrypt/Decrypt and play audio files from audiocubes.

Audiocubes are cube like audio players with an integrated speaker, that will automatically play encrypted audio files when a RFID tag with the appropriate code is placed on top of the device. All devices seen so far use XOR encrypted audio files with a .smp extension.

### Features:
- Encrypt or decrypt a single file.
- Encrypt or decrypt a complete directory.
- Play an encrypted audio file without need to decrypt it first.
- Generate .mct files for use with [Mifare Classic Tools](https://play.google.com/store/apps/details?id=de.syss.MifareClassicTool) to write tags for Salvat/hachette and Migros cubes.
- Generate .csv files for use with [NFC TagWriter by NXP](https://play.google.com/store/apps/details?id=com.nxp.nfc.tagwriter) to write tags for Lidl cubes.
- Encryption can be easily changed.
  - An Hexadecimal key can be defined to be used in XOR bitwise operations
  - Bit rotation can be specified to be applied before or after applying the XOR operation.
  - Keys can be saved to and loaded from files to facilitate changing keys for different audiocubes.
- Languaje can be easily changed using .lan files.
- No instalation needed, just download [Smp2Mp3.zip](https://github.com/ZapDissaster/smp2mp3/blob/main/Bin/Smp2Mp3.zip), unzip and run smp2mp3.exe

### Similar projects
Joaquim S. has a similar proyect that works on Python. In addition he has collected a lot of information regarding this kind of cubes.
His project can be foud here: https://github.com/oyooyo/audiocube

### Thanks to:  
- Marc D. from https://www.mikrocontroller.net/ for publishing the initial file encryption and RFID tag structure.  
- Joachim S. for figuring out the encryption of the Lidl Storyland audio files.  
- Cean D. for providing example files for figuring out the encryption for the green cubes (My first alphabet).

### 3rd Party software used:  
- BASS (https://www.un4seen.com/): Library used to play the audio files.  
BASS is free for non-commercial use. If you are a non-commercial entity (eg. an individual) and you are not making any money from your product (through sales, advertising, etc), then you can use BASS in it for free.  

- MP3Gain (http://mp3gain.sourceforge.net/): Program used for lossless normalization of mp3 files.  
No license info found.

