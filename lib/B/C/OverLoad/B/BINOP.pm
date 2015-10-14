package B::BINOP;

use strict;

use B::C::File qw/binopsect init/;
use B::C::Helpers qw/do_labels/;
use B::C::Helpers::Symtable qw/savesym/;

sub save {
    my ( $op, $level ) = @_;

    my $sym = B::objsym($op);
    return $sym if defined $sym;

    binopsect->comment_common("first, last");
    binopsect->add( sprintf( "%s, s\\_%x, s\\_%x", $op->_save_common, ${ $op->first }, ${ $op->last } ) );
    binopsect->debug( $op->name, $op->flagspv );
    my $ix = binopsect->index;
    init->add( sprintf( "binop_list[%d].op_ppaddr = %s;", $ix, $op->ppaddr ) )
      unless $B::C::optimize_ppaddr;
    $sym = savesym( $op, "(OP*)&binop_list[$ix]" );
    do_labels( $op, 'first', 'last' );
    $sym;
}

1;
