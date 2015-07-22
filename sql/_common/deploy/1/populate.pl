#!perl

use utf8;
use warnings;
use strict;

sub {
    my $schema = shift;

    # FIXME: this first lot is copied verbatim from Interchange6::Schema->deploy
    # so we should move it to a new sub in ic6s so we can just call that

    my $pop_country =
      Interchange6::Schema::Populate::CountryLocale->new->records;
    $schema->resultset('Country')->populate($pop_country)
      or die "Failed to populate Country";

    my $pop_messagetype =
      Interchange6::Schema::Populate::MessageType->new->records;
    $schema->resultset('MessageType')->populate($pop_messagetype)
      or die "Failed to populate MessageType";

    my $pop_role = Interchange6::Schema::Populate::Role->new->records;
    $schema->resultset('Role')->populate($pop_role)
      or die "Failed to populate Role";

    my $pop_state = Interchange6::Schema::Populate::StateLocale->new->records;
    my $states    = $schema->resultset('State')->populate($pop_state)
      or die "Failed to populate State";

    my $min_states_id = $schema->resultset('State')->search(
        {},
        {
            select => [ { min => 'states_id' } ],
            as     => ['min_id'],
        }
    )->first->get_column('min_id');

    my $pop_zone =
      Interchange6::Schema::Populate::Zone->new(
        states_id_initial_value => $min_states_id )->records;
    $schema->resultset('Zone')->populate($pop_zone)
      or die "Failed to populate Zone";

    # end ic6s copy/paste

    my $speaker_attr = $schema->resultset('Attribute')->create(
        {
            name => 'speaker',
            type => 'boolean',
        }
    );

    my $conference = $schema->resultset('Conference')->create(
        {
            name => "Perl Dancer Conference 2015",
        }
    );

    my $rset_media_types = $schema->resultset('MediaType');

    $rset_media_types->populate(
        [ { type => 'image' }, { type => 'video' }, ] );

    my $media_type_image = $rset_media_types->find( { type => 'image' } );

    # email logo
    $schema->resultset('Media')->create(
        {
            file           => "img/perl-dancer-2015-email.jpg",
            uri            => "/img/perl-dancer-2015-email.jpg",
            mime_type      => 'image/jpeg',
            label          => "email-logo",
            media_types_id => $media_type_image->id,
        }
    );

  # username/email, forename, surname, nick, pause id, company, city, state iso,
  # country iso, bio, photo
    my @users = (
        [
            'xsawyerx@gmail.com', 'SawyerX', '', 'SawyerX', 'XSAWYERX',
            'Booking.com', 'Amsterdam', undef, 'NL',
"One of the Dancer authors and a great speaker, SawyerX is joining us this year in Vienna. Along with Andrew Solomon he is giving a Dancer training on the first day of the conference, along with a talk on one of the conference days. Sawyer is very easy to listen to, and this is an exceptional opportunity to attend training from the guy who not only wrote Dancer, but is also really good at explaining things.",
            'sawyerx.png',
        ],
        [
            'andrew@geekuni.com', 'Andrew', 'Solomon', 'illy', 'ILLY',
            'Geekuni',            'London', undef,     'GB',
"Director and Mentor at Geekuni, Andrew is a trainer and practitioner of software development with over 20 years experience in industry and academia. Applications range from scientific research through to retail, with techniques including optimisation algorithms and web services. Currently coding mostly in Perl and jQuery with a webops toolkit for taking projects through to deployment. Experience managing projects using both in-house and contract developers.

Specialties: Perl, E-Learning, Devops, Web services, AWS, Optimization, Mathematics, Computer Science, Linux, DBI, jQuery, OO Design, SQL, Agile and TDD.",
            'andrew-solomon.jpg',
        ],
        [
            'andrew@pullingshots.ca', 'Andrew', 'Baerg', undef, 'BAERGAJ',
            'SOLE', 'Vancouver', 'BC', 'CA', "Andrew graduated from the University of Calgary in 2001 with a Comp Sci degree.He was short after hired on to develop a webstore for Edge Marketing (dba SOLE) in 2001 and went on to open source all of their internal systems. He is currently serving as their COO.",
            'andrew-baerg.jpg',
        ],
        [
            'racke@linuxia.de', 'Stefan', 'Hornburg', 'Racke', 'HORNBURG',
            'Linuxia', 'Hannover', undef, 'DE',
"Stefan is doing E-Commerce and web app development for more than 15 years. He is also volunteering as Debian maintainer. He has written a bunch of Perl modules and as a true open source enthusiast often commits to community.",
            'stefan-hornburg.jpg',
        ],
        [
            'peter@sysnix.com', 'Peter', 'Mottram', 'SysPete', 'SYSPETE',
            'Sysnix', 'Qormi', undef, 'MT',
"e-commerce and Perl developer, Linux, network, firewall and security consultant, Peter has lived and worked in several coutries across Europe since his first IT job as sysadmin at Nokia some 25 years ago. Has since worked for mobile and fixed telcos and spent the last 15 years building Internet-connected platforms for the oil and gas industry, truck telematics, massive online games and many other applications",
            'peter-mottram.jpg',
        ],
        [
            'jure.kodzoman@informastudio.com', 'Jure', 'Kodžoman', undef,
            '', 'Informa Studio Ltd.', 'Split', undef, 'HR',
"Jure works as Head of Development at Informa Studio. He has more than 10 years of active experience in E-Commerce working with different types of clients, from small webshops to large corporations. Strong interest in improving usability and effectiveness of online shopping.",
            'jure-kodzoman.jpg'
        ],
        [
            'grega.pompe@informa.si', 'Grega', 'Pompe', undef, '',
            'Informa Studio Ltd.', 'Ljubljana', undef, 'SI',
"Grega started out as a Python developer but due to circumstances moved to Perl. He is one of the major contributors to TableEditor and Storemail projects as well as a huge DBIx::Class fan.",
            'grega-pompe.jpg',
        ],
        [
            'sbatschelet@mac.com', 'Sam', 'Batschelet', 'hexfusion', '',
            'West Branch Angler', 'New York', 'NY', 'US',
"Sam is CTO of West Branch Angler fishing resort, taking care of tech department of the resort as well as running their fly fishing gear online store.",
            'sam-batschelet.jpg',
        ],
    );

    foreach my $row (@users) {
        my $state =
          $schema->resultset('State')->find( { state_iso_code => $row->[7] } );
        my $mime_type = $row->[10];
        $mime_type =~ s/^.+\./image\//;

        my $user = $schema->resultset('User')->create(
            {
                username   => $row->[0],
                email      => $row->[0],
                first_name => $row->[1],
                last_name  => $row->[2],
                nickname   => $row->[3],
                pause_id   => $row->[4],
                bio        => $row->[9],
                addresses  => [
                    {
                        type             => 'primary',
                        company          => $row->[5],
                        city             => $row->[6],
                        states_id        => $state ? $state->id : undef,
                        country_iso_code => $row->[8],
                    }
                ],
                photo => {
                    file           => "img/people/" . $row->[10],
                    uri            => "/img/people/" . $row->[10],
                    mime_type      => $mime_type,
                    media_types_id => $media_type_image->id,
                },
                user_attributes => [
                    {
                        attributes_id => $speaker_attr->id,
                    }
                ],
                conferences_attended => [
                    {
                        conferences_id => $conference->id,
                        confirmed      => 1,
                    }
                ],
            }
        );
    }

    my $admins = $schema->resultset('User')->search(
        {
            username => {
                -in => [
                    'peter@sysnix.com', 'racke@linuxia.de',
                    'sbatschelet@mac.com'
                ]
            },
        },
        {
            columns => [qw/users_id/],
        }
    );
    while ( my $user = $admins->next ) {
        $user->add_to_roles( { name => 'admin' } );
    }

    my $nav = $schema->resultset('Navigation')->populate(
        [
            {
                uri         => 'speakers',
                type        => 'nav',
                scope       => 'menu-main',
                name        => 'Speakers',
                priority    => 80,
                description => 'Meet Our Speakers!',
            },
            {
                uri      => undef,
                type     => 'nav',
                scope    => 'menu-main',
                name     => 'Talks',
                priority => 60,
                description =>
                  'Schedule draft. Contains talks confirmed so far.',
                children => [
                    {
                        uri         => 'talks',
                        type        => 'nav',
                        name        => 'Talks',
                        description => 'List of talks',
                        priority    => 100,
                    },
                    {
                        uri         => 'talks/submit',
                        type        => 'nav',
                        name        => 'Submit a talk proposal',
                        description => '',
                        priority    => 90,
                    },
                    {
                        uri         => 'talks/favourite',
                        type        => 'nav',
                        name        => 'Favourite Talks',
                        description => '',
                        priority    => 80,
                        active      => 0, # FIXME
                    },
                    {
                        uri         => 'talks/schedule',
                        type        => 'nav',
                        name        => 'Talks Schedule',
                        description => 'Schedule subject to change',
                        priority    => 70,
                    },
                    {
                        uri         => 'talks/timetable.ics',
                        type        => 'nav',
                        name        => 'iCal export',
                        description => '',
                        priority    => 60,
                        active      => 0, # FIXME
                    },
                ],
            },
            {
                uri         => 'tickets',
                type        => 'nav',
                scope       => 'menu-main',
                name        => 'Tickets',
                priority    => 40,
                description => "Get Your Seat Before It's Too Late",
            },
            {
                uri         => undef,
                type        => 'nav',
                scope       => 'menu-main',
                name        => 'Sponsors',
                priority    => 20,
                description => 'Sponsors',
                children    => [
                    {
                        uri         => 'sponsors',
                        type        => 'nav',
                        name        => 'Sponsors',
                        description => 'Conference Sponsors',
                        priority    => 100,
                        active      => 0, # FIXME
                    },
                    {
                        uri         => 'sponsoring',
                        type        => 'nav',
                        name        => 'Sponsoring',
                        description => 'Become a Sponsor!',
                        priority    => 80,
                    },
                ],
            },
            {
                uri         => undef,
                type        => 'nav',
                scope       => 'top-login',
                name        => 'Login',
                priority    => 10,
                description => 'Login or Register',
                children    => [
                    {
                        uri      => 'login',
                        type     => 'nav',
                        name     => 'Login',
                        priority => 100,
                    },
                    {
                        uri      => 'register',
                        type     => 'nav',
                        name     => 'Register for Conference',
                        priority => 80,
                    },
                    {
                        uri      => 'reset_password',
                        type     => 'nav',
                        name     => 'Reset Password',
                        priority => 70,
                    },
                ],
            },
            {
                uri         => undef,
                type        => 'nav',
                scope       => 'top-logout',
                name        => 'My Account',
                priority    => 10,
                description => 'My Account',
                children    => [
                    {
                        uri      => 'logout',
                        type     => 'nav',
                        name     => 'Logout',
                        priority => 100,
                    },
                    {
                        uri      => 'profile',
                        type     => 'nav',
                        name     => 'My Profile',
                        priority => 80,
                        children => [
                            {
                                uri      => 'profile/edit',
                                type     => 'nav',
                                name     => 'Update your profile',
                                priority => 100,
                            },
                            {
                                uri      => 'profile/photo',
                                type     => 'nav',
                                name     => 'Manage your photo',
                                priority => 80,
                            },
                            {
                                uri      => 'profile/password',
                                type     => 'nav',
                                name     => 'Change your password',
                                priority => 60,
                            },
                        ],
                    },
                ],
            },
        ]
    );

    my $nav_tickets =
      $schema->resultset('Navigation')->find( { uri => 'tickets' } );

    my $products = $schema->resultset('Product')->populate(
        [
            {
                sku               => "2015PERLDANCE2DAYS",
                name              => "PerlDancer 2015 Conference only ticket",
                short_description => "Conference Only",
                uri               => "perl-dancer-2015-conference-only",
                priority          => 50,
                inventory_exempt  => 1,
                price             => 159,
                navigation_products =>
                  [ { navigation_id => $nav_tickets->id }, ],
                description => "Valid for 2 conference days

21 and 22 of October

Entrance to all talks

Includes social event

Includes free T-Shirt",
            },
            {
                sku  => "2015PERLDANCE4DAYS",
                name => "PerlDancer 2015 Conference + Training Ticket",
                short_description => "Conference + Training",
                uri               => "perl-dancer-2015-conference-and-training",
                priority          => 100,
                inventory_exempt  => 1,
                price             => 249,
                navigation_products =>
                  [ { navigation_id => $nav_tickets->id }, ],
                description => "Four Day Full Access

Includes all training sessions

Includes all conference days

Includes social event

Includes free T-Shirt",
            },
        ]
    );

    $schema->resultset('Talk')->create(
        {
            author_id => $schema->resultset('User')->find( { username => 'andrew@geekuni.com' }, { columns => 'users_id' } )->id,
            conferences_id => $conference->id,
            duration       => 240,
            start_time =>
              DateTime->new( year => 2015, month => 10, day => 19, hour => 9 ),
            title => 'Web development using Dancer',
            tags  => 'Dancer training Template::Toolkit MVC',
            abstract =>
q(A hands-on training session to develop a website with dynamic content in Dancer.

From doing the exercises you will learn to use the Dancer framework, learn to use Template Toolkit, understand the concept of Model-View-Controller, experience structuring code for maintainability, experience using object oriented modules. To attend this session you should have basic knowledge of Perl (but you can join if you have any programming experience), and you should be able to use Linux command line and text editor (like vi/emacs/pico).),
            accepted  => 1,
            confirmed => 1,
            room      => 'Amerikahaus',
        }
    );
    $schema->resultset('Talk')->create(
        {
            author_id => $schema->resultset('User')->find( { username => 'racke@linuxia.de' }, { columns => 'users_id' } )->id,
            conferences_id => $conference->id,
            duration       => 40,
            title          => 'Template Flute',
            tags           => 'Dancer Template::Flute',
            abstract       => 'Flutey flute',
        }
    );
    $schema->resultset('Talk')->create(
        {
            author_id => $schema->resultset('User')->find( { username => 'peter@sysnix.com' }, { columns => 'users_id' } )->id,
            conferences_id => $conference->id,
            duration       => 20,
            start_time =>
              DateTime->new( year => 2015, month => 10, day => 21, hour => 14 ),
            title    => 'Dancing on the roof',
            tags     => 'Dancer',
            abstract => 'More Dancer',
        }
    );
    $schema->resultset('Talk')->create(
        {
            author_id => $schema->resultset('User')->find( { username => 'sbatschelet@mac.com'}, { columns => 'users_id' } )->id,
            conferences_id => $conference->id,
            duration       => 40,
            start_time =>
              DateTime->new( year => 2015, month => 10, day => 21, hour => 11 ),
            title => 'Space Camp :: The Final Frontier',
            tags  => 'CoreOS Development Platform',
            abstract =>
'Learn about a new development platform using the newest in open source cloud systems CoreOS and rkt (Rocket).',
            accepted  => 1,
            confirmed => 1,
        }
    );
};
