package Text::Table::CSV;

# DATE
# VERSION

#IFUNBUILT
use 5.010001;
use strict;
use warnings;
#END IFUNBUILT

sub _encode {
    my $val = shift;
    $val =~ s/([\\"])/\\$1/g;
    "\"$val\"";
}

sub table {
    my %params = @_;
    my $rows = $params{rows} or die "Must provide rows!";

    my $header_row = defined $params{header_row} ? $params{header_row} : 1;
    my $max_index = _max_array_index($rows);

    # here we go...
    my @table;

    # then the data
    my $i = 0;
    use DD; dd \%params;
    foreach my $row (@$rows) {
        $i++;
        next if $i==1 && !$header_row;
        push @table, join(
	    ",",
	    map { _encode(defined($row->[$_]) ? $row->[$_] : '') } (0..$max_index)
	), "\n";
    }

    return join("", grep {$_} @table);
}

# FROM_MODULE: PERLANCAR::List::Util::PP
# BEGIN_BLOCK: max
sub max {
    return undef unless @_;
    my $res = $_[0];
    my $i = 0;
    while (++$i < @_) { $res = $_[$i] if $_[$i] > $res }
    $res;
}
# END_BLOCK: max

# return highest top-index from all rows in case they're different lengths
sub _max_array_index {
    my $rows = shift;
    return max( map { $#$_ } @$rows );
}

1;
#ABSTRACT: Generate CSV

=for Pod::Coverage ^(max)$

=head1 SYNOPSIS

 use Text::Table::CSV;

 my $rows = [
     # header row
     ['Name', 'Rank', 'Serial'],
     # rows
     ['alice', 'pvt', '123456'],
     ['bob',   'cpl', '98765321'],
     ['carol', 'brig gen', '8745'],
 ];
 print Text::Table::CSV::table(rows => $rows);


=head1 DESCRIPTION

This module provides a single function, C<table>, which formats a
two-dimensional array of data as CSV. This is basically a way to generate CSV
using the same interface as that of L<Text::Table::Tiny> (v0.03) or
L<Text::Table::Org>.

The example shown in the SYNOPSIS generates the following table:

 "Name","Rank","Serial"
 "alice","pvt","123456"
 "bob","cpl","98765321"
 "carol","brig gen","8745"


=head1 FUNCTIONS

=head2 table(%params) => str


=head2 OPTIONS

The C<table> function understands these arguments, which are passed as a hash.

=over

=item * rows* (aoaos)

Required. Takes an array reference which should contain one or more rows of
data, where each row is an array reference.

=item * header_row (bool)

Optional, default true. Whether to print the first row (which is assumed to be
the header row).

=back


=head1 SEE ALSO

The de-facto module for handling CSV in Perl: L<Text::CSV>, L<Text::CSV_XS>.

See also L<Bencher::Scenario::TextTableModules>.

=cut
