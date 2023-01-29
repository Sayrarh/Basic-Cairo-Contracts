%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (get_caller_address)
//Build a program that stores students’ records (name, age, gender).

//Your contract should have a storage variable **admin_address** that stores an admin address.
//Your contract should have a storage variable **student_details** that maps the student’s address to their details.
//It should have a **constructor** that takes in an *address* argument and initialises it as the *admin*.
//It should have an external function **store_details** that takes in *name*, *age*, and *gender* as arguments to be stored in the *student_details* storage variable.
//It should have a view function **get_name** that takes in a student’s address and returns the student’s name.

struct StudentRecords{
   studentName: felt,
   studentAge: felt,
   studentGender: felt,
}

//contract admin
@storage_var
func admin() -> (res: felt) {
}

//mapping of student address to their record
@storage_var
func student_details(student_addr: felt) -> (student_struct: StudentRecords) {
}


@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) {
  admin.write(account);

  return ();
}

//view a student's name from their record
@view
func get_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (res: felt){
  let(studetails) = student_details.read(account);
  let name = studetails.studentName;
  return (res=name);
}


@external
func store_details{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, age: felt, gender:felt
) {
  let (caller) = get_caller_address();
  let stu_record = StudentRecords(studentName=name, studentAge=age, studentGender=gender);// pointer
  student_details.write(caller, stu_record);

  return ();
}



