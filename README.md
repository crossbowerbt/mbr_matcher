MBR bootloader code matcher
===========================

A little script that compares the MBR bootloader code of a file against a list of known ones.

Used to speed up forensic recognition of the operating system that will be booted by that MBR, and to detect eventual virus infections or customizations of the code.

Usage Example
-------------

```
$ perl ./mbr_matcher.pl ../analysis/mbr-win-server-2008
MBR analysis results:

        DOS or Windows 95a MBR code:	3/139	 2%
        Windows 2000 or XP MBR code:	14/300	 4%
        Windows 7/8/8.1/10 MBR code:	171/355	 48%
     Windows 95b, 98 or Me MBR code:	8/271	 2%
             Windows Vista MBR code:	354/354	 100%

Best match: [Windows Vista MBR code]

Note: the MBR bootloader code is exactly the standard one.
```

Enjoy ;)
