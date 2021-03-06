requires 'Otogiri', '0.11';
requires 'Otogiri::Plugin', '0.02';
requires 'SQL::NamedPlaceholder';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More';
    requires 'DBD::SQLite';
};
