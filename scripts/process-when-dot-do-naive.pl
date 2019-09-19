#!/usr/bin/perl -w

use Manager::Misc::Light;
use PerlLib::SwissArmyKnife;

use Text::Capitalize;
use Text::Levenshtein qw(distance);

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
# print Dumper(\@res);
while (1) {
  my $query = QueryUser2(Message => 'What has happened? ');
  my $scores = {};
  my $answers = {};
  foreach my $entry (@res) {
    if ($entry->[1]) {
      $scores->{$entry->[1]} = distance($query,$entry->[1]);
      $answers->{$entry->[1]} = $entry->[2];
    }
  }
  my @tmp = sort {$scores->{$a} <=> $scores->{$b}} keys %$scores;
  my @top = splice(@tmp, 0, 5);
  print Dumper({
		Score => $scores,
		Tmp => \@tmp,
		Top => \@top,
	       }) if 0;
  my @questions = SubsetSelect
       (
	Set => \@top,
	Selection => {},
       );
  foreach my $question (@questions) {
    print Dumper
      ({
	Query => $query,
	Question => $question,
	Answer => $answers->{$question},
       });
  }
}

sub Process {
  my (%args) = @_;
  my @results;
  my $d = $args{Domain};
  next unless $d->[0];
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
    # return ProcessInput(Input => $d);
    return join(' ',@$d);
  }
}

sub ProcessInput {
  my (%args) = @_;
  if (0) {
    return MakePrologAtom(Input => $args{Input});
  } else {
    print Dumper({Input => $args{Input}});
    # my $command = '/var/lib/myfrdcsa/codebases/minor/execution-engine/scripts/process-logic-form.pl -t '.shell_quote(join(' ',@{$args{Input}}));
    # print $command;
    # system $command;
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
