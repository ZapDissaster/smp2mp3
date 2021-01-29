# smp2mp3
Program to Encrypt/Decrypt audio files from audiocubes.

Audiocubes are a few similar more or less cube-shaped audio players with an integrated speaker, that will automatically start playing encrypted audio files from their internal memory when a RFID tag with the appropriate code is placed on top of the device. All devices seen so far use XOR encrypted audio files with a .smp extension.

Thanks to Marc D from https://www.mikrocontroller.net/ for publishing the initial file encryption and RFID tag structure.  
Thanks to Joachim S for figuring out the encryption of the Lidl Storyland audio files.

Joaquim S. has a similar proyect that works on Python and in addition to encrypt/decrypt the files can create the .mct files to use with the Mifare Classic Tools app to write the FRID Tags for the Hachette (Salvat) audiocube, in addition he has collected a lot of information regarding this kind of cubes.
His project can be foud here: https://github.com/oyooyo/audiocube
