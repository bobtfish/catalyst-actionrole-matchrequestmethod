package Catalyst::ActionRole::MatchRequestMethod;
# ABSTRACT: Dispatch actions based on HTTP request methods

use Moose::Role;
use Perl6::Junction 'none';
use namespace::autoclean;

=head1 SYNOPSIS

    package MyApp::Controller::Foo;

    use Moose;
    use namespace::autoclean;

    BEGIN {
        extends 'Catalyst::Controller::ActionRole';
    }

    __PACKAGE__->config(
        action_roles => ['MatchRequestMethod'],
    );

    sub get_foo    : Path Method('GET')                { ... }
    sub update_foo : Path Method('POST')               { ... }
    sub create_foo : Path Method('PUT')                { ... }
    sub delete_foo : Path Method('DELETE')             { ... }
    sub foo        : Path Method('GET') Method('POST') { ... }

=head1 DESCRIPTION

This module allows you to write L<Catalyst> actions which only match certain
HTTP request methods. Actions which would normally be dispatched to will not
match if the request method is incorrect, allowing less specific actions to
match the path instead.

=cut

requires 'attributes';

around match => sub {
    my ($orig, $self, $ctx) = @_;
    my @methods = @{ $self->attributes->{Method} || [] };

    # if no request methods have been specified, we still match normally. that
    # doesn't feel very correcy, but dwims very well, especially if you're
    # applying the role to all actions using the controller config. this might
    # be subject to change.
    return 0 if @methods && $ctx->request->method eq none @methods;

    return $self->$orig($ctx);
};

=head1 SEE ALSO

L<Catalyst::Controller::ActionRole>

L<Catalyst::Action::REST>

inspired by: L<http://dev.catalystframework.org/wiki/gettingstarted/howtos/HTTP_method_matching_for_actions>

=cut

1;
