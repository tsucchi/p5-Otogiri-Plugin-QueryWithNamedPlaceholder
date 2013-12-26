use strict;
use warnings;
use utf8;
use Test::More;

use Otogiri;
use Otogiri::Plugin;

my $dbfile  = ':memory:';

Otogiri->load_plugin('QueryWithNamedPlaceholder');

subtest basic => sub {
    my ($inflate_called, $deflate_called) = (0, 0);
    my ($inflate_table, $deflate_table);

    my $db = Otogiri->new( 
        connect_info => ["dbi:SQLite:dbname=$dbfile", '', ''],
        inflate => sub {
            my ($row, $table) = @_;
            $inflate_called++;
            $inflate_table = $table;
            $row;
        },
        deflate => sub {
            my ($row, $table) = @_;
            $deflate_called++;
            $deflate_table = $table;
            $row;
        }
    );

    my $sql = <<'EOF';
CREATE TABLE test_data (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    data       TEXT
);
EOF

    $db->do($sql);
    $db->do_named('INSERT INTO test_data(data) VALUES(:data)', { data => 'aaa'  });
    is( $inflate_called, 0 );
    is( $deflate_called, 0 );
    is( $inflate_table, undef );
    is( $deflate_table, undef );

    my $id = $db->last_insert_id();
    my @rows = $db->search_named('SELECT * FROM test_data WHERE id = :id', { id => $id }, 'test_data');
    is( scalar(@rows), 1 );
    is( $rows[0]->{id},   $id );
    is( $rows[0]->{data}, 'aaa' );
    is( $inflate_called, 1 );
    is( $deflate_called, 1 );
    is( $inflate_table, 'test_data' );
    is( $deflate_table, 'test_data' );
};


done_testing;
