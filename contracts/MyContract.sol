pragma solidity ^0.7.6;
contract MyContract{
	mapping(address => User) public balances;
	uint public interest;
	bool internal lock;
    struct User{
    	uint amount;
    	uint time;
    }
	event locked( address depositor , uint amount);
	event withdrawn(address withdrawer , uint amount);
	modifier mutex(){
        require(!lock , "contract is locked");
        lock = true;
       _;
       lock= false;
	}
	constructor(uint _interest ){
		interest = _interest;
	}
	function deposit(uint _time) public payable {
         address _depositor = msg.sender;
         uint _amount = msg.value;
         balances[_depositor].amount += msg.value;
         balances[_depositor].time = _time * 1 days;
         emit locked(msg.sender , msg.value);
	}
	function calculate(address depositor) internal returns (uint) {
		uint earned = 1 + interest*balances[depositor].time ;
        balances[depositor].amount *= earned;
        uint amount1 = balances[depositor].amount;
        return amount1;
        

	}
	function withdraw() public  mutex {
	     address payable withdrawer = msg.sender;
		 uint money= calculate(withdrawer);
		balances[msg.sender].amount = 0;
       (bool success , ) = withdrawer.call{value : money}("");
       require(success);
	
		

	}

}