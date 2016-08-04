# NAME

Perl-Dancer-Conference - Perl Dancer Conference website

# MAPS

The maps are loaded by the Javascript in public/js/index.js.

# Sidebar

The sidebar is located in views/fragments/sidebar and shown
depending on show_sidebar value.

# Geo::IP lookups

On a Debian system install the following packages:

```
geoip-bin libgeoip-dev geoip-database-contrib
```

# DB deployment instructions

* Install PostgreSQL
* Install PerlDancer with dependencies with ``cpanm .`` in a Git checkout directory
* psql create perldance
* ./bin/dh-install
* ./bin/dh-prepare-upgrade && ./bin/dh-upgrade
* Done!
