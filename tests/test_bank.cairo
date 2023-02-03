%lang starknet
from src.bank import balance, increase_mybal, view_bal, withdraw
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)

@external
func test_increase_balance{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    let (caller) = get_caller_address();
    let (balance_before) = balance.read(caller);
    assert balance_before = 0;

    increase_mybal(100);

    let (balance_after) = balance.read(caller);
    assert balance_after = 100;
    return ();
}

@external
func test_cannot_increase_balance_with_negative_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    let (balance_before) = balance.read(caller);
    assert balance_before = 0;

    %{ expect_revert("TRANSACTION_FAILED", "Amount must be positive") %}
    increase_mybal(-8);

    return ();
}

@external
func test_cannot_increase_if_amount_is_less_than_zero{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
) {
    let (caller) = get_caller_address();
    let (balance_before) = balance.read(caller);
    assert balance_before = 0;

    %{ expect_revert("TRANSACTION_FAILED", "Amount must be greater than zero") %}
    increase_mybal(0);

    return ();
}


@external
func test_cannot_withdraw_with_insufficient_fund{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*
}() {
    let (caller) = get_caller_address();
    let (balance_before) = balance.read(caller);
    assert balance_before = 0;
    increase_mybal(100);

    let (balance_after) = balance.read(caller);
    assert balance_after = 100;

    %{ expect_revert("Not sufficient fund") %}
    withdraw(900, caller);

    return ();
}
