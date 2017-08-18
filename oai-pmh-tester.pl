#!/usr/bin/perl

use Modern::Perl;
use Net::OAI::Harvester;
use Getopt::Long;

my $verbose = 0;
my $base_url;
my $identifier;
my $archive_id = 'KOHA-OAI-TEST';
my $metadataPrefix = 'marcxml';

GetOptions(
    "u|url=s"             => \$base_url,
    "a|archive-id=s"      => \$archive_id,
    "i|identifier=s"      => \$identifier,
    "m|metadata-prefix=s" => \$metadataPrefix,
    "v|verbose"           => \$verbose
) or die("Error in command line arguments\n");

unless ( $base_url && $identifier ) {
    say "$0 -u <base url> -i <record id> -m marcxml -v";
    exit 1;
}

my $harvester = Net::OAI::Harvester->new( baseURL => $base_url );

my $identity = $harvester->identify();
say "SERVER: ";
say " name: ", $identity->repositoryName();

my $result = $harvester->getRecord(
    identifier     => "$archive_id:$identifier",
    metadataPrefix => $metadataPrefix,
);

## get the result as Net::OAI::Record object
my $record = $result->record();    # undef if error
say "RECORD: $record";
say $record->recorddata();

## directly get the Net::OAI::Record::Header object
my $header = $result->header();    # undef if error
say "HEADER:";
say " status: ",     $header->status();
say " identifier: ", $header->identifier();
say " datestamp: ",  $header->datestamp();

## get the metadata object
my $metadata =
  $result->metadata();    # undef if error or harvested with recordHandler
say "METADATA:";
say "  identifier: ", $header->identifier();
say "       title: ", $metadata->title();
say "     creator: ", $metadata->creator();
say "     subject: ", $metadata->subject();
say " description: ", $metadata->description();
say "   publisher: ", $metadata->publisher();
say " contributor: ", $metadata->contributor();
say "        date: ", $metadata->date();
say "        type: ", $metadata->type();
say "      format: ", $metadata->format();
say "      source: ", $metadata->source();
say "    language: ", $metadata->language();
say "    relation: ", $metadata->relation();
say "    coverage: ", $metadata->coverage();
say "      rights: ", $metadata->rights();

