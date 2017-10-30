# packelf
Packing Linux ELF program and it's dependencies libraries into standalone executable

# What's it used for?
If you want to install a program to many linux servers, different distributions.
the simplest way is to build your program with static link. but unfortunately.
not all program can build statically. for example: ffmpeg, nginx, or even vlc.
these program depends many libraries. and some of libraries that doesn't provide
static linked version. perhaps you think you have linked it to static version
library. but if you use "ldd" command to check it. you may disappoint.

But you can use patchelf tool and this script to collect all library dependencies.
and release your program along with these libraries. it may generate hundreds of
MB size library dependencies. so please care.

# Install patchelf
    $ git clone https://github.com/NixOS/patchelf
    $ ./bootstrap.sh
    $ ./configure --prefix=/usr
    $ make && sudo make install


# Example Usage:
This example will packing python and it's dependencies libraries into folder
"libs". and patch the rpath and interpreter of python. then you can copy this
"python" program along with the "libs" to other machine.

    $ cp /usr/bin/python .
    $ ./packelf.sh ./python libs

