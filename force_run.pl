# Forces a command to run on every pty session
# Probably wont work on a tmux session

for tty in $(who | awk '{print $2}'); do
    perl -e '
        use strict;
        use warnings;
        my $tty = shift @ARGV;
        my $cmd = shift @ARGV;
        open my $fh, ">", $tty or die "Cannot open $tty: $!";
        foreach my $char (split //, "\n" . $cmd . "\n") {
            ioctl($fh, 0x5412, $char) or die "ioctl failed: $!";
        }
        close $fh;
    ' "/dev/$tty" 'export MYVAR="newvalue";'
done