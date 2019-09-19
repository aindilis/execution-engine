#!/usr/bin/perl -w

use Manager::Misc::Light;
use PerlLib::SwissArmyKnife;

use Text::Capitalize;

my $light = Manager::Misc::Light->new();

my $c = read_file('/var/lib/myfrdcsa/codebases/minor/execution-engine/rules/library/keywords/when.do');
my $domain = $light->Parse
  (
   Contents => $c,
  );

my @res;
foreach my $subdomain (@{$domain}) {
  push @res, Process(Domain => $subdomain);
}
print Dumper(\@res);

sub Process {
  my (%args) = @_;
  my $d = $args{Domain};
  if ($d->[0] eq 'progn') {
    my @res;
    push @res, shift @$d;
    foreach my $subdomain (@$d) {
      push @res, Process(Domain => $subdomain);
    }
    return \@res;
  } elsif ($d->[0] eq 'or') {
    my @res;
    push @res, shift @$d;
    foreach my $subdomain (@$d) {
      push @res, Process(Domain => $subdomain);
    }
    return \@res;
  } elsif ($d->[0] eq 'if') {
    my $condition = $d->[1];
    Process(Domain => $condition);
    my $opt1 = $d->[2];
    my $opt2;
    if (exists $d->[3]) {
      $opt2 = $d->[3];
    }
    my $res = ['if',Process(Domain => $condition),Process(Domain => $opt1)];
    if ($opt2) {
      push @$res, Process(Domain => $opt2);
    }
    return $res;
  } elsif ($d->[0] eq 'when') {
    my $head = $d->[1];
    my $body = $d->[2];
    return ['when',Process(Domain => $head),Process(Domain => $body)];
  } else {
    return ProcessInput(Input => $d);
  }
}

sub ProcessInput {
  my (%args) = @_;
  if (0) {
    return MakePrologAtom(Input => $args{Input});
  } else {
    my $command = '/var/lib/myfrdcsa/codebases/minor/execution-engine/scripts/process-logic-form.pl -t '.shell_quote(join(' ',@{$args{Input}}));
    print $command;
    system $command;
  }
}

sub MakePrologAtom {
  my (%args) = @_;
  my $i = $args{Input};
  return join('',lc(shift @$i),map {capitalize($_)} @$i);
}


# sub MakePrologAtom {
#   my (%args) = @_;
#   my $i = $args{Input};
#   return join('',map {capitalize($_)} @$i);

# }
