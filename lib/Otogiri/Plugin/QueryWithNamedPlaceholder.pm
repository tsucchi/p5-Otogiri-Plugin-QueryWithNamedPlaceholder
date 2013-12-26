package Otogiri::Plugin::QueryWithNamedPlaceholder;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use Otogiri;
use Otogiri::Plugin;
use SQL::NamedPlaceholder ();

our @EXPORT = qw(search_named do_named);

sub search_named {
    my ($self, $sql, $params_href, $table_name) = @_;
    $params_href = $self->_deflate_param($table_name, $params_href);
    my ($new_sql, $binds_aref) = SQL::NamedPlaceholder::bind_named($sql, $params_href);
    return $self->search_by_sql($new_sql, $binds_aref, $table_name);
}

sub do_named {
    my ($self, $sql, $params_href) = @_;
    my ($new_sql, $binds_aref) = SQL::NamedPlaceholder::bind_named($sql, $params_href);
    $self->do($new_sql, @{ $binds_aref });
}

1;
__END__

=encoding utf-8

=head1 NAME

Otogiri::Plugin::QueryWithNamedPlaceholder - Plugin for Otogiri which enables to use query with named placeholder

=head1 SYNOPSIS

    use Otogiri;
    Otogiri::load_plugin('QueryWithNamedPlaceholder');
    my $db = Otogiri->new( connect_info => ["dbi:sqlite:dbname=$dbname", '', ''] );
    my @rows = $db->search_named('SELECT * FROM table_1 WHERE id = :id AND name = :name', { id => 100, name => 'aaa' });
    $db->do_named('UPDATE table_1 SET name = :name WHERE id = :id', { id => 100, name => 'bbb' });

=head1 DESCRIPTION

Otogiri::Plugin::QueryWithNamedPlaceholder is plugin for L<Otogiri>. This module provides two methods, C<search_named> and C<do_named>

=head1 METHODS

=head2 @rows = $self->search_named($sql, $params_href [, $table_name])

execute SELECT and returns row array. Parameters in SQL written such as ':param_name' is replaced to '?', for example,

    $db->search_named('SELECT * FROM table_1 WHERE id = :id', { id => 100 });

is equivalent to

    $db->search_by_sql('SELECT * FROM table_1 WHERE id = ?', [100]);

parameter $table_name is optional. inflate and deflate are call-backed.

=head2 do_named($sql, $params_href)

execute SQL with named placeholder. Parameters in SQL written such as ':param_name' is replaced to '?', for example,

    $db->do_named('INSERT INTO table_1 (id, name) VALUES(:id, :name)', { id => 100, name => 'aaa' });

is equivalent to

    $db->do('INSERT INTO table_1 (id, name) VALUES(?, ?)', 100, 'aaa');

inflate and deflate are NOT call-backed.

=head1 SEE ALSO

=item L<Otogiri>

=item L<SQL::NamedPlaceholder>

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

