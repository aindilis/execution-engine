#!/usr/bin/perl -w

use Data::Dumper;

print Dumper(shellCommandGetBothReturnValueAndOuptut(Command => 'ls'));

# sub shellCommandGetBothReturnValueAndOuptut {
#   my %args = @_;
#   my $res1 = open('>', $args{Command}, "/tmp/output.txt");
#   my $res2 = do { local $/; <CMD> };
#   close CMD;
#   return
#     {
#      Retval => $res1,
#      Output => $res2,
#     };
# }

sub shellCommandGetBothReturnValueAndOuptut {
  my %args = @_;
  my $result = `$args{Command}`;
  my $retval = $?;
  return
    {
     Retval => $retval,
     Output => $result,
    };
}
