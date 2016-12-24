# img2sdat
Convert filesystem ext4 image (.img) into Android sparse data image (.dat)



## Requirements
This binary requires Python 2.7 or newer installed on your system.

It currently supports Windows x86/x64, Linux x86/x64 & arm/arm64 architectures.



## Usage
```
img2sdat.py <system_img> [version]
```
- `<system_img>` = input system image
- `[version]` = transfer list version number (1-4, more info on xda thread)



## Example
This is a simple example on a Linux system: 
```
~$ ./img2sdat.py system.img 4
```



## Info
For more information about this binary, visit http://forum.xda-developers.com/android/software-hacking/how-to-conver-lollipop-dat-files-to-t2978952.
