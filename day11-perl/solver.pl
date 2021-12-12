use warnings;

open(inputFile, '<', "input.txt") or die $!;
my @state = [];

while (<inputFile>){
    my $fileline = $_;
    my @spl = split '', $fileline;
    for (@spl) {
        if ($_ =~ /[0-9]/) {
            push(@state, ($_ + 0));
        }
    }
}


my $SIZE = 10;
my $flash_count = 0;

sub increase_squid {
    my $state = $_[0];
    my $y = $_[1];
    my $x = $_[2];
    if ($y < 0 || $y >= $SIZE) {return;}
    if ($x <= 0 || $x > $SIZE) {return;}

    if($state[$y * $SIZE + $x] == 9) {
        $state[$y * $SIZE + $x]++;
        flashes($state, $y, $x);
    } else {
        $state[$y * $SIZE + $x]++;
    }
}

sub flashes {
    $flash_count++;
    my $state = $_[0];
    my $y = $_[1];
    my $x = $_[2];
    for (my $dy = -1; $dy <= 1; $dy++) {
        for (my $dx = -1; $dx <= 1; $dx++) {
            if (!($dx == $dy && $dx == 0)) {
                increase_squid($state, $y + $dy, $x + $dx);
            }
        }
    }
}

sub next_state {
    my $state = $_[0];
    for(my $y = 0; $y < $SIZE; $y++)
    {
        for (my $x = 1; $x <= $SIZE; $x++) {   
            increase_squid($state, $y, $x); 
        }
    }

    for(my $y = 0; $y < $SIZE; $y++)
    {
        for (my $x = 1; $x <= $SIZE; $x++) {
            
            if($state[$y * $SIZE + $x] > 9) {
                $state[$y * $SIZE + $x] = 0;
            }
        }
    }

    return $state;
}

for (my $i = 0; $i < 300; $i++) {
    next_state(@state);

    if($i == 100) {
        print "Part 1 : ",$flash_count, "\n";
    }

    my $all_flashes = 1;
    for (my $j = 1; $j <= $SIZE * $SIZE; $j++) {
        if ($state[$j] != 0) {
            $all_flashes = 0;
        }
    }

    if ($all_flashes == 1) {
        print "Part 2 : ", $i + 1, "\n";
        exit;
    }
}
