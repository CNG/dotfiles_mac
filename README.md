# System configuration

Currently using this for Mac but will keep Linux in mind for servers and when I transition entirely.

## Background and acknowledgments

I liked [Zach Holman](https://github.com/holman/dotfiles)'s "topical" strategy of segregating configurations into directories for various areas that you might want to install together. I think I will go a bit further and make a system to enable or disable topics similar to Apache's `a2ensite` and related commands. Only in Apache, you install modules and then can enabled or disable them, whereas here it seems to make more sense to enable modules so you can then install (and uninstall?) them. I guess installing should be tied to enabling since there doesn't seem a point in only enabling.

## Evolutionary issues

* I started this by pulling my Mac configuration in, but am attempting to make it more general as I go along. I'll use it at least for my desktop and laptop, but I'd like to think about Linux applicability. I'll therefore need to rethink how I handle Homebrew and differences between computers. My module system is an obvious possibility, but I need to segregate things I won't want on the laptop to different modules I guess.
* Should I call this directory "dotfiles" for the sake of congruency with others' repositories, even though it does a lot more than manage some files whose names start with a period?


