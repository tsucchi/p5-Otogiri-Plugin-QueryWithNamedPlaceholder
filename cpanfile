requires 'Otogiri';
requires 'Otogiri::Plugin';
requires 'SQL::NamedPlaceholder';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More';
};