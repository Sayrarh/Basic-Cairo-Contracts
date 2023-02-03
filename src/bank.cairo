%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (assert_nn, assert_not_zero, assert_le)
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)


//A mapping that stores users funds
@storage_var
func balance(account: felt) -> (res: felt) {
}

//contract constructor
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){
  let (contarct) = get_contract_address();
  //initialize the contract with 20
  balance.write(contarct, 20);
  return ();
}

//let's write to the balance mapping 
@external
func increase_mybal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    amount: felt
) {
  let (caller) = get_caller_address(); //msg.sender
   //require that the amount being passed in is greater than zero
   with_attr error_message("Amount must be positive. Got: {amount}.") {
        assert_nn(amount);
    }
   with_attr error_message("Amount must be greater than zero. Got: {amount}.") {
        assert_not_zero(amount);
    } 
  //get the balance of the user/account
  let (res) = balance.read(caller);
  balance.write(caller, res + amount);
  return ();
}

//view your balance
@view
func view_bal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (res: felt){
  let (res) = balance.read(account);
  return (res, );
}

//OR 
// @view
// func get_balance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt){
//    let (caller) = get_caller_address();
//    let(res) = balance.read(caller);

//    return (res,);
// }


//function to withdraw
@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, amount: felt
) {
    let (res) = balance.read(account);
    
    with_attr error_message("Amount must be positive. Got: {amount}.") {
        assert_nn(amount);
    }
    //check if account as funds in this contract
    with_attr error_message("Not sufficient fund") {
        assert_le(amount, res); //???

   } 
    let new_balance = res - amount;
    
    balance.write(account, amount);// want to write to transfer??
    return ();
}

