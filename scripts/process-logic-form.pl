#!/usr/bin/perl -w

use BOSS::Config;
use Capability::LogicForm;
use KBS2::ImportExport;
use PerlLib::SwissArmyKnife;

$specification = q(
	-t <text>		Text
	-f <file>		File
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $text;
if ($conf->{'-t'}) {
  $text .= $conf->{'-t'};
}
if ($conf->{'-f'}) {
  my $c = read_file($conf->{'-f'});
  $text .= $c;
}

my $logicform = Capability::LogicForm->new();
$logicform->StartServer;

my $importexport = KBS2::ImportExport->new
  ();

my $result = $logicform->LogicForm
  (Text => $text);
print Dumper($result);

if ($result->{Success}) {
  my @lfs;
  foreach my $thing (@{$result->{Result}}) {
    push @lfs, $thing->{LogicForms}
  }
  my $res = $importexport->Convert
    (
     Input => \@lfs,
     InputType => "Logic Forms",
     OutputType => "KIF String",
    );
  print Dumper($res);
}
