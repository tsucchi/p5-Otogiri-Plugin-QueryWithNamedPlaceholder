use strict;
use warnings;
use Test::More;
use Otogiri;
use Otogiri::Plugin;

my $dbfile  = ':memory:';

my $db = Otogiri->new( connect_info => ["dbi:SQLite:dbname=$dbfile", '', ''] );
Otogiri->load_plugin('QueryWithNamedPlaceholder');

my $sql = <<'EOF';
CREATE TABLE member (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    age        INTEGER,
    name       TEXT    NOT NULL
);
EOF
$db->do($sql);

subtest 'do_named and search_named', sub {
    my $sql = 'INSERT INTO member (name, age) VALUES(:name, :age)';
    $db->do_named($sql, { name => 'ytnobody', age  => 30 });
    $db->do_named($sql, { name => 'dareka',   age  => 30 });

    my @rows = $db->search_named('SELECT * FROM member WHERE age = :age', { age => 30 });
    is( scalar(@rows), 2 );
    is( $rows[0]->{name}, 'ytnobody' );
    is( $rows[1]->{name}, 'dareka' );
};



done_testing;
