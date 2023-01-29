%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
//Write a simple contract that store a value

@storage_var
func message() -> (res: felt) {
}

@external
func write_msg{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    my_message: felt
) {

    message.write(my_message);
    return ();
}

//read message value
@view
func read_message{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt){
  let (res) = message.read();
  return (res,);
}