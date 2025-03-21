use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Random data generation utilities.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Data-Random-Utils';
perl_version 5.008;
readme_from 'Utils.pm';
recursive_author_tests('xt');
requires 'DateTime' => 0;
requires 'Error::Pure' => 0;
requires 'Exporter' => 0;
requires 'List::Util' => 1.33;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Data-Random-Utils/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Data-Random-Utils';
resources 'repository' => 'git://github.com/michal-josef-spacek/Data-Random-Utils';
test_requires 'DateTime' => 0;
test_requires 'List::Util' => 1.45;
test_requires 'Test::MockObject' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.05';

# Run.
WriteAll();
