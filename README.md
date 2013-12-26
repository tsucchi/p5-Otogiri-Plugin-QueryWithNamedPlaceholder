[![Build Status](https://travis-ci.org/tsucchi/p5-Otogiri-Plugin-QueryWithNamedPlaceholder.png?branch=master)](https://travis-ci.org/tsucchi/p5-Otogiri-Plugin-QueryWithNamedPlaceholder) [![Coverage Status](https://coveralls.io/repos/tsucchi/p5-Otogiri-Plugin-QueryWithNamedPlaceholder/badge.png?branch=master)](https://coveralls.io/r/tsucchi/p5-Otogiri-Plugin-QueryWithNamedPlaceholder?branch=master)
# NAME

Otogiri::Plugin::QueryWithNamedPlaceholder - Plugin for Otogiri which enables to use query with named placeholder

# SYNOPSIS

    use Otogiri;
    Otogiri::load_plugin('QueryWithNamedPlaceholder');
    my $db = Otogiri->new( connect_info => ["dbi:sqlite:dbname=$dbname", '', ''] );
    my @rows = $db->search_named('SELECT * FROM table_1 WHERE id = :id AND name = :name', { id => 100, name => 'aaa' });
    $db->do_named('UPDATE table_1 SET name = :name WHERE id = :id', { id => 100, name => 'bbb' });

# DESCRIPTION

Otogiri::Plugin::QueryWithNamedPlaceholder is plugin for [Otogiri](http://search.cpan.org/perldoc?Otogiri). This module provides two methods, `search_named` and `do_named`

# METHODS

## @rows = $self->search\_named($sql, $params\_href \[, $table\_name\])

execute SELECT and returns row array. Parameters in SQL written such as ':param\_name' is replaced to '?', for example,

    $db->search_named('SELECT * FROM table_1 WHERE id = :id', { id => 100 });

is equivalent to

    $db->search_by_sql('SELECT * FROM table_1 WHERE id = ?', [100]);

parameter $table\_name is optional. inflate and deflate are call-backed.

## do\_named($sql, $params\_href)

execute SQL with named placeholder. Parameters in SQL written such as ':param\_name' is replaced to '?', for example,

    $db->do_named('INSERT INTO table_1 (id, name) VALUES(:id, :name)', { id => 100, name => 'aaa' });

is equivalent to

    $db->do('INSERT INTO table_1 (id, name) VALUES(?, ?)', 100, 'aaa');

inflate and deflate are NOT call-backed.

# SEE ALSO

- [Otogiri](http://search.cpan.org/perldoc?Otogiri)
- [SQL::NamedPlaceholder](http://search.cpan.org/perldoc?SQL::NamedPlaceholder)

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>
