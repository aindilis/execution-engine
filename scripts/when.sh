#!/bin/bash

corpus -s . --lt 10000 | perl -M-"KBS2::ImportExport::Wrapper" -ne '/^\W+when (.+?), (.+?)\W+$/i and print "when(".KBS2::ImportExport::Wrapper::QuoteProlog($1).",".KBS2::ImportExport::Wrapper::QuoteProlog($2).").\n"'
