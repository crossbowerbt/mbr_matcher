#!/usr/bin/perl

use strict;
use warnings;

use POSIX;

use constant false => 0;
use constant true  => 1;

my $header = "MBR code matcher - ver. 0.1";

my @WIN_7_MBR_CODE = qw {
    33 C0 8E D0 BC 00 7C 8E C0 8E D8 BE 00 7C BF 00
    06 B9 00 02 FC F3 A4 50 68 1C 06 CB FB B9 04 00
    BD BE 07 80 7E 00 00 7C 0B 0F 85 0E 01 83 C5 10
    E2 F1 CD 18 88 56 00 55 C6 46 11 05 C6 46 10 00
    B4 41 BB AA 55 CD 13 5D 72 0F 81 FB 55 AA 75 09
    F7 C1 01 00 74 03 FE 46 10 66 60 80 7E 10 00 74
    26 66 68 00 00 00 00 66 FF 76 08 68 00 00 68 00
    7C 68 01 00 68 10 00 B4 42 8A 56 00 8B F4 CD 13
    9F 83 C4 10 9E EB 14 B8 01 02 BB 00 7C 8A 56 00
    8A 76 01 8A 4E 02 8A 6E 03 CD 13 66 61 73 1C FE
    4E 11 75 0C 80 7E 00 80 0F 84 8A 00 B2 80 EB 84
    55 32 E4 8A 56 00 CD 13 5D EB 9E 81 3E FE 7D 55
    AA 75 6E FF 76 00 E8 8D 00 75 17 FA B0 D1 E6 64
    E8 83 00 B0 DF E6 60 E8 7C 00 B0 FF E6 64 E8 75
    00 FB B8 00 BB CD 1A 66 23 C0 75 3B 66 81 FB 54
    43 50 41 75 32 81 F9 02 01 72 2C 66 68 07 BB 00
    00 66 68 00 02 00 00 66 68 08 00 00 00 66 53 66
    53 66 55 66 68 00 00 00 00 66 68 00 7C 00 00 66
    61 68 00 00 07 CD 1A 5A 32 F6 EA 00 7C 00 00 CD
    18 A0 B7 07 EB 08 A0 B6 07 EB 03 A0 B5 07 32 E4
    05 00 07 8B F0 AC 3C 00 74 09 BB 07 00 B4 0E CD
    10 EB F2 F4 EB FD 2B C9 E4 64 EB 00 24 02 E0 F8
    24 02 C3
};

my @WIN_VISTA_MBR_CODE = qw {
    33 C0 8E D0 BC 00 7C 8E C0 8E D8 BE 00 7C BF 00
    06 B9 00 02 FC F3 A4 50 68 1C 06 CB FB B9 04 00
    BD BE 07 80 7E 00 00 7C 0B 0F 85 10 01 83 C5 10
    E2 F1 CD 18 88 56 00 55 C6 46 11 05 C6 46 10 00
    B4 41 BB AA 55 CD 13 5D 72 0F 81 FB 55 AA 75 09
    F7 C1 01 00 74 03 FE 46 10 66 60 80 7E 10 00 74
    26 66 68 00 00 00 00 66 FF 76 08 68 00 00 68 00
    7C 68 01 00 68 10 00 B4 42 8A 56 00 8B F4 CD 13
    9F 83 C4 10 9E EB 14 B8 01 02 BB 00 7C 8A 56 00
    8A 76 01 8A 4E 02 8A 6E 03 CD 13 66 61 73 1E FE
    4E 11 0F 85 0C 00 80 7E 00 80 0F 84 8A 00 B2 80
    EB 82 55 32 E4 8A 56 00 CD 13 5D EB 9C 81 3E FE
    7D 55 AA 75 6E FF 76 00 E8 8A 00 0F 85 15 00 B0
    D1 E6 64 E8 7F 00 B0 DF E6 60 E8 78 00 B0 FF E6
    64 E8 71 00 B8 00 BB CD 1A 66 23 C0 75 3B 66 81
    FB 54 43 50 41 75 32 81 F9 02 01 72 2C 66 68 07
    BB 00 00 66 68 00 02 00 00 66 68 08 00 00 00 66
    53 66 53 66 55 66 68 00 00 00 00 66 68 00 7C 00
    00 66 61 68 00 00 07 CD 1A 5A 32 F6 EA 00 7C 00
    00 CD 18 A0 B7 07 EB 08 A0 B6 07 EB 03 A0 B5 07
    32 E4 05 00 07 8B F0 AC 3C 00 74 FC BB 07 00 B4
    0E CD 10 EB F2 2B C9 E4 64 EB 00 24 02 E0 F8 24
    02 C3
};

my @WIN_2K_XP_MBR_CODE = qw {
    33 C0 8E D0 BC 00 7C FB 50 07 50 1F FC BE 1B 7C
    BF 1B 06 50 57 B9 E5 01 F3 A4 CB BD BE 07 B1 04
    38 6E 00 7C 09 75 13 83 C5 10 E2 F4 CD 18 8B F5
    83 C6 10 49 74 19 38 2C 74 F6 A0 B5 07 B4 07 8B
    F0 AC 3C 00 74 FC BB 07 00 B4 0E CD 10 EB F2 88
    4E 10 E8 46 00 73 2A FE 46 10 80 7E 04 0B 74 0B
    80 7E 04 0C 74 05 A0 B6 07 75 D2 80 46 02 06 83
    46 08 06 83 56 0A 00 E8 21 00 73 05 A0 B6 07 EB
    BC 81 3E FE 7D 55 AA 74 0B 80 7E 10 00 74 C8 A0
    B7 07 EB A9 8B FC 1E 57 8B F5 CB BF 05 00 8A 56
    00 B4 08 CD 13 72 23 8A C1 24 3F 98 8A DE 8A FC
    43 F7 E3 8B D1 86 D6 B1 06 D2 EE 42 F7 E2 39 56
    0A 77 23 72 05 39 46 08 73 1C B8 01 02 BB 00 7C
    8B 4E 02 8B 56 00 CD 13 73 51 4F 74 4E 32 E4 8A
    56 00 CD 13 EB E4 8A 56 00 60 BB AA 55 B4 41 CD
    13 72 36 81 FB 55 AA 75 30 F6 C1 01 74 2B 61 60
    6A 00 6A 00 FF 76 0A FF 76 08 6A 00 68 00 7C 6A
    01 6A 10 B4 42 8B F4 CD 13 61 61 73 0E 4F 74 0B
    32 E4 8A 56 00 CD 13 EB D6 61 F9 C3
};

my @WINDOWS_95B_ME_MBR_CODE = qw {
    33 C0 8E D0 BC 00 7C FB 50 07 50 1F FC BE 1B 7C
    BF 1B 06 50 57 B9 E5 01 F3 A4 CB BE BE 07 B1 04
    38 2C 7C 09 75 15 83 C6 10 E2 F5 CD 18 8B 14 8B
    EE 83 C6 10 49 74 16 38 2C 74 F6 BE 10 07 4E AC
    3C 00 74 FA BB 07 00 B4 0E CD 10 EB F2 89 46 25
    96 8A 46 04 B4 06 3C 0E 74 11 B4 0B 3C 0C 74 05
    3A C4 75 2B 40 C6 46 25 06 75 24 BB AA 55 50 B4 
    41 CD 13 58 72 16 81 FB 55 AA 75 10 F6 C1 01 74
    0B 8A E0 88 56 24 C7 06 A1 06 EB 1E 88 66 04 BF
    0A 00 B8 01 02 8B DC 33 C9 83 FF 05 7F 03 8B 4E
    25 03 4E 02 CD 13 72 29 BE 46 07 81 3E FE 7D 55
    AA 74 5A 83 EF 05 7F DA 85 F6 75 83 BE 27 07 EB
    8A 98 91 52 99 03 46 08 13 56 0A E8 12 00 5A EB
    D5 4F 74 E4 33 C0 CD 13 EB B8 00 00 00 00 00 00
    56 33 F6 56 56 52 50 06 53 51 BE 10 00 56 8B F4
    50 52 B8 00 42 8A 56 24 CD 13 5A 58 8D 64 10 72
    0A 40 75 01 42 80 C7 02 E2 F7 F8 5E C3 EB 74
};

my @DOS_WIN_95A_MBR_CODE = qw {
    FA 33 C0 8E D0 BC 00 7C 8B F4 50 07 50 1F FB FC
    BF 00 06 B9 00 01 F2 A5 EA 1D 06 00 00 BE BE 07
    B3 04 80 3C 80 74 0E 80 3C 00 75 1C 83 C6 10 FE
    CB 75 EF CD 18 8B 14 8B 4C 02 8B EE 83 C6 10 FE
    CB 74 1A 80 3C 00 74 F4 BE 8B 06 AC 3C 00 74 0B
    56 BB 07 00 B4 0E CD 10 5E EB F0 EB FE BF 05 00
    BB 00 7C B8 01 02 57 CD 13 5F 73 0C 33 C0 CD 13
    4F 75 ED BE A3 06 EB D3 BE C2 06 BF FE 7D 81 3D
    55 AA 75 C7 8B F5 EA 00 7C 00 00
};

my %couples = (
    "Windows 7 MBR code"              => \@WIN_7_MBR_CODE,
    "Windows Vista MBR code"          => \@WIN_VISTA_MBR_CODE,
    "Windows 2000 or XP MBR code"     => \@WIN_2K_XP_MBR_CODE,
    "Windows 95b, 98 or Me MBR code"  => \@WINDOWS_95B_ME_MBR_CODE,
    "DOS or Windows 95a MBR code"     => \@DOS_WIN_95A_MBR_CODE
);

sub match {
    my @mbr  = @{ (shift) };
    my @code = @{ (shift) };

    my $perfect_match = true;
    my $matching_bytes = 0;

    for my $i (0..$#code) {

        if ($mbr[$i] == hex($code[$i])) {
            $matching_bytes++;
        } else {
            $perfect_match = false;
        }

    }

    my $total_bytes = scalar(@code);

    return ($perfect_match, $matching_bytes, $total_bytes);
}

sub main {
    my $filename = shift
        or die "$header\n\nUsage:\t$0 <mbr_file>\n";

    # Read the MBR

    open(my $file, "<", $filename)
        or die "Can't open $filename file for reading!\n";

    binmode($file);

    my $buffer;
    my $count = read ($file, $buffer, 512, 0);

    $count == 512
        or die "Error reading the MBR (invalid size)!\n";

    close $file;

    # Match the MBR against various known codes

    my @mbr = unpack "C*", $buffer;

    my $best_match = 0;
    my $best_match_name;

    print "MBR analysis results:\n\n";

    foreach my $key (keys %couples) {
        my ($perfect, $bytes, $total_bytes);

        ($perfect, $bytes, $total_bytes) = match(\@mbr, $couples{$key});

        my $percent = floor(($bytes / $total_bytes) * 100);

        printf "%35s:", $key;
        print "\t$bytes/$total_bytes\t $percent\%\n";

        if ($best_match < $percent) {
            $best_match = $percent;
            $best_match_name = $key;
        }
    }

    print "\nBest match: [$best_match_name]\n\n";
   
    if ($best_match == 100) {

        print "Note: the MBR bootloader code is exactly the standard one.\n";

    } else {

        print "Note: Only the $best_match\% of the MBR bootloader bytes matched.\n";
        print "The MBR may be a non-standard one, or may have been infected by a virus!\n";

    }

    exit $best_match == 100;
}

main @ARGV;
