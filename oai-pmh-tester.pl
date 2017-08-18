#!/usr/bin/perl

use Modern::Perl;
use Getopt::Long;
use HTTP::OAI;

my $verbose = 0;
my $base_url;
my $identifier;
my $archive_id      = 'KOHA-OAI-TEST';
my $metadata_prefix = 'marcxml';

GetOptions(
    "u|url=s"             => \$base_url,
    "a|archive-id=s"      => \$archive_id,
    "i|identifier=s"      => \$identifier,
    "m|metadata-prefix=s" => \$metadata_prefix,
    "v|verbose+"          => \$verbose
) or die("Error in command line arguments\n");

unless ( $base_url && $identifier ) {
    say "$0 -u <base url> -i <record id> -m marcxml -v";
    exit 1;
}

my $h = new HTTP::OAI::Harvester( baseURL => $base_url );

my $gr_response = $h->GetRecord(
    identifier     => "$archive_id:$identifier",
    metadataPrefix => $metadata_prefix,
);
my $record = $gr_response->next;
die $record->message if $record->is_error;

say "RECORD:";
say "  Identifier: ", $record->identifier();
say "   DateStamp: ", $record->datestamp();
say "      Status: ", $record->status() || q{};
say "     Deleted: ", $record->is_deleted();

my $dom = $record->metadata->dom;
say "\nRECORD DOM:\n", $dom if $verbose;
